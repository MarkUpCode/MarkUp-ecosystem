package com.markup.dinerop.cooperative.dto;

import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDate;
import java.util.List;

public record InvestmentAcceptanceResponse(
        String acceptanceMessage, BigDecimal confirmedAnnualRate, String agencyName,
        String agencyAddress, String agencyCity, String mapsUrl, String contactPhone,
        String openingHours, String contactDepartment, LocalDate responseDeadline,
        String instructions, Instant respondedAt, List<Requirement> requirements
) {
    public record Requirement(String description, boolean mandatory) {}
}
