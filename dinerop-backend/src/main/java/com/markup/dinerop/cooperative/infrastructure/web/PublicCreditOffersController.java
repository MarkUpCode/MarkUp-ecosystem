package com.markup.dinerop.cooperative.infrastructure.web;

import com.markup.dinerop.cooperative.domain.entity.CreditProductCategory;
import com.markup.dinerop.cooperative.domain.service.FinancialProductService;
import com.markup.dinerop.cooperative.dto.PublicCreditOfferResponse;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import lombok.RequiredArgsConstructor;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import java.math.BigDecimal;
import java.util.List;

@RestController
@Validated
@RequiredArgsConstructor
@RequestMapping("/api/credits")
public class PublicCreditOffersController {
    private final FinancialProductService financialProductService;

    @GetMapping("/public-offers")
    public List<PublicCreditOfferResponse> getOffers(
            @RequestParam CreditProductCategory creditCategory,
            @RequestParam @NotNull @DecimalMin("0.01") BigDecimal amount,
            @RequestParam @NotNull @Min(1) @Max(60) Integer termMonths) {
        return financialProductService.getPublicCreditOffers(creditCategory, amount, termMonths);
    }
}
