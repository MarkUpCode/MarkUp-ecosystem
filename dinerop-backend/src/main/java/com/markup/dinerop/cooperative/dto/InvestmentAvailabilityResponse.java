package com.markup.dinerop.cooperative.dto;

import com.markup.dinerop.cooperative.domain.entity.InterestPaymentOption;

import java.util.List;
import java.util.Set;

public record InvestmentAvailabilityResponse(
        List<Integer> termMonths,
        Set<InterestPaymentOption> interestPaymentOptions
) {}
