package com.markup.dinerop.cooperative.dto;

import com.markup.dinerop.cooperative.domain.entity.FinancialProductType;
import jakarta.validation.Valid;
import jakarta.validation.constraints.*;
import java.math.BigDecimal;
import java.util.List;

public record FinancialProductRequest(
        @NotNull FinancialProductType type,
        @NotBlank @Size(max = 120) String name,
        @Size(max = 2000) String description,
        @NotNull @DecimalMin("0.01") BigDecimal minimumAmount,
        @NotNull @DecimalMin("0.01") BigDecimal maximumAmount,
        Boolean active,
        @Valid List<FinancialProductConditionRequest> conditions
) {}
