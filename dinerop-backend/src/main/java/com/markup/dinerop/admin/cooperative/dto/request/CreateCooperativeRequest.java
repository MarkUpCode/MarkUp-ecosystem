package com.markup.dinerop.admin.cooperative.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.DecimalMax;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotNull;

import java.math.BigDecimal;

public record CreateCooperativeRequest(

        @NotBlank
        String nombre,

        @NotBlank
        String ciudad,

        @NotBlank
        String provincia,

        String direccion,

        String telefono,

        String paginaWeb,

        String logoUrl,

        Double calificacion,

        @NotNull
        BigDecimal montoMaximoCredito,

        @NotNull
        @DecimalMin(value = "0.001", message = "La tasa anual debe ser mayor que cero")
        @DecimalMax(value = "100.000", message = "La tasa anual no puede superar el 100%")
        BigDecimal tasaAnual

) {
}
