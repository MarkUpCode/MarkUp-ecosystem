package com.markup.dinerop.cooperative.dto;

import com.markup.dinerop.cooperative.domain.entity.InterestPaymentOption;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;

import java.math.BigDecimal;

public record CreateInvestmentRequest(
        @NotNull Long productId,
        @NotNull Long conditionId,
        @NotNull @DecimalMin("0.01") BigDecimal amount,
        @NotNull @Min(1) Integer termMonths,
        InterestPaymentOption interestPaymentOption,
        @NotNull Boolean personalDataConsent
) {}
