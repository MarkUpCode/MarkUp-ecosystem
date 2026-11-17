package com.markup.dinerop.cooperative.dto;

import com.markup.dinerop.cooperative.domain.entity.InterestPaymentOption;
import com.markup.dinerop.cooperative.domain.entity.InvestmentCalculationMethod;
import com.markup.dinerop.cooperative.domain.entity.InvestmentRequestStatus;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.List;

public record InvestmentRequestResponse(
        Long id,
        Long cooperativeId,
        String cooperativeName,
        String cooperativeLogoUrl,
        Long productId,
        Long conditionId,
        String productName,
        String productDescription,
        BigDecimal amount,
        Integer termMonths,
        InterestPaymentOption interestPaymentOption,
        BigDecimal annualRate,
        BigDecimal conditionMinimumAmount,
        BigDecimal conditionMaximumAmount,
        Integer conditionMinimumTermMonths,
        Integer conditionMaximumTermMonths,
        Instant rateValidFrom,
        Instant rateValidUntil,
        InvestmentCalculationMethod calculationMethod,
        BigDecimal estimatedInterest,
        BigDecimal estimatedTotal,
        String renewalConditions,
        String earlyCancellationConditions,
        String targetAudience,
        InvestmentRequestStatus status,
        String statusNote,
        Instant consentedAt,
        Instant createdAt,
        Instant updatedAt,
        String clientName,
        String clientEmail,
        String clientPhone,
        List<StatusEvent> events,
        InvestmentAcceptanceResponse acceptance
) {
    public record StatusEvent(InvestmentRequestStatus status, String note, Instant createdAt) {}
}
