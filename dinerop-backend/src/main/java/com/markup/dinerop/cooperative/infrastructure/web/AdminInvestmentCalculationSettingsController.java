package com.markup.dinerop.cooperative.infrastructure.web;

import com.markup.dinerop.cooperative.domain.service.InvestmentCalculationSettingsService;
import com.markup.dinerop.cooperative.dto.InvestmentCalculationSettingsResponse;
import com.markup.dinerop.cooperative.dto.UpdateInvestmentCalculationSettingsRequest;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/admin/settings/investment-calculation")
@PreAuthorize("hasRole('ADMIN')")
public class AdminInvestmentCalculationSettingsController {
    private final InvestmentCalculationSettingsService settingsService;

    @GetMapping
    public InvestmentCalculationSettingsResponse get() {
        return settingsService.getSettings();
    }

    @PutMapping
    public InvestmentCalculationSettingsResponse update(
            @Valid @RequestBody UpdateInvestmentCalculationSettingsRequest request
    ) {
        return settingsService.update(request.calculationMethod());
    }
}
