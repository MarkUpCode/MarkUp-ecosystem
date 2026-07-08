package com.markup.dinerop.admin.cooperative.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

import java.math.BigDecimal;

public record UpdateCooperativeRequest(

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
        BigDecimal montoMaximoCredito

) {
}