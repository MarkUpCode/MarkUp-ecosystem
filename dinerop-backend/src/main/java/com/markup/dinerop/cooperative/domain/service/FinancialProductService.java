package com.markup.dinerop.cooperative.domain.service;

import com.markup.dinerop.cooperative.domain.entity.*;
import com.markup.dinerop.cooperative.domain.repository.*;
import com.markup.dinerop.cooperative.dto.*;
import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.time.Instant;
import java.util.*;

@Service
@RequiredArgsConstructor
public class FinancialProductService {
    private final FinancialProductRepository productRepository;
    private final FinancialProductConditionRepository conditionRepository;
    private final CooperativeRepository cooperativeRepository;

    @Transactional(readOnly = true)
    public List<FinancialProductResponse> list(Long cooperativeId, boolean activeOnly) {
        requireCooperative(cooperativeId);
        return productRepository.findByCooperativeIdOrderById(cooperativeId).stream()
                .filter(p -> !activeOnly || p.isActive())
                .map(p -> toResponse(p, activeOnly)).toList();
    }

    @Transactional
    public FinancialProductResponse create(Long cooperativeId, FinancialProductRequest request) {
        lockCooperative(cooperativeId);
        validateBounds(request.minimumAmount(), request.maximumAmount(), "El rango del producto es inválido.");
        FinancialProduct product = new FinancialProduct();
        product.setCooperativeId(cooperativeId);
        apply(product, request);
        product = productRepository.save(product);
        if (request.conditions() != null) {
            validateConditions(product, request.conditions(), List.of());
            for (FinancialProductConditionRequest condition : request.conditions()) saveCondition(product.getId(), condition);
        }
        return toResponse(product);
    }

    @Transactional
    public FinancialProductResponse update(Long cooperativeId, Long productId, FinancialProductRequest request) {
        lockCooperative(cooperativeId);
        FinancialProduct product = productRepository.findById(productId)
                .filter(p -> p.getCooperativeId().equals(cooperativeId))
                .orElseThrow(() -> new EntityNotFoundException("Producto no encontrado."));
        validateBounds(request.minimumAmount(), request.maximumAmount(), "El rango del producto es inválido.");
        List<FinancialProductCondition> history = conditionRepository.findByProductIdOrderByValidFromDescIdDesc(productId);
        if (!history.isEmpty() && product.getType() != request.type())
            throw new IllegalArgumentException("No se puede cambiar el tipo de un producto con historial financiero.");
        for (var condition : history) {
            if (condition.getMinimumAmount().compareTo(request.minimumAmount()) < 0 || condition.getMaximumAmount().compareTo(request.maximumAmount()) > 0)
                throw new IllegalArgumentException("El nuevo rango debe contener todas las condiciones históricas del producto.");
        }
        apply(product, request);
        return toResponse(productRepository.save(product));
    }

    @Transactional
    public FinancialProductResponse.Condition addCondition(Long cooperativeId, Long productId, FinancialProductConditionRequest request) {
        return addConditions(cooperativeId, productId, List.of(request)).get(0);
    }

    @Transactional
    public List<FinancialProductResponse.Condition> addConditions(Long cooperativeId, Long productId, List<FinancialProductConditionRequest> requests) {
        lockCooperative(cooperativeId);
        FinancialProduct product = productRepository.findById(productId)
                .filter(p -> p.getCooperativeId().equals(cooperativeId))
                .orElseThrow(() -> new EntityNotFoundException("Producto no encontrado."));
        validateConditions(product, requests, conditionRepository.findByProductIdOrderByValidFromDescIdDesc(productId));
        return requests.stream().map(request -> toCondition(saveCondition(productId, request))).toList();
    }

