package com.markup.dinerop.cooperative.dto;

import com.markup.dinerop.cooperative.domain.entity.FinancialProductType;
import java.math.BigDecimal;
import java.time.Instant;
import java.util.List;

public record FinancialProductResponse(
        Long id, Long cooperativeId, FinancialProductType type, String name, String description,
        BigDecimal minimumAmount, BigDecimal maximumAmount, boolean active, List<Condition> conditions
) {
    public record Condition(Long id, BigDecimal minimumAmount, BigDecimal maximumAmount,
            Integer minimumTermMonths, Integer maximumTermMonths, BigDecimal annualRate,
            Instant validFrom, Instant validUntil) {}
}
