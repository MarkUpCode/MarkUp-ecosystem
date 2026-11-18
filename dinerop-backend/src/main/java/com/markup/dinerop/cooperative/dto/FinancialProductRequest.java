package com.markup.dinerop.cooperative.dto;

import com.markup.dinerop.cooperative.domain.entity.FinancialProductType;
import com.markup.dinerop.cooperative.domain.entity.CreditProductCategory;
import com.markup.dinerop.cooperative.domain.entity.InterestPaymentOption;
import com.markup.dinerop.cooperative.domain.entity.InvestmentCalculationMethod;
import jakarta.validation.Valid;
import jakarta.validation.constraints.*;
import java.math.BigDecimal;
import java.util.List;
import java.util.Set;

public record FinancialProductRequest(
        @NotNull FinancialProductType type,
        CreditProductCategory creditCategory,
        @Size(max = 120) String name,
        @Size(max = 2000) String description,
        @NotNull @DecimalMin("0.01") BigDecimal minimumAmount,
        @NotNull @DecimalMin("0.01") BigDecimal maximumAmount,
        Boolean active,
        @Valid List<FinancialProductConditionRequest> conditions,
        @Size(max = 3) Set<InterestPaymentOption> interestPaymentOptions,
        InvestmentCalculationMethod calculationMethod,
        @Size(max = 2000) String renewalConditions,
        @Size(max = 2000) String earlyCancellationConditions,
        @Size(max = 500) String targetAudience
) {
    public FinancialProductRequest(FinancialProductType type, String name, String description,
            BigDecimal minimumAmount, BigDecimal maximumAmount, Boolean active,
            List<FinancialProductConditionRequest> conditions) {
        this(type, type == FinancialProductType.CREDIT ? CreditProductCategory.CONSUMO : null,
                name, description, minimumAmount, maximumAmount, active, conditions,
                null, null, null, null, null);
    }
}
