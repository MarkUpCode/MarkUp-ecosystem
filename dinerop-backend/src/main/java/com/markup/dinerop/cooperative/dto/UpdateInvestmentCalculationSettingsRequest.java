package com.markup.dinerop.cooperative.dto;

import com.markup.dinerop.cooperative.domain.entity.InvestmentCalculationMethod;
import jakarta.validation.constraints.NotNull;

public record UpdateInvestmentCalculationSettingsRequest(@NotNull InvestmentCalculationMethod calculationMethod) {
}
