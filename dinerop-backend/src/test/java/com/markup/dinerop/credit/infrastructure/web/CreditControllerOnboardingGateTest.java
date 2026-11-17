package com.markup.dinerop.credit.infrastructure.web;

import com.markup.dinerop.auth.entity.User;
import com.markup.dinerop.credit.domain.model.enums.CreditRequestStatus;
import com.markup.dinerop.credit.domain.service.ClientCreditAcceptanceService;
import com.markup.dinerop.credit.domain.service.ClientCreditCooperativeStatusService;
import com.markup.dinerop.credit.domain.service.ClientCreditQueryService;
import com.markup.dinerop.credit.domain.service.CooperativeCreditDecisionService;
import com.markup.dinerop.credit.domain.service.CooperativeCreditQueryService;
import com.markup.dinerop.credit.domain.service.CreditService;
import com.markup.dinerop.credit.dto.ClientCreditRequestDto;
import com.markup.dinerop.credit.infrastructure.repository.CreditProcessEventRepository;
import com.markup.dinerop.credit.infrastructure.repository.SolicitudCooperativaRepository;
import com.markup.dinerop.credit.service.CreditReferralPdfService;
import com.markup.dinerop.credit.service.CreditRequirementService;
import com.markup.dinerop.onboarding.application.service.OnboardingService;
import com.markup.dinerop.onboarding.domain.enums.EstadoFormulario;
import com.markup.dinerop.onboarding.dto.response.FormularioClienteStatusResponse;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class CreditControllerOnboardingGateTest {

    @Mock CreditService creditService;
    @Mock ClientCreditQueryService clientCreditQueryService;
    @Mock CooperativeCreditQueryService cooperativeCreditQueryService;
    @Mock CooperativeCreditDecisionService cooperativeCreditDecisionService;
    @Mock ClientCreditCooperativeStatusService clientCreditCooperativeStatusService;
    @Mock ClientCreditAcceptanceService clientCreditAcceptanceService;
    @Mock CreditRequirementService creditRequirementService;
    @Mock CreditReferralPdfService creditReferralPdfService;
    @Mock CreditProcessEventRepository creditProcessEventRepository;
    @Mock SolicitudCooperativaRepository solicitudCooperativaRepository;
    @Mock OnboardingService onboardingService;

    @InjectMocks CreditController controller;

    @Test
    void incompleteOnboardingCannotCreateOrDistributeAuthenticatedCreditRequest() {
        var user = User.builder().idUser(12L).email("client@example.com").build();
        when(onboardingService.getFormularioClienteStatus(12L)).thenReturn(
                status(false, EstadoFormulario.PENDIENTE)
        );

        var response = controller.createMyRequest(mock(ClientCreditRequestDto.class), user);

        assertEquals(409, response.getStatusCode().value());
        assertEquals(
                "Completa tu perfil antes de enviar una solicitud de crédito.",
                response.getBody().get("message")
        );
        verifyNoInteractions(creditService);
    }

    @Test
    void completedOnboardingKeepsExistingCreditRequestFlow() {
        var user = User.builder().idUser(12L).email("client@example.com").build();
        var request = mock(ClientCreditRequestDto.class);
        when(onboardingService.getFormularioClienteStatus(12L)).thenReturn(
                status(true, EstadoFormulario.COMPLETO)
        );
        when(creditService.createAuthenticatedRequest(any(), eq(12L), eq("client@example.com")))
                .thenReturn(new CreditService.AuthenticatedRequestResult(
                        55L, CreditRequestStatus.ENVIADA, 1
                ));

        var response = controller.createMyRequest(request, user);

        assertEquals(200, response.getStatusCode().value());
        verify(creditService).createAuthenticatedRequest(request, 12L, "client@example.com");
    }

    private FormularioClienteStatusResponse status(boolean complete, EstadoFormulario state) {
        return FormularioClienteStatusResponse.builder()
                .formularioCompleto(complete)
                .estadoFormulario(state)
                .build();
    }
}