    private void validateConditions(FinancialProduct product, List<FinancialProductConditionRequest> incoming,
                                    List<FinancialProductCondition> existing) {
        List<FinancialProductCondition> otherProducts = productRepository.findByCooperativeIdOrderById(product.getCooperativeId()).stream()
                .filter(other -> !Objects.equals(other.getId(), product.getId()))
                .filter(other -> other.getType() == product.getType())
                .flatMap(other -> conditionRepository.findByProductIdOrderByValidFromDescIdDesc(other.getId()).stream())
                .toList();
        List<FinancialProductConditionRequest> accepted = new ArrayList<>();
        Map<FinancialProductCondition, Instant> closeAt = new IdentityHashMap<>();
        for (var c : incoming) {
            validateBounds(c.minimumAmount(), c.maximumAmount(), "El rango de monto de una condición es inválido.");
            if (c.minimumAmount().compareTo(product.getMinimumAmount()) < 0 || c.maximumAmount().compareTo(product.getMaximumAmount()) > 0)
                throw new IllegalArgumentException("Los rangos de las condiciones deben estar dentro de los montos del producto.");
            if (c.minimumTermMonths() > c.maximumTermMonths())
                throw new IllegalArgumentException("El rango de plazos de una condición es inválido.");
            if (c.validUntil() != null && !c.validUntil().isAfter(c.validFrom()))
                throw new IllegalArgumentException("La fecha final debe ser posterior a la fecha inicial.");
            for (var prior : existing) if (overlaps(c, prior)) {
                if (sameRangeAndTerms(c, prior) && c.validFrom().isAfter(prior.getValidFrom())
                        && (prior.getValidUntil() == null || c.validFrom().isBefore(prior.getValidUntil()))) {
                    closeAt.merge(prior, c.validFrom(), (earlier, later) -> earlier.isBefore(later) ? earlier : later);
                } else {
                    throw new IllegalArgumentException("La condición se solapa con otra vigente; para cambiar su tasa usa el mismo rango y una fecha de inicio posterior.");
                }
            }
            for (var prior : otherProducts) if (overlaps(c, prior)) throw new IllegalArgumentException("La condición se solapa con otro producto de esta cooperativa.");
            for (var prior : accepted) if (overlaps(c, prior)) throw new IllegalArgumentException("Las condiciones nuevas se solapan entre sí.");
            accepted.add(c);
        }
        closeAt.forEach((condition, end) -> { condition.setValidUntil(end); conditionRepository.save(condition); });
    }

    private boolean sameRangeAndTerms(FinancialProductConditionRequest request, FinancialProductCondition existing) {
        return request.minimumAmount().compareTo(existing.getMinimumAmount()) == 0
                && request.maximumAmount().compareTo(existing.getMaximumAmount()) == 0
                && request.minimumTermMonths().equals(existing.getMinimumTermMonths())
                && request.maximumTermMonths().equals(existing.getMaximumTermMonths());
    }

    @Transactional(readOnly = true)
    public Optional<java.math.BigDecimal> applicableCreditRate(Long cooperativeId, java.math.BigDecimal amount, Integer months) {
        Instant now = Instant.now();
        List<java.math.BigDecimal> rates = productRepository.findByCooperativeIdOrderById(cooperativeId).stream()
                .filter(p -> p.isActive() && p.getType() == FinancialProductType.CREDIT)
                .flatMap(p -> conditionRepository.findByProductIdOrderByValidFromDescIdDesc(p.getId()).stream())
                .filter(c -> !c.getValidFrom().isAfter(now) && (c.getValidUntil() == null || c.getValidUntil().isAfter(now)))
                .filter(c -> amount.compareTo(c.getMinimumAmount()) >= 0 && amount.compareTo(c.getMaximumAmount()) <= 0)
                .filter(c -> months >= c.getMinimumTermMonths() && months <= c.getMaximumTermMonths())
                .map(FinancialProductCondition::getAnnualRate).toList();
        if (rates.size() > 1) throw new IllegalStateException("Más de una condición de crédito coincide; corrige los rangos superpuestos.");
        return rates.stream().findFirst();
    }

    private boolean overlaps(FinancialProductConditionRequest a, FinancialProductCondition b) {
        return rangesOverlap(a.minimumAmount(), a.maximumAmount(), b.getMinimumAmount(), b.getMaximumAmount())
                && rangesOverlap(a.minimumTermMonths(), a.maximumTermMonths(), b.getMinimumTermMonths(), b.getMaximumTermMonths())
                && datesOverlap(a.validFrom(), a.validUntil(), b.getValidFrom(), b.getValidUntil());
    }
    private boolean overlaps(FinancialProductConditionRequest a, FinancialProductConditionRequest b) {
        return rangesOverlap(a.minimumAmount(), a.maximumAmount(), b.minimumAmount(), b.maximumAmount())
                && rangesOverlap(a.minimumTermMonths(), a.maximumTermMonths(), b.minimumTermMonths(), b.maximumTermMonths())
                && datesOverlap(a.validFrom(), a.validUntil(), b.validFrom(), b.validUntil());
    }
    private boolean rangesOverlap(java.math.BigDecimal a1, java.math.BigDecimal a2, java.math.BigDecimal b1, java.math.BigDecimal b2) {
        return a1.compareTo(b2) <= 0 && b1.compareTo(a2) <= 0;
    }
    private boolean rangesOverlap(Integer a1, Integer a2, Integer b1, Integer b2) {
        return a1.compareTo(b2) <= 0 && b1.compareTo(a2) <= 0;
    }
    private boolean datesOverlap(Instant a1, Instant a2, Instant b1, Instant b2) {
        return (a2 == null || b1.isBefore(a2)) && (b2 == null || a1.isBefore(b2));
    }
    private void validateBounds(java.math.BigDecimal min, java.math.BigDecimal max, String message) {
        if (min.compareTo(max) > 0) throw new IllegalArgumentException(message);
    }
    private void apply(FinancialProduct product, FinancialProductRequest request) {
        product.setType(request.type()); product.setName(request.name().trim());
        product.setDescription(request.description()); product.setMinimumAmount(request.minimumAmount());
        product.setMaximumAmount(request.maximumAmount()); product.setActive(request.active() == null || request.active());
        if (request.calculationMethod() != null) product.setCalculationMethod(request.calculationMethod());
        if (request.interestPaymentOptions() != null) product.setInterestPaymentOptions(new LinkedHashSet<>(request.interestPaymentOptions()));
        if (request.renewalConditions() != null) product.setRenewalConditions(request.renewalConditions());
        if (request.earlyCancellationConditions() != null) product.setEarlyCancellationConditions(request.earlyCancellationConditions());
        if (request.targetAudience() != null) product.setTargetAudience(request.targetAudience());
    }
    private FinancialProductCondition saveCondition(Long productId, FinancialProductConditionRequest request) {
        FinancialProductCondition c = new FinancialProductCondition(); c.setProductId(productId);
        c.setMinimumAmount(request.minimumAmount()); c.setMaximumAmount(request.maximumAmount());
        c.setMinimumTermMonths(request.minimumTermMonths()); c.setMaximumTermMonths(request.maximumTermMonths());
        c.setAnnualRate(request.annualRate()); c.setValidFrom(request.validFrom()); c.setValidUntil(request.validUntil());
        return conditionRepository.save(c);
    }
    private void requireCooperative(Long id) {
        if (!cooperativeRepository.existsById(id)) throw new EntityNotFoundException("Cooperativa no encontrada.");
    }
    private void lockCooperative(Long id) {
        if (cooperativeRepository.lockById(id).isEmpty()) throw new EntityNotFoundException("Cooperativa no encontrada.");
    }
    private FinancialProductResponse toResponse(FinancialProduct p) { return toResponse(p, false); }
    private FinancialProductResponse toResponse(FinancialProduct p, boolean activeOnly) {
        Instant now = Instant.now();
        var conditions = conditionRepository.findByProductIdOrderByValidFromDescIdDesc(p.getId()).stream()
                .filter(c -> !activeOnly || !c.getValidFrom().isAfter(now))
                .filter(c -> !activeOnly || c.getValidUntil() == null || c.getValidUntil().isAfter(now))
                .map(this::toCondition).toList();
        return new FinancialProductResponse(p.getId(), p.getCooperativeId(), p.getType(), p.getName(), p.getDescription(), p.getMinimumAmount(), p.getMaximumAmount(), p.isActive(), conditions, p.getInterestPaymentOptions(), p.getCalculationMethod(), p.getRenewalConditions(), p.getEarlyCancellationConditions(), p.getTargetAudience());
    }
    private FinancialProductResponse.Condition toCondition(FinancialProductCondition c) {
        return new FinancialProductResponse.Condition(c.getId(), c.getMinimumAmount(), c.getMaximumAmount(), c.getMinimumTermMonths(), c.getMaximumTermMonths(), c.getAnnualRate(), c.getValidFrom(), c.getValidUntil());
    }
}
