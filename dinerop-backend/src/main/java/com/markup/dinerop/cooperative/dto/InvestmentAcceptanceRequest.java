package com.markup.dinerop.cooperative.dto;

import jakarta.validation.Valid;
import jakarta.validation.constraints.*;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

public record InvestmentAcceptanceRequest(
        @NotBlank @Size(max = 2000) String acceptanceMessage,
        @DecimalMin("0.0001") @DecimalMax("100") BigDecimal confirmedAnnualRate,
        @NotBlank @Size(max = 160) String agencyName,
        @NotBlank @Size(max = 300) String agencyAddress,
        @NotBlank @Size(max = 120) String agencyCity,
        @Size(max = 1000) String mapsUrl,
        @Size(max = 40) String contactPhone,
        @Size(max = 300) String openingHours,
        @Size(max = 160) String contactDepartment,
        @FutureOrPresent LocalDate responseDeadline,
        @Size(max = 2000) String instructions,
        @NotNull @Size(max = 30) List<@Valid Requirement> requirements
) {
    public record Requirement(@NotBlank @Size(max = 250) String description, boolean mandatory) {}
}
