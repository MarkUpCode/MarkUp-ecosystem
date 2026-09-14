package com.markup.dinerop.credit.dto;

import java.math.BigDecimal;

public record CooperativeOfferDefaultsDto(
        BigDecimal monto,
        Integer plazoMeses,
        BigDecimal tasaAnual
) {}
