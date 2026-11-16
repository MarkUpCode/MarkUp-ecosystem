package com.markup.dinerop.credit.domain.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.markup.dinerop.credit.domain.model.CreditGuarantorEvaluation;
import com.markup.dinerop.credit.domain.model.CreditGuarantorSubmission;
import com.markup.dinerop.credit.domain.model.enums.CreditGuarantorStatus;
import com.markup.dinerop.credit.infrastructure.repository.CreditGuarantorEvaluationRepository;
import com.markup.dinerop.credit.infrastructure.repository.CreditGuarantorSubmissionRepository;
import com.markup.dinerop.credit.infrastructure.repository.CreditRequestRepository;
import com.markup.dinerop.credit.infrastructure.repository.SolicitudCooperativaRepository;
import com.markup.dinerop.onboarding.infrastructure.mapper.OnboardingMapper;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class CreditGuarantorWorkflowServiceTest {
    @Mock CreditGuarantorSubmissionRepository submissionRepository;
    @Mock CreditGuarantorEvaluationRepository evaluationRepository;
    @Mock SolicitudCooperativaRepository cooperativeRepository;
    @Mock CreditRequestRepository creditRequestRepository;
    @Mock OnboardingMapper onboardingMapper;

    CreditGuarantorWorkflowService service;

    @BeforeEach
    void setUp() {
        service = new CreditGuarantorWorkflowService(submissionRepository, evaluationRepository,
                cooperativeRepository, creditRequestRepository, onboardingMapper, new ObjectMapper());
    }

    @Test
    void acceptsOnlyCurrentSubmissionAndRecordsDecisionActor() {
        CreditGuarantorSubmission submission = submission(CreditGuarantorStatus.EN_REVISION);
        when(submissionRepository.findForUpdate(5L)).thenReturn(Optional.of(submission));

        service.recordDecision(5L, "ACEPTAR", List.of(), null, "Verificado", 8L, "COOPERATIVE");

        assertEquals(CreditGuarantorStatus.ACEPTADO, submission.getStatus());
        ArgumentCaptor<CreditGuarantorEvaluation> evaluation = ArgumentCaptor.forClass(CreditGuarantorEvaluation.class);
        verify(evaluationRepository).save(evaluation.capture());
        assertEquals(8L, evaluation.getValue().getActorId());
        assertEquals("COOPERATIVE", evaluation.getValue().getActorRole());
        assertEquals("Verificado", evaluation.getValue().getObservation());
    }

    @Test
    void correctionAndGuarantorRejectionCloseOnlyTheirOwnSubmission() {
        CreditGuarantorSubmission correction = submission(CreditGuarantorStatus.EN_REVISION);
        when(submissionRepository.findForUpdate(5L)).thenReturn(Optional.of(correction));
        service.recordDecision(5L, "SOLICITAR_CORRECCION", List.of("Actualizar dirección"), null, null, 8L, "COOPERATIVE");
        assertEquals(CreditGuarantorStatus.CORRECCION_SOLICITADA, correction.getStatus());

        CreditGuarantorSubmission rejectedGuarantor = submission(CreditGuarantorStatus.EN_REVISION);
        when(submissionRepository.findForUpdate(6L)).thenReturn(Optional.of(rejectedGuarantor));
        service.recordDecision(6L, "RECHAZAR_GARANTE", List.of("No cumple"), null, null, 8L, "COOPERATIVE");
        assertEquals(CreditGuarantorStatus.RECHAZADO, rejectedGuarantor.getStatus());
        verify(evaluationRepository, times(2)).save(any(CreditGuarantorEvaluation.class));
    }

    @Test
    void rejectingCreditIsDistinctFromRejectingTheGuarantor() {
        CreditGuarantorSubmission submission = submission(CreditGuarantorStatus.EN_REVISION);
        when(submissionRepository.findForUpdate(5L)).thenReturn(Optional.of(submission));

        service.recordDecision(5L, "RECHAZAR_SOLICITUD", List.of("Riesgo"), null, "No elegible", 8L, "COOPERATIVE");

        assertEquals(CreditGuarantorStatus.SOLICITUD_RECHAZADA, submission.getStatus());
        verify(evaluationRepository).save(argThat(evaluation -> "RECHAZAR_SOLICITUD".equals(evaluation.getDecision())));
    }

    @Test
    void resolvedSubmissionCannotBeModifiedAgain() {
        CreditGuarantorSubmission submission = submission(CreditGuarantorStatus.ACEPTADO);
        when(submissionRepository.findForUpdate(5L)).thenReturn(Optional.of(submission));

        assertThrows(IllegalStateException.class, () -> service.recordDecision(
                5L, "RECHAZAR_GARANTE", List.of("No cumple"), null, null, 8L, "COOPERATIVE"));
        verify(evaluationRepository, never()).save(any());
    }

    private CreditGuarantorSubmission submission(CreditGuarantorStatus status) {
        return CreditGuarantorSubmission.builder().id(5L).status(status).build();
    }
}
