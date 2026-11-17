package com.markup.dinerop.cooperative.dto;

import com.markup.dinerop.cooperative.domain.entity.InterestPaymentOption;
import com.markup.dinerop.cooperative.domain.entity.InvestmentCalculationMethod;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.Set;

public record InvestmentOfferResponse(
        Long cooperativeId,
        String cooperativeName,
        String cooperativeLogoUrl,
        Long productId,
        Long conditionId,
        String productName,
        String description,
        BigDecimal productMinimumAmount,
        BigDecimal productMaximumAmount,
        BigDecimal conditionMinimumAmount,
        BigDecimal conditionMaximumAmount,
        Integer minimumTermMonths,
        Integer maximumTermMonths,
        BigDecimal annualRate,
        Instant validFrom,
        Instant validUntil,
        Set<InterestPaymentOption> interestPaymentOptions,
        InvestmentCalculationMethod calculationMethod,
        String renewalConditions,
        String earlyCancellationConditions,
        String targetAudience,
        BigDecimal estimatedInterest,
        BigDecimal estimatedTotal
) {}
