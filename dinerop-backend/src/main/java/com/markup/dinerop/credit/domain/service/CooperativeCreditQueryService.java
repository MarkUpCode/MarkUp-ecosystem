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
import com.markup.dinerop.auth.repository.UserPreRegistrationRepository;
import com.markup.dinerop.auth.repository.UserRepository;

@Service
@RequiredArgsConstructor
public class CooperativeCreditQueryService {

    private final SolicitudCooperativaRepository solicitudCooperativaRepository;
    private final SolicitudOnboardingRepository solicitudOnboardingRepository;
    private final PersonaOnboardingRepository personaOnboardingRepository;
    private final UserPreRegistrationRepository preRegistrationRepository;
    private final UserRepository userRepository;

    @Transactional(readOnly = true)
    public List<CooperativeCreditRequestItemDto> getRequestsForCooperative(Long cooperativaId) {
        return solicitudCooperativaRepository.findRequestsByCooperativaId(cooperativaId);
    }

    private CooperativeCreditRequestItemDto withApplicant(CooperativeCreditRequestItemDto item) {
        Long userId = item.clientId();
        if (userId == null && item.email() != null) {
            userId = userRepository.findByEmail(item.email().trim().toLowerCase())
                    .map(user -> user.getIdUser()).orElse(null);
        }

        PersonaOnboarding applicant = null;
        if (userId != null) {
            var onboarding = solicitudOnboardingRepository.findByUsuarioId(userId).orElse(null);
            if (onboarding != null) {
                applicant = onboarding.getPersonas().stream()
                        .filter(persona -> persona.getRol() == RolPersona.SOLICITANTE)
                        .findFirst()
                        .orElse(null);
            }
        }

        String nombre = applicant == null ? null : (applicant.getNombres() + " " + applicant.getApellidos()).trim();
        String cedula = applicant == null ? null : applicant.getCedula();
        if ((nombre == null || nombre.isBlank() || cedula == null || cedula.isBlank()) && userId != null) {
            var preRegistration = preRegistrationRepository.findByUserId(userId).orElse(null);
            if (preRegistration != null) {
                nombre = (preRegistration.getFirstName() + " " + preRegistration.getLastName()).trim();
                cedula = preRegistration.getIdentification();
            }
        }
        if (nombre == null && cedula == null) return item;
        return new CooperativeCreditRequestItemDto(
                item.solicitudId(), item.clientId(), item.email(), item.montoSolicitado(), item.tipo(),
                item.fechaSolicitud(), item.estado(),
                nombre,
                cedula
        );
    }
}

