package com.markup.dinerop.admin.cooperative.controller;

import com.markup.dinerop.cooperative.domain.service.FinancialProductService;
import com.markup.dinerop.cooperative.dto.*;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/admin/cooperatives/{cooperativeId}/products")
@RequiredArgsConstructor
@PreAuthorize("hasRole('ADMIN')")
public class FinancialProductAdminController {
    private final FinancialProductService service;

    @GetMapping
    public List<FinancialProductResponse> list(@PathVariable Long cooperativeId) {
        return service.list(cooperativeId, false);
    }

    @PostMapping
    public FinancialProductResponse create(@PathVariable Long cooperativeId, @Valid @RequestBody FinancialProductRequest request) {
        return service.create(cooperativeId, request);
    }

    @PutMapping("/{productId}")
    public FinancialProductResponse update(@PathVariable Long cooperativeId, @PathVariable Long productId, @Valid @RequestBody FinancialProductRequest request) {
        return service.update(cooperativeId, productId, request);
    }

    @PostMapping("/{productId}/conditions")
    public FinancialProductResponse.Condition addCondition(@PathVariable Long cooperativeId, @PathVariable Long productId,
            @Valid @RequestBody FinancialProductConditionRequest request) {
        return service.addCondition(cooperativeId, productId, request);
    }

    @PostMapping("/{productId}/conditions/batch")
    public List<FinancialProductResponse.Condition> addConditions(@PathVariable Long cooperativeId, @PathVariable Long productId,
            @Valid @RequestBody List<@Valid FinancialProductConditionRequest> requests) {
        return service.addConditions(cooperativeId, productId, requests);
    }
}
