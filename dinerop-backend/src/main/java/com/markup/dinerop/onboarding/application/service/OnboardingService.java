package com.markup.dinerop.onboarding.application.service;

import com.markup.dinerop.onboarding.domain.entity.SolicitudOnboarding;
import com.markup.dinerop.onboarding.dto.request.PersonaOnboardingRequest;
import com.markup.dinerop.onboarding.dto.request.SolicitudOnboardingRequest;
import com.markup.dinerop.onboarding.dto.response.FormularioClienteStatusResponse;
import com.markup.dinerop.onboarding.dto.response.PreRegistrationDataResponse;
import com.markup.dinerop.onboarding.dto.response.GuarantorProfileResponse;
import java.util.List;

public interface OnboardingService {

    SolicitudOnboarding crearSolicitudConSolicitante(
            Long clientId,
            SolicitudOnboardingRequest request
    );

    SolicitudOnboarding solicitarGarante(Long solicitudId, Long cooperativaId);

    SolicitudOnboarding crearYCompletarGaranteDesdeCliente(
            Long clientId,
            Long creditRequestId,
            Long cooperativaId,
            Long guarantorProfileId,
            PersonaOnboardingRequest request
    );

    List<GuarantorProfileResponse> getGuarantorProfiles(Long clientId);

    SolicitudOnboarding obtenerOnboardingUnificado(Long solicitudId);

    FormularioClienteStatusResponse getFormularioClienteStatus(Long usuarioId);

    PreRegistrationDataResponse getPreRegistrationData(Long userId);
}
