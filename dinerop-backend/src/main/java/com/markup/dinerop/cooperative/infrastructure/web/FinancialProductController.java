package com.markup.dinerop.cooperative.infrastructure.web;

import com.markup.dinerop.cooperative.domain.service.FinancialProductService;
import com.markup.dinerop.cooperative.dto.FinancialProductResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/cooperatives/{cooperativeId}/products")
public class FinancialProductController {
    private final FinancialProductService service;

    @GetMapping
    public List<FinancialProductResponse> list(@PathVariable Long cooperativeId) {
        return service.list(cooperativeId, true);
    }
}
