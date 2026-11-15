package com.markup.dinerop.credit.domain.service;

import com.markup.dinerop.cooperative.domain.service.CooperativeService;
import com.markup.dinerop.credit.domain.model.SolicitudCooperativa;
import com.markup.dinerop.credit.domain.model.SolicitudCooperativaCotizacion;
import com.markup.dinerop.credit.domain.model.enums.CreditRejectionReason;
import com.markup.dinerop.credit.domain.model.enums.SolicitudCooperativaStatus;
import com.markup.dinerop.credit.domain.service.calculation.LoanCalculator;
import com.markup.dinerop.credit.dto.CooperativeStatusItemDto;
import com.markup.dinerop.credit.infrastructure.repository.SolicitudCooperativaCotizacionRepository;
import com.markup.dinerop.credit.infrastructure.repository.SolicitudCooperativaRepository;
import com.markup.dinerop.credit.infrastructure.repository.CreditProcessEventRepository;
import lombok.RequiredArgsConstructor;
import com.markup.dinerop.credit.service.CreditRequirementService;
import com.markup.dinerop.credit.dto.CreditRequirementDto;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ClientCreditCooperativeStatusService {

    private final SolicitudCooperativaRepository solicitudCooperativaRepository;
    private final SolicitudCooperativaCotizacionRepository cotizacionRepository;
    private final CooperativeService cooperativeService;
    private final CreditRequirementService requirementService;
    private final CreditProcessEventRepository creditProcessEventRepository;

    @Transactional(readOnly = true)
    public List<CooperativeStatusItemDto> getPreApprovedCooperatives(Long clientId, Long solicitudId) {

        var rows = solicitudCooperativaRepository.findByClientIdAndSolicitudIdAndEstado(
                clientId,
                solicitudId,
                List.of(
                        SolicitudCooperativaStatus.PRE_APROBADA,
                        SolicitudCooperativaStatus.ACEPTADA,
                        SolicitudCooperativaStatus.SOLICITANDO_GARANTE,
                        SolicitudCooperativaStatus.RECHAZADA
                )
        );

        return rows.stream().map(sc -> {
            var coop = cooperativeService.getById(sc.getCooperativaId());
            var garanteEnRevision = sc.getEstado() == SolicitudCooperativaStatus.SOLICITANDO_GARANTE
                    && creditProcessEventRepository
                            .findTopBySolicitudCooperativaIdOrderByFechaDescIdDesc(sc.getId())
                            .map(event -> "GARANTE_ENVIADO".equals(event.getTipo()))
                            .orElse(false);
            var lastGuaranteeEvent = creditProcessEventRepository
                    .findTopBySolicitudCooperativaIdOrderByFechaDescIdDesc(sc.getId())
                    .orElse(null);
            var mensajeGarante = lastGuaranteeEvent != null
                    && "NUEVO_GARANTE_SOLICITADO".equals(lastGuaranteeEvent.getTipo())
                    ? lastGuaranteeEvent.getDetalle()
                    : null;
            var requiereComparecenciaGarante = creditProcessEventRepository
                    .existsBySolicitudCooperativaIdAndTipo(sc.getId(), "GARANTE_ACEPTADO");
                var cotizacion = sc.getEstado() == SolicitudCooperativaStatus.RECHAZADA
                        ? null
                        : cotizacionRepository.findBySolicitudCooperativaId(sc.getId())
                                .orElseGet(() -> createMissingQuotation(sc));

            var requirements = requirementService.findForOffer(sc.getId()).stream().map(item -> new CreditRequirementDto(
                    item.getTitle(), item.getDescription(), item.getCategory(), item.isMandatory(), item.getDisplayOrder()
            )).toList();

            return CooperativeStatusItemDto.builder()
                    .cooperativaId(sc.getCooperativaId())
                    .nombreCooperativa(coop != null ? coop.getNombre() : "-")
                    .estado(sc.getEstado().name())
                    .garanteEnRevision(garanteEnRevision)
                    .mensajeGarante(mensajeGarante)
                    .requiereComparecenciaGarante(requiereComparecenciaGarante)
                    .fechaActualizacion(sc.getFechaActualizacion())
                    .monto(cotizacion != null ? cotizacion.getMonto() : null)
                    .plazoMeses(cotizacion != null ? cotizacion.getPlazoMeses() : null)
                    .tipoCredito(cotizacion != null ? cotizacion.getTipoCredito().name() : null)
                    .tasaAnual(cotizacion != null ? cotizacion.getTasaAnual() : null)
                    .cuotaMensual(cotizacion != null ? cotizacion.getCuotaMensual() : null)
                    .totalPagar(cotizacion != null ? cotizacion.getTotalPagar() : null)
                    .interesTotal(cotizacion != null ? cotizacion.getInteresTotal() : null)
                    .direccion(coop.getDireccion())
                    .mapsUrl(coop.getDireccion())
                    .requisitos(requirements)
                    .motivosRechazo(sc.getMotivosRechazo().stream()
                            .map(reason -> reason == CreditRejectionReason.OTROS
                                    && sc.getMotivoRechazoOtro() != null
                                    && !sc.getMotivoRechazoOtro().isBlank()
                                    ? sc.getMotivoRechazoOtro()
                                    : reason.getLabel())
                            .toList())
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
