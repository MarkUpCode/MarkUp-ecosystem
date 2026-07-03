package com.markup.dinerop.admin.dashboard.dto;

import java.util.List;

public record DashboardResponseDto(

        UserStatsDto users,

        CooperativeStatsDto cooperatives,

        CreditStatsDto credits,

        VisitStatsDto visits,

        List<RecentUserDto> recentUsers,

        List<RecentCreditDto> recentCredits

) {
}