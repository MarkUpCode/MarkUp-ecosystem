package com.markup.dinerop.cooperative.infrastructure.web;

import com.markup.dinerop.auth.entity.User;
import com.markup.dinerop.cooperative.domain.entity.FinancialProduct;
import com.markup.dinerop.cooperative.domain.entity.FinancialProductType;
import com.markup.dinerop.cooperative.domain.repository.FinancialProductRepository;
import com.markup.dinerop.cooperative.domain.service.FinancialProductService;
import com.markup.dinerop.cooperative.dto.FinancialProductRequest;
import com.markup.dinerop.cooperative.dto.FinancialProductResponse;
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
@RequestMapping("/api/credits/cooperative/me/credit-products")
@PreAuthorize("hasRole('COOPERATIVE')")
public class CooperativeCreditProductController {
    private final FinancialProductService financialProductService;
    private final FinancialProductRepository productRepository;

    @GetMapping
    public List<FinancialProductResponse> getProducts(@AuthenticationPrincipal User user) {
        return financialProductService.list(requireCooperativeId(user), true).stream()
                .filter(product -> product.type() == FinancialProductType.CREDIT)
                .toList();
    }

    @PostMapping
    public FinancialProductResponse createProduct(@AuthenticationPrincipal User user,
            @Valid @RequestBody FinancialProductRequest request) {
        requireCreditType(request.type());
        return financialProductService.create(requireCooperativeId(user), request);
    }

    @PutMapping("/{productId}")
    public FinancialProductResponse updateProduct(@AuthenticationPrincipal User user,
            @PathVariable Long productId, @Valid @RequestBody FinancialProductRequest request) {
        requireCreditType(request.type());
        Long cooperativeId = requireCooperativeId(user);
        requireOwnedCreditProduct(cooperativeId, productId);
        return financialProductService.update(cooperativeId, productId, request);
    }

    private Long requireCooperativeId(User user) {
        if (user.getCooperativaId() == null) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN,
                    "La cuenta no está asociada a una cooperativa.");
        }
        return user.getCooperativaId();
    }

    private void requireOwnedCreditProduct(Long cooperativeId, Long productId) {
        FinancialProduct product = productRepository.findById(productId)
                .filter(item -> item.getCooperativeId().equals(cooperativeId))
                .orElseThrow(() -> new EntityNotFoundException("Producto de crédito no encontrado."));
        requireCreditType(product.getType());
    }

    private void requireCreditType(FinancialProductType type) {
        if (type != FinancialProductType.CREDIT) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                    "Este panel solo administra productos de crédito.");
        }
    }
}
