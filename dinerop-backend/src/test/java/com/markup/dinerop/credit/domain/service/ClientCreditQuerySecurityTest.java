package com.markup.dinerop.credit.domain.service;

import com.markup.dinerop.credit.infrastructure.repository.CreditRequestRepository;
import com.markup.dinerop.credit.infrastructure.repository.SolicitudCooperativaRepository;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.List;

import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class ClientCreditQuerySecurityTest {

    @Mock
    private SolicitudCooperativaRepository solicitudCooperativaRepository;

    @Mock
    private CreditRequestRepository creditRequestRepository;

    @InjectMocks
    private ClientCreditQueryService queryService;

    @Test
    void clientQueryUsesAuthenticatedClientIdAndCannotChooseAnotherClient() {
        when(creditRequestRepository.findByClientId(22L)).thenReturn(List.of());

        queryService.getMyCredits(22L);

        verify(creditRequestRepository).findByClientId(22L);
        verify(creditRequestRepository, never()).findByClientId(99L);
        verifyNoInteractions(solicitudCooperativaRepository);
    }
}
