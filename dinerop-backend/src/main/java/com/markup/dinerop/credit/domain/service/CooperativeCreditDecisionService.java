package com.markup.dinerop.credit.domain.service;

import com.markup.dinerop.cooperative.domain.service.CooperativeService;
import com.markup.dinerop.credit.domain.model.CreditRequest;
import com.markup.dinerop.credit.domain.model.SolicitudCooperativa;
import com.markup.dinerop.credit.domain.model.SolicitudCooperativaCotizacion;
import com.markup.dinerop.credit.domain.model.enums.SolicitudCooperativaStatus;
import com.markup.dinerop.credit.domain.service.calculation.LoanCalculator;
import com.markup.dinerop.credit.dto.CooperativeOfferDefaultsDto;
import com.markup.dinerop.credit.infrastructure.repository.SolicitudCooperativaCotizacionRepository;
import com.markup.dinerop.credit.infrastructure.repository.SolicitudCooperativaRepository;
import com.markup.dinerop.notification.service.NotificationService;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;

@Service
@RequiredArgsConstructor
public class CooperativeCreditDecisionService {

    private final SolicitudCooperativaRepository repository;
    private final CooperativeService cooperativeService;
    private final SolicitudCooperativaCotizacionRepository cotizacionRepository;
    private final NotificationService notificationService;

    @Transactional
    public void decide(
            Long solicitudId,
            Long cooperativaId,
            String decision,
            BigDecimal tasaAnual,
            Integer plazoMeses
    ) {

        SolicitudCooperativa sc = repository
                .findBySolicitudIdAndCooperativaId(solicitudId, cooperativaId)
                .orElseThrow(() ->
                        new AccessDeniedException("Solicitud no pertenece a esta cooperativa")
                );

        if (sc.getEstado() != SolicitudCooperativaStatus.ENVIADA) {
            throw new IllegalStateException("La solicitud ya fue procesada");
        }

        CreditRequest cr = sc.getCreditRequest();
        if (cr == null) {
            throw new IllegalStateException("CreditRequest no cargado");
        }

        if ("PRE_APROBAR".equalsIgnoreCase(decision)) {

            if (cr.getCreditType() == null) {
                throw new IllegalStateException("Tipo de credito no definido");
            }
            if (cr.getAmount() == null || cr.getAmount().signum() <= 0) {
                throw new IllegalStateException("Monto invalido");
            }
            int plazoFinal = plazoMeses != null ? plazoMeses : safePlazo(cr);
            if (plazoFinal <= 0) {
                throw new IllegalStateException("Plazo invalido");
            }

            BigDecimal tasaFinal = tasaAnual != null
                    ? tasaAnual
                    : BigDecimal.valueOf(cooperativeService.getActiveRate(cooperativaId, cr.getCreditType()));

            var calc = LoanCalculator.calculate(
                    cr.getAmount(),
                    tasaFinal,
                    plazoFinal
            );

            var cotizacion = cotizacionRepository
                    .findBySolicitudCooperativaId(sc.getId())
                    .orElseGet(SolicitudCooperativaCotizacion::new);

            cotizacion.setSolicitudCooperativaId(sc.getId());
            cotizacion.setMonto(cr.getAmount());
            cotizacion.setPlazoMeses(plazoFinal);
            cotizacion.setTipoCredito(cr.getCreditType());
            cotizacion.setTasaAnual(tasaFinal);
            cotizacion.setTasaMensual(calc.tasaMensual());
            cotizacion.setCuotaMensual(calc.cuotaMensual());
            cotizacion.setTotalPagar(calc.totalPagar());
            cotizacion.setInteresTotal(calc.interesTotal());

            cotizacionRepository.save(cotizacion);

            sc.setEstado(SolicitudCooperativaStatus.PRE_APROBADA);
            repository.save(sc);

            notificationService.sendCreditOfferEmail(
                    cr.getEmail(),
                    cooperativeService.getById(cooperativaId).getNombre(),
                    cotizacion.getMonto(),
                    cotizacion.getTasaAnual(),
                    cotizacion.getPlazoMeses(),
                    cotizacion.getCuotaMensual()
            );

        } else if ("RECHAZAR".equalsIgnoreCase(decision)) {

            sc.setEstado(SolicitudCooperativaStatus.RECHAZADA);
            repository.save(sc);

        } else {
            throw new IllegalArgumentException("Decision invalida");
        }
    }

    @Transactional
    public CooperativeOfferDefaultsDto getOfferDefaults(Long solicitudId, Long cooperativaId) {
        SolicitudCooperativa sc = findPendingRequest(solicitudId, cooperativaId);
        CreditRequest cr = sc.getCreditRequest();

        if (cr.getCreditType() == null) {
            throw new IllegalStateException("La solicitud no es de crédito");
        }

        return new CooperativeOfferDefaultsDto(
                cr.getAmount(),
                safePlazo(cr),
                BigDecimal.valueOf(cooperativeService.getActiveRate(cooperativaId, cr.getCreditType()))
        );
    }

    private SolicitudCooperativa findPendingRequest(Long solicitudId, Long cooperativaId) {
        SolicitudCooperativa sc = repository
                .findBySolicitudIdAndCooperativaId(solicitudId, cooperativaId)
                .orElseThrow(() -> new AccessDeniedException("Solicitud no pertenece a esta cooperativa"));
        if (sc.getEstado() != SolicitudCooperativaStatus.ENVIADA) {
            throw new IllegalStateException("La solicitud ya fue procesada");
        }
        return sc;
    }

    private int safePlazo(CreditRequest creditRequest) {
        return creditRequest.getPlazoMeses() == null ? 0 : creditRequest.getPlazoMeses();
    }
}
