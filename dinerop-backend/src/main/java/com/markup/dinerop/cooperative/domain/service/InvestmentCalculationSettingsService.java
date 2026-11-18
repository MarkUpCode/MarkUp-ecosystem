package com.markup.dinerop.cooperative.domain.service;

import com.markup.dinerop.cooperative.domain.entity.InvestmentCalculationMethod;
import com.markup.dinerop.cooperative.domain.entity.InvestmentCalculationSettings;
import com.markup.dinerop.cooperative.domain.repository.InvestmentCalculationSettingsRepository;
import com.markup.dinerop.cooperative.dto.InvestmentCalculationSettingsResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class InvestmentCalculationSettingsService {
    private static final long SETTINGS_ID = 1L;
    private final InvestmentCalculationSettingsRepository repository;

    @Transactional(readOnly = true)
    public InvestmentCalculationMethod currentMethod() {
        return repository.findById(SETTINGS_ID)
                .map(InvestmentCalculationSettings::getCalculationMethod)
                .orElse(InvestmentCalculationMethod.UNSPECIFIED);
    }

    @Transactional(readOnly = true)
    public InvestmentCalculationSettingsResponse getSettings() {
        return new InvestmentCalculationSettingsResponse(currentMethod());
    }

    @Transactional
    public InvestmentCalculationSettingsResponse update(InvestmentCalculationMethod method) {
        InvestmentCalculationSettings settings = repository.findById(SETTINGS_ID)
                .orElseGet(InvestmentCalculationSettings::new);
        settings.setId(SETTINGS_ID);
        settings.setCalculationMethod(method);
        return new InvestmentCalculationSettingsResponse(repository.save(settings).getCalculationMethod());
    }
}
