package com.markup.dinerop.credit.domain.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.markup.dinerop.credit.domain.model.CreditGuarantorEvaluation;
import com.markup.dinerop.credit.domain.model.CreditGuarantorSubmission;
import com.markup.dinerop.credit.domain.model.SolicitudCooperativa;
import com.markup.dinerop.credit.domain.model.enums.CreditGuarantorStatus;
import com.markup.dinerop.credit.domain.model.enums.SolicitudCooperativaStatus;
import com.markup.dinerop.credit.dto.CreditGuarantorEvaluationDto;
import com.markup.dinerop.credit.dto.CreditGuarantorHistoryItemDto;
import com.markup.dinerop.credit.infrastructure.repository.CreditGuarantorEvaluationRepository;
import com.markup.dinerop.credit.infrastructure.repository.CreditGuarantorSubmissionRepository;
import com.markup.dinerop.credit.infrastructure.repository.CreditRequestRepository;
import com.markup.dinerop.credit.infrastructure.repository.SolicitudCooperativaRepository;
import com.markup.dinerop.onboarding.domain.entity.PersonaOnboarding;
import com.markup.dinerop.onboarding.dto.response.PersonaOnboardingResponse;
import com.markup.dinerop.onboarding.infrastructure.mapper.OnboardingMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class CreditGuarantorWorkflowService {
    private final CreditGuarantorSubmissionRepository submissionRepository;
    private final CreditGuarantorEvaluationRepository evaluationRepository;
    private final SolicitudCooperativaRepository solicitudCooperativaRepository;
    private final CreditRequestRepository creditRequestRepository;
    private final OnboardingMapper onboardingMapper;
    private final ObjectMapper objectMapper;

    @Transactional
    public CreditGuarantorSubmission registerSubmission(Long solicitudId, Long cooperativaId, Long clientId,
                                                         Long profileId, PersonaOnboarding persona) {
        var request = creditRequestRepository.findById(solicitudId)
                .filter(candidate -> clientId.equals(candidate.getClientId()))
                .orElseThrow(() -> new AccessDeniedException("La solicitud no pertenece al cliente autenticado"));
        SolicitudCooperativa cooperativeRequest = solicitudCooperativaRepository
                .findBySolicitudIdAndCooperativaId(solicitudId, cooperativaId)
                .orElseThrow(() -> new IllegalStateException("Solicitud de cooperativa no encontrada"));
        if (cooperativeRequest.getEstado() != SolicitudCooperativaStatus.SOLICITANDO_GARANTE) {
            throw new IllegalStateException("La cooperativa no está esperando información de garante");
        }
        submissionRepository.findTopBySolicitudCooperativaIdOrderByAttemptNumberDesc(cooperativeRequest.getId())
                .filter(previous -> previous.getStatus() == CreditGuarantorStatus.EN_REVISION)
                .ifPresent(previous -> { throw new IllegalStateException("La información del garante ya está en revisión"); });

        PersonaOnboardingResponse snapshot = onboardingMapper.toPersonaResponse(persona);
        CreditGuarantorSubmission submission = CreditGuarantorSubmission.builder()
                .profileId(profileId).creditRequestId(request.getId())
                .solicitudCooperativaId(cooperativeRequest.getId())
                .attemptNumber((int) submissionRepository.countBySolicitudCooperativaId(cooperativeRequest.getId()) + 1)
                .snapshotJson(writeJson(snapshot)).status(CreditGuarantorStatus.EN_REVISION).submittedBy(clientId).build();
        submission = submissionRepository.save(submission);
        appendEvaluation(submission.getId(), "ENVIADO", List.of(), null,
                "El cliente envió la información del garante para esta solicitud.", clientId, "CLIENT");
        return submission;
    }

    @Transactional
    public void recordDecision(Long submissionId, String decision, List<String> reasons, String otherReason,
                               String observation, Long actorId, String actorRole) {
        CreditGuarantorSubmission submission = submissionRepository.findForUpdate(submissionId)
                .orElseThrow(() -> new IllegalStateException("Envío de garante no encontrado"));
        if (submission.getStatus() != CreditGuarantorStatus.EN_REVISION) {
            throw new IllegalStateException("La evaluación del garante ya fue resuelta y no se puede modificar");
        }
        CreditGuarantorStatus nextStatus = switch (decision) {
            case "ACEPTAR" -> CreditGuarantorStatus.ACEPTADO;
            case "SOLICITAR_CORRECCION" -> CreditGuarantorStatus.CORRECCION_SOLICITADA;
            case "RECHAZAR_GARANTE" -> CreditGuarantorStatus.RECHAZADO;
            case "RECHAZAR_SOLICITUD" -> CreditGuarantorStatus.SOLICITUD_RECHAZADA;
            default -> throw new IllegalArgumentException("Decisión de garante no reconocida");
        };
        submission.setStatus(nextStatus);
        submissionRepository.save(submission);
        appendEvaluation(submissionId, decision, reasons, otherReason, observation, actorId, actorRole);
    }

    @Transactional(readOnly = true)
    public List<CreditGuarantorHistoryItemDto> historyForCooperative(Long solicitudId, Long cooperativaId) {
        SolicitudCooperativa sc = solicitudCooperativaRepository.findBySolicitudIdAndCooperativaId(solicitudId, cooperativaId)
                .orElseThrow(() -> new AccessDeniedException("Solicitud no pertenece a esta cooperativa"));
        return history(submissionRepository.findBySolicitudCooperativaIdOrderByAttemptNumberDesc(sc.getId()), cooperativaId);
    }

    @Transactional(readOnly = true)
    public List<CreditGuarantorHistoryItemDto> historyForClient(Long clientId, Long solicitudId, Long cooperativaId) {
        creditRequestRepository.findById(solicitudId).filter(request -> clientId.equals(request.getClientId()))
                .orElseThrow(() -> new AccessDeniedException("La solicitud no pertenece al cliente autenticado"));
        SolicitudCooperativa sc = solicitudCooperativaRepository.findBySolicitudIdAndCooperativaId(solicitudId, cooperativaId)
                .orElseThrow(() -> new IllegalArgumentException("No existe una respuesta de esa cooperativa para el crédito"));
        return history(submissionRepository.findBySolicitudCooperativaIdOrderByAttemptNumberDesc(sc.getId()), cooperativaId);
    }

    @Transactional(readOnly = true)
    public CreditGuarantorSubmission latestSubmission(Long solicitudCooperativaId) {
        return submissionRepository.findTopBySolicitudCooperativaIdOrderByAttemptNumberDesc(solicitudCooperativaId).orElse(null);
    }

    private List<CreditGuarantorHistoryItemDto> history(List<CreditGuarantorSubmission> submissions, Long cooperativaId) {
        if (submissions.isEmpty()) return List.of();
        Map<Long, List<CreditGuarantorEvaluation>> evaluations = evaluationRepository
                .findBySubmissionIdInOrderByCreatedAtAscIdAsc(submissions.stream().map(CreditGuarantorSubmission::getId).toList())
                .stream().collect(java.util.stream.Collectors.groupingBy(CreditGuarantorEvaluation::getSubmissionId));
        return submissions.stream().map(submission -> new CreditGuarantorHistoryItemDto(
                submission.getId(), submission.getProfileId(), submission.getCreditRequestId(), cooperativaId,
                submission.getAttemptNumber(), submission.getStatus().name(), submission.getSubmittedAt(),
                readSnapshot(submission.getSnapshotJson()), evaluations.getOrDefault(submission.getId(), List.of()).stream()
                        .map(this::toEvaluationDto).toList()
        )).toList();
    }

    private CreditGuarantorEvaluationDto toEvaluationDto(CreditGuarantorEvaluation evaluation) {
        List<String> reasons;
        try { reasons = evaluation.getReasonsJson() == null ? List.of() : objectMapper.readValue(evaluation.getReasonsJson(), new TypeReference<>() {}); }
        catch (JsonProcessingException exception) { reasons = List.of(); }
        return new CreditGuarantorEvaluationDto(evaluation.getId(), evaluation.getDecision(), reasons,
                evaluation.getOtherReason(), evaluation.getObservation(), evaluation.getActorId(), evaluation.getActorRole(), evaluation.getCreatedAt());
    }

    private void appendEvaluation(Long submissionId, String decision, List<String> reasons, String otherReason,
                                  String observation, Long actorId, String actorRole) {
        evaluationRepository.save(CreditGuarantorEvaluation.builder().submissionId(submissionId).decision(decision)
                .reasonsJson(writeJson(reasons == null ? List.of() : reasons)).otherReason(otherReason)
                .observation(observation).actorId(actorId).actorRole(actorRole).build());
    }

    private String writeJson(Object value) {
        try { return objectMapper.writeValueAsString(value); }
        catch (JsonProcessingException exception) { throw new IllegalStateException("No se pudo guardar la fotografía del garante", exception); }
    }

    private PersonaOnboardingResponse readSnapshot(String value) {
        try { return objectMapper.readValue(value, PersonaOnboardingResponse.class); }
        catch (JsonProcessingException exception) { throw new IllegalStateException("Fotografía histórica del garante inválida", exception); }
    }
}
