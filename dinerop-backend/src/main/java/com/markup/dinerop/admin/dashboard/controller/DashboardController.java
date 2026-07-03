package com.markup.dinerop.admin.dashboard.controller;

import com.markup.dinerop.admin.dashboard.dto.DashboardResponseDto;
import com.markup.dinerop.admin.dashboard.service.DashboardService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/admin/dashboard")
@RequiredArgsConstructor
@PreAuthorize("hasRole('ADMIN')")
public class DashboardController {

    private final DashboardService dashboardService;

    @GetMapping
    public DashboardResponseDto getDashboard() {
        return dashboardService.getDashboard();
    }

}