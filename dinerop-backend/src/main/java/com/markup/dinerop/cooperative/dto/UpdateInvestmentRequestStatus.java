package com.markup.dinerop.cooperative.dto;

import com.markup.dinerop.cooperative.domain.entity.InvestmentRequestStatus;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

public record UpdateInvestmentRequestStatus(
        @NotNull InvestmentRequestStatus status,
        @Size(max = 1000) String note
) {}
