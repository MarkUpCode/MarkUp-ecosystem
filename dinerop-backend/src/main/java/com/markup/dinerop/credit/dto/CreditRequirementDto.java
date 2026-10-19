package com.markup.dinerop.credit.dto;

import jakarta.validation.constraints.NotBlank;

public record CreditRequirementDto(
        @NotBlank String title,
        String description,
        String category,
        Boolean mandatory,
        Integer displayOrder
) {}
