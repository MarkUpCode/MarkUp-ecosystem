package com.markup.dinerop.cooperative.infrastructure.web;

import com.markup.dinerop.auth.entity.User;
import com.markup.dinerop.cooperative.domain.entity.FinancialProduct;
import com.markup.dinerop.cooperative.domain.entity.FinancialProductType;
import com.markup.dinerop.cooperative.domain.repository.FinancialProductRepository;
import com.markup.dinerop.cooperative.domain.service.FinancialProductService;
import com.markup.dinerop.cooperative.domain.service.InvestmentService;
import com.markup.dinerop.cooperative.dto.FinancialProductConditionRequest;
import com.markup.dinerop.cooperative.dto.FinancialProductRequest;
import com.markup.dinerop.cooperative.dto.FinancialProductResponse;
import com.markup.dinerop.cooperative.dto.InvestmentRequestResponse;
import com.markup.dinerop.cooperative.dto.UpdateInvestmentRequestStatus;
import jakarta.persistence.EntityNotFoundException;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/credits/cooperative/me")
@PreAuthorize("hasRole('COOPERATIVE')")
public class CooperativeInvestmentController {
    private final FinancialProductService financialProductService;
    private final FinancialProductRepository productRepository;
    private final InvestmentService investmentService;

    @GetMapping("/investment-products")
    public List<FinancialProductResponse> getProducts(@AuthenticationPrincipal User user) {
        return financialProductService.list(requireCooperativeId(user), false).stream()
                .filter(product -> product.type() == FinancialProductType.INVESTMENT)
                .toList();
    }

    @PostMapping("/investment-products")
    public FinancialProductResponse createProduct(
            @AuthenticationPrincipal User user,
            @Valid @RequestBody FinancialProductRequest request
    ) {
        requireInvestmentType(request.type());
        return financialProductService.create(requireCooperativeId(user), request);
    }

    @PutMapping("/investment-products/{productId}")
    public FinancialProductResponse updateProduct(
            @AuthenticationPrincipal User user,
            @PathVariable Long productId,
            @Valid @RequestBody FinancialProductRequest request
    ) {
        requireInvestmentType(request.type());
        requireInvestmentProduct(requireCooperativeId(user), productId);
        return financialProductService.update(requireCooperativeId(user), productId, request);
    }

    @PostMapping("/investment-products/{productId}/conditions")
    public FinancialProductResponse.Condition addRateCondition(
            @AuthenticationPrincipal User user,
            @PathVariable Long productId,
            @Valid @RequestBody FinancialProductConditionRequest request
    ) {
        requireInvestmentProduct(requireCooperativeId(user), productId);
        return financialProductService.addCondition(requireCooperativeId(user), productId, request);
    }

    @GetMapping("/investment-requests")
    public List<InvestmentRequestResponse> getRequests(@AuthenticationPrincipal User user) {
        return investmentService.getCooperativeRequests(requireCooperativeId(user));
    }

    @PutMapping("/investment-requests/{requestId}/status")
    public InvestmentRequestResponse updateRequestStatus(
            @AuthenticationPrincipal User user,
            @PathVariable Long requestId,
            @Valid @RequestBody UpdateInvestmentRequestStatus update
    ) {
        return investmentService.updateStatus(requireCooperativeId(user), requestId, update, user.getIdUser());
    }

    private Long requireCooperativeId(User user) {
        if (user.getCooperativaId() == null) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN,
                    "La cuenta no está asociada a una cooperativa.");
        }
        return user.getCooperativaId();
    }

    private void requireInvestmentProduct(Long cooperativeId, Long productId) {
        FinancialProduct product = productRepository.findById(productId)
                .filter(item -> item.getCooperativeId().equals(cooperativeId))
                .orElseThrow(() -> new EntityNotFoundException("Producto de inversión no encontrado."));
        requireInvestmentType(product.getType());
    }

    private void requireInvestmentType(FinancialProductType type) {
        if (type != FinancialProductType.INVESTMENT) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                    "Este panel solo administra productos de inversión.");
        }
    }
}
