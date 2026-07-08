package com.markup.dinerop.admin.cooperative.dto.response;

import java.math.BigDecimal;

public record CooperativeListItemResponse(

        Long id,

        String nombre,

        String ciudad,

        String provincia,

        String telefono,

        Double calificacion,

        BigDecimal montoMaximoCredito

) {
}