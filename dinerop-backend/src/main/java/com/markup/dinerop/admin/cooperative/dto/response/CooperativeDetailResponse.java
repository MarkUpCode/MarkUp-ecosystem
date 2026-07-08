package com.markup.dinerop.admin.cooperative.dto.response;

import java.math.BigDecimal;

public record CooperativeDetailResponse(

        Long id,

        Long legacyId,

        String nombre,

        String ciudad,

        String provincia,

        String direccion,

        String telefono,

        String paginaWeb,

        String logoUrl,

        Double calificacion,

        BigDecimal montoMaximoCredito

) {
}