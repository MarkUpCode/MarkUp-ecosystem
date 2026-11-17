package com.markup.dinerop.cooperative.dto;

import com.markup.dinerop.cooperative.domain.entity.CreditProductCategory;
import java.math.BigDecimal;

public record PublicCreditOfferResponse(
        Long cooperativeId,
        String cooperativeName,
        Long productId,
        String productName,
        String description,
        CreditProductCategory creditCategory,
        BigDecimal amount,
        Integer termMonths,
        BigDecimal annualRate,
        String conditions
) {}
