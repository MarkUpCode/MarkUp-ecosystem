package com.markup.dinerop.credit.domain.service;

import com.markup.dinerop.credit.domain.model.CreditRequest;
import com.markup.dinerop.credit.domain.model.SolicitudCooperativa;
import com.markup.dinerop.credit.domain.model.enums.CreditRequestStatus;
import com.markup.dinerop.credit.domain.model.enums.CreditRequestType;
import com.markup.dinerop.credit.domain.model.enums.SolicitudCooperativaStatus;
import com.markup.dinerop.credit.infrastructure.repository.CreditRequestRepository;
import com.markup.dinerop.credit.infrastructure.repository.SolicitudCooperativaRepository;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class ClientCreditQueryAcceptedStatusTest {

    @Mock
    private SolicitudCooperativaRepository solicitudCooperativaRepository;

    @Mock
    private CreditRequestRepository creditRequestRepository;

    @InjectMocks
    private ClientCreditQueryService queryService;

    @Test
    void acceptedCooperativeOfferIsTheAggregatedRequestStatus() {
        when(creditRequestRepository.findByClientId(22L)).thenReturn(List.of(request()));
        when(solicitudCooperativaRepository.findAllByClientId(22L)).thenReturn(List.of(
                distribution(SolicitudCooperativaStatus.ACEPTADA),
                distribution(SolicitudCooperativaStatus.ENVIADA)
        ));

        var result = queryService.getMyCredits(22L);

        assertEquals("ACEPTADA", result.get(0).getEstado());
    }

    private CreditRequest request() {
        return CreditRequest.builder()
                .id(100L)
                .estado(CreditRequestStatus.ENVIADA)
                .amount(new BigDecimal("2500.00"))
                .tipo(CreditRequestType.CREDITO)
                .fechaSolicitud(LocalDateTime.of(2026, 11, 16, 10, 0))
                .build();
    }

    private SolicitudCooperativa distribution(SolicitudCooperativaStatus status) {
        return SolicitudCooperativa.builder()
                .solicitudId(100L)
                .cooperativaId(5L)
                .estado(status)
                .build();
    }
}
