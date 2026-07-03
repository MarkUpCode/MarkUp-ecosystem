package com.markup.dinerop.admin.dashboard.dto;

public record UserStatsDto(
        long total,
        long clients,
        long cooperatives,
        long admins
) {
}