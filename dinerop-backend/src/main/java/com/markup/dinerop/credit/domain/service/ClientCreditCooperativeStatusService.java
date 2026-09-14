package com.markup.dinerop.credit.domain.service;

import com.markup.dinerop.cooperative.domain.service.CooperativeService;
import com.markup.dinerop.credit.domain.model.SolicitudCooperativa;
import com.markup.dinerop.credit.domain.model.SolicitudCooperativaCotizacion;
import com.markup.dinerop.credit.domain.model.enums.SolicitudCooperativaStatus;
import com.markup.dinerop.credit.domain.service.calculation.LoanCalculator;
import com.markup.dinerop.credit.dto.CooperativeStatusItemDto;
import com.markup.dinerop.credit.infrastructure.repository.SolicitudCooperativaCotizacionRepository;
import com.markup.dinerop.credit.infrastructure.repository.SolicitudCooperativaRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ClientCreditCooperativeStatusService {

    private final SolicitudCooperativaRepository solicitudCooperativaRepository;
    private final SolicitudCooperativaCotizacionRepository cotizacionRepository;
    private final CooperativeService cooperativeService;

    public List<CooperativeStatusItemDto> getPreApprovedCooperatives(Long clientId, Long solicitudId) {

        var rows = solicitudCooperativaRepository.findByClientIdAndSolicitudIdAndEstado(
                clientId,
                solicitudId,
                List.of(
                        SolicitudCooperativaStatus.PRE_APROBADA,
                        SolicitudCooperativaStatus.ACEPTADA,
                        SolicitudCooperativaStatus.SOLICITANDO_GARANTE
                )
        );

        return rows.stream().map(sc -> {
            var coop = cooperativeService.getById(sc.getCooperativaId());
                var cotizacion = cotizacionRepository.findBySolicitudCooperativaId(sc.getId())
                    .orElseGet(() -> createMissingQuotation(sc));

            return CooperativeStatusItemDto.builder()
                    .cooperativaId(sc.getCooperativaId())
                    .nombreCooperativa(coop != null ? coop.getNombre() : "-")
                    .estado(sc.getEstado().name())
                    .fechaActualizacion(sc.getFechaActualizacion())
                    .monto(cotizacion != null ? cotizacion.getMonto() : null)
                    .plazoMeses(cotizacion != null ? cotizacion.getPlazoMeses() : null)
                    .tipoCredito(cotizacion != null ? cotizacion.getTipoCredito().name() : null)
                    .tasaAnual(cotizacion != null ? cotizacion.getTasaAnual() : null)
                    .cuotaMensual(cotizacion != null ? cotizacion.getCuotaMensual() : null)
                    .totalPagar(cotizacion != null ? cotizacion.getTotalPagar() : null)
                    .interesTotal(cotizacion != null ? cotizacion.getInteresTotal() : null)
                    .build();

        }).toList();
    }

    private SolicitudCooperativaCotizacion createMissingQuotation(SolicitudCooperativa sc) {
        var request = sc.getCreditRequest();
        if (request == null || request.getAmount() == null || request.getCreditType() == null
                || request.getPlazoMeses() == null || request.getPlazoMeses() <= 0) {
            return null;
        }

        var annualRate = java.math.BigDecimal.valueOf(
                cooperativeService.getActiveRate(sc.getCooperativaId(), request.getCreditType())
        );
        var calculation = LoanCalculator.calculate(
                request.getAmount(),
                annualRate,
                request.getPlazoMeses()
        );
        return cotizacionRepository.save(
                SolicitudCooperativaCotizacion.builder()
                        .solicitudCooperativaId(sc.getId())
                        .monto(request.getAmount())
                        .plazoMeses(request.getPlazoMeses())
                        .tipoCredito(request.getCreditType())
                        .tasaAnual(annualRate)
                        .tasaMensual(calculation.tasaMensual())
                        .cuotaMensual(calculation.cuotaMensual())
                        .totalPagar(calculation.totalPagar())
                        .interesTotal(calculation.interesTotal())
                        .build()
        );
    }
}
