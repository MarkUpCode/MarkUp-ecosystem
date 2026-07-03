package com.markup.dinerop.admin.dashboard.dto;

public record CreditStatsDto(
        long total,
        long created,
        long sent
) {
}