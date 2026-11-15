package com.markup.dinerop.credit.domain.service;

import com.markup.dinerop.cooperative.domain.service.CooperativeService;
import com.markup.dinerop.credit.domain.model.CreditRequest;
import com.markup.dinerop.credit.domain.model.SolicitudCooperativa;
import com.markup.dinerop.credit.domain.model.enums.CreditRejectionReason;
import com.markup.dinerop.credit.domain.model.enums.SolicitudCooperativaStatus;
import com.markup.dinerop.credit.infrastructure.repository.SolicitudCooperativaCotizacionRepository;
import com.markup.dinerop.credit.infrastructure.repository.SolicitudCooperativaRepository;
import com.markup.dinerop.notification.service.NotificationService;
import com.markup.dinerop.notification.service.PushNotificationService;
import com.markup.dinerop.credit.service.CreditRequirementService;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.verifyNoInteractions;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class CooperativeCreditDecisionServiceTest {

    @Mock
    private SolicitudCooperativaRepository repository;
    @Mock
    private CooperativeService cooperativeService;
    @Mock
    private SolicitudCooperativaCotizacionRepository cotizacionRepository;
    @Mock
    private NotificationService notificationService;
    @Mock
    private PushNotificationService pushNotificationService;
    @Mock
    private CreditRequirementService creditRequirementService;

    @InjectMocks
    private CooperativeCreditDecisionService decisionService;

    @Test
    void rejectionStoresStatusAndReasonsWithoutDependingOnNotifications() {
        var request = new CreditRequest();
        var cooperativeRequest = SolicitudCooperativa.builder()
                .solicitudId(21L)
                .cooperativaId(9L)
                .estado(SolicitudCooperativaStatus.ENVIADA)
                .creditRequest(request)
                .build();
        var reasons = List.of(CreditRejectionReason.CAPACIDAD_DE_PAGO);
        when(repository.findBySolicitudIdAndCooperativaId(21L, 9L))
                .thenReturn(Optional.of(cooperativeRequest));

        decisionService.decide(21L, 9L, "RECHAZAR", null, null, null, reasons);

        assertEquals(SolicitudCooperativaStatus.RECHAZADA, cooperativeRequest.getEstado());
        assertEquals(reasons, cooperativeRequest.getMotivosRechazo());
        verify(repository).save(cooperativeRequest);
        verifyNoInteractions(notificationService, pushNotificationService, cooperativeService);
    }
}
