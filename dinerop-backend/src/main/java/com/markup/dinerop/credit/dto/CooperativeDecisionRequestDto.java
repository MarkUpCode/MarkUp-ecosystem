package com.markup.dinerop.credit.dto;

import jakarta.validation.constraints.DecimalMax;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;

import java.math.BigDecimal;

public record CooperativeDecisionRequestDto(
        String decision,   // PRE_APROBAR | RECHAZAR

        @DecimalMin(value = "0.001", message = "La tasa anual debe ser mayor que cero")
        @DecimalMax(value = "100.000", message = "La tasa anual no puede superar el 100%")
        BigDecimal tasaAnual,

        @Min(value = 1, message = "El plazo debe ser de al menos un mes")
        @Max(value = 360, message = "El plazo no puede superar 360 meses")
        Integer plazoMeses
) {}
