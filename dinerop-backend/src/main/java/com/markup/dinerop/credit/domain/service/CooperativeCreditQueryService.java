package com.markup.dinerop.credit.domain.service;

import com.markup.dinerop.credit.dto.CooperativeCreditRequestItemDto;
import com.markup.dinerop.credit.infrastructure.repository.SolicitudCooperativaRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import com.markup.dinerop.onboarding.domain.entity.PersonaOnboarding;
import com.markup.dinerop.onboarding.domain.enums.RolPersona;
import com.markup.dinerop.onboarding.infrastructure.repository.PersonaOnboardingRepository;
import com.markup.dinerop.onboarding.infrastructure.repository.SolicitudOnboardingRepository;

@Service
@RequiredArgsConstructor
public class CooperativeCreditQueryService {

    private final SolicitudCooperativaRepository solicitudCooperativaRepository;
    private final SolicitudOnboardingRepository solicitudOnboardingRepository;
    private final PersonaOnboardingRepository personaOnboardingRepository;

    @Transactional(readOnly = true)
    public List<CooperativeCreditRequestItemDto> getRequestsForCooperative(Long cooperativaId) {
        return solicitudCooperativaRepository.findRequestsByCooperativaId(cooperativaId)
                .stream()
                .map(this::withApplicant)
                .toList();
    }

    private CooperativeCreditRequestItemDto withApplicant(CooperativeCreditRequestItemDto item) {
        if (item.clientId() == null) {
            return item;
        }
        var onboarding = solicitudOnboardingRepository.findByUsuarioId(item.clientId()).orElse(null);
        if (onboarding == null) return item;
        PersonaOnboarding applicant = onboarding.getPersonas().stream()
                .filter(persona -> persona.getRol() == RolPersona.SOLICITANTE)
                .findFirst()
                .orElse(null);
        if (applicant == null) return item;
        return new CooperativeCreditRequestItemDto(
                item.solicitudId(), item.clientId(), item.montoSolicitado(), item.tipo(),
                item.fechaSolicitud(), item.estado(),
                (applicant.getNombres() + " " + applicant.getApellidos()).trim(),
                applicant.getCedula()
        );
    }
}

