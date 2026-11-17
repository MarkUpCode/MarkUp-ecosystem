package com.markup.dinerop.cooperative.dto;

import jakarta.validation.constraints.*;
import java.math.BigDecimal;
import java.time.Instant;

public record FinancialProductConditionRequest(
        @NotNull @DecimalMin("0.01") BigDecimal minimumAmount,
        @NotNull @DecimalMin("0.01") BigDecimal maximumAmount,
        @NotNull @Min(1) Integer minimumTermMonths,
        @NotNull @Min(1) Integer maximumTermMonths,
        @NotNull @DecimalMin("0.0001") @DecimalMax("100.0000") BigDecimal annualRate,
        @NotNull Instant validFrom,
        Instant validUntil
) {}
