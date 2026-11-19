package com.markup.dinerop.cooperative.domain.service;

import com.markup.dinerop.cooperative.domain.entity.*;
import com.markup.dinerop.cooperative.domain.repository.*;
import com.markup.dinerop.cooperative.dto.*;
import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.http.HttpStatus;
import org.springframework.web.server.ResponseStatusException;
import java.time.Instant;
import java.math.BigDecimal;
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

    @Transactional(readOnly = true)
    public List<PublicCreditOfferResponse> getPublicCreditOffers(CreditProductCategory category,
            BigDecimal amount, Integer termMonths) {
        Instant now = Instant.now();
        return productRepository.findAll().stream()
                .filter(FinancialProduct::isActive)
                .filter(product -> product.getType() == FinancialProductType.CREDIT
                        && product.getCreditCategory() == category)
                .filter(product -> amount.compareTo(product.getMinimumAmount()) >= 0
                        && amount.compareTo(product.getMaximumAmount()) <= 0)
                .flatMap(product -> conditionRepository.findByProductIdOrderByValidFromDescIdDesc(product.getId()).stream()
                        .filter(condition -> !condition.getValidFrom().isAfter(now)
                                && (condition.getValidUntil() == null || condition.getValidUntil().isAfter(now)))
                        .filter(condition -> amount.compareTo(condition.getMinimumAmount()) >= 0
                                && amount.compareTo(condition.getMaximumAmount()) <= 0)
                        .filter(condition -> termMonths >= condition.getMinimumTermMonths()
                                && termMonths <= condition.getMaximumTermMonths())
                        .map(condition -> {
                            var cooperative = cooperativeRepository.findById(product.getCooperativeId()).orElse(null);
                            if (cooperative == null) return null;
                            return new PublicCreditOfferResponse(product.getCooperativeId(), cooperative.getNombre(),
                                    product.getId(), displayName(product), displayDescription(product),
                                    product.getCreditCategory(), amount, termMonths, condition.getAnnualRate(),
                                    "Condiciones sujetas a evaluación y confirmación de la cooperativa.");
                        }))
                .filter(Objects::nonNull)
                .toList();
    }

    @Transactional(readOnly = true)
    public Set<Long> getCooperativeIdsWithEligibleCreditProduct(CreditProductCategory category, BigDecimal amount) {
        if (category == null || amount == null) return Set.of();
        return productRepository.findByTypeAndCreditCategoryAndActiveTrue(FinancialProductType.CREDIT, category)
                .stream()
                .filter(product -> product.getMinimumAmount() != null && product.getMaximumAmount() != null)
                .filter(product -> amount.compareTo(product.getMinimumAmount()) >= 0
                        && amount.compareTo(product.getMaximumAmount()) <= 0)
                .map(FinancialProduct::getCooperativeId)
                .collect(java.util.stream.Collectors.toSet());
    }

    @Transactional
    public FinancialProductResponse create(Long cooperativeId, FinancialProductRequest request) {
        lockCooperative(cooperativeId);
        validateProductCategory(request);
        ensureUniqueCatalogProduct(cooperativeId, request, null);
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
        validateProductCategory(request);
        FinancialProduct product = productRepository.findById(productId)
                .filter(p -> p.getCooperativeId().equals(cooperativeId))
                .orElseThrow(() -> new EntityNotFoundException("Producto no encontrado."));
        ensureUniqueCatalogProduct(cooperativeId, request, productId);
        validateBounds(request.minimumAmount(), request.maximumAmount(), "El rango del producto es inválido.");
        List<FinancialProductCondition> history = conditionRepository.findByProductIdOrderByValidFromDescIdDesc(productId);
        if (!history.isEmpty() && (product.getType() != request.type()
                || (product.getCreditCategory() != null && product.getCreditCategory() != request.creditCategory())))
            throw new IllegalArgumentException("No se puede cambiar el tipo de un producto con historial financiero.");
        apply(product, request);
        FinancialProduct savedProduct = productRepository.save(product);
        if (request.conditions() != null) replaceConditions(savedProduct, request.conditions(), history);
        else {
            Instant now = Instant.now();
            boolean currentConditionOutsideNewBounds = history.stream()
                    .anyMatch(condition -> !condition.getValidFrom().isAfter(now)
                            && (condition.getValidUntil() == null || condition.getValidUntil().isAfter(now))
                            && (condition.getMinimumAmount().compareTo(savedProduct.getMinimumAmount()) < 0
                            || condition.getMaximumAmount().compareTo(savedProduct.getMaximumAmount()) > 0));
            if (currentConditionOutsideNewBounds) {
                throw new IllegalArgumentException("El nuevo rango debe contener las condiciones vigentes. Actualiza también la matriz de tasas.");
            }
        }
        return toResponse(savedProduct);
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

    private void replaceConditions(FinancialProduct product, List<FinancialProductConditionRequest> requested,
                                   List<FinancialProductCondition> history) {
        Instant now = Instant.now();
        boolean hasScheduledCondition = history.stream().anyMatch(condition -> condition.getValidFrom().isAfter(now)
                && (condition.getValidUntil() == null || condition.getValidUntil().isAfter(now)));
        if (hasScheduledCondition) {
            throw new ResponseStatusException(HttpStatus.CONFLICT,
                    "Hay tasas programadas para una fecha futura. Espera a que entren en vigencia antes de reemplazar la matriz.");
        }

        Instant startsAt = now;
        for (var existing : history) {
            boolean current = !existing.getValidFrom().isAfter(now)
                    && (existing.getValidUntil() == null || existing.getValidUntil().isAfter(now));
            if (!current) continue;
            if (!existing.getValidFrom().isBefore(startsAt)) startsAt = existing.getValidFrom().plusNanos(1);
        }

        for (var existing : history) {
            boolean current = !existing.getValidFrom().isAfter(now)
                    && (existing.getValidUntil() == null || existing.getValidUntil().isAfter(now));
            if (current) {
                existing.setValidUntil(startsAt);
                conditionRepository.save(existing);
            }
        }

        final Instant effectiveStartsAt = startsAt;
        List<FinancialProductConditionRequest> newVersion = requested.stream()
                .map(condition -> new FinancialProductConditionRequest(condition.minimumAmount(), condition.maximumAmount(),
                        condition.minimumTermMonths(), condition.maximumTermMonths(), condition.annualRate(),
                        effectiveStartsAt, condition.validUntil()))
                .toList();
        validateConditions(product, newVersion, history);
        newVersion.forEach(condition -> saveCondition(product.getId(), condition));
    }

    private void validateConditions(FinancialProduct product, List<FinancialProductConditionRequest> incoming,
                                    List<FinancialProductCondition> existing) {
        List<FinancialProductCondition> otherProducts = productRepository.findByCooperativeIdOrderById(product.getCooperativeId()).stream()
                .filter(other -> !Objects.equals(other.getId(), product.getId()))
                .filter(other -> other.getType() == product.getType())
                .filter(other -> other.getCreditCategory() == product.getCreditCategory())
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
    public Optional<java.math.BigDecimal> applicableCreditRate(Long cooperativeId, CreditProductCategory category,
            java.math.BigDecimal amount, Integer months) {
        Instant now = Instant.now();
        List<java.math.BigDecimal> rates = productRepository.findByCooperativeIdOrderById(cooperativeId).stream()
                .filter(p -> p.isActive() && p.getType() == FinancialProductType.CREDIT
                        && p.getCreditCategory() == category)
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
        product.setType(request.type()); product.setCreditCategory(request.creditCategory());
        product.setName(displayName(request.type(), request.creditCategory()));
        product.setDescription(displayDescription(request.type(), request.creditCategory()));
        product.setMinimumAmount(request.minimumAmount());
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
        return new FinancialProductResponse(p.getId(), p.getCooperativeId(), p.getType(), p.getCreditCategory(), displayName(p), displayDescription(p), p.getMinimumAmount(), p.getMaximumAmount(), p.isActive(), conditions, p.getInterestPaymentOptions(), p.getCalculationMethod(), p.getRenewalConditions(), p.getEarlyCancellationConditions(), p.getTargetAudience());
    }

    private void validateProductCategory(FinancialProductRequest request) {
        if (request.type() == FinancialProductType.CREDIT && request.creditCategory() == null)
            throw new IllegalArgumentException("Selecciona consumo o microcrédito para este producto.");
        if (request.type() == FinancialProductType.INVESTMENT && request.creditCategory() != null)
            throw new IllegalArgumentException("Los productos de inversión no tienen una categoría de crédito.");
    }

    private void ensureUniqueCatalogProduct(Long cooperativeId, FinancialProductRequest request, Long excludedId) {
        boolean duplicate = productRepository.findByCooperativeIdOrderById(cooperativeId).stream()
                .anyMatch(product -> !Objects.equals(product.getId(), excludedId)
                        && product.getType() == request.type()
                        && product.getCreditCategory() == request.creditCategory());
        if (duplicate) {
            throw new ResponseStatusException(HttpStatus.CONFLICT,
                    "Esta cooperativa ya tiene configurado este producto del catálogo. Edita la configuración existente.");
        }
    }

    public static String displayName(FinancialProduct product) {
        return displayName(product.getType(), product.getCreditCategory());
    }

    public static String displayDescription(FinancialProduct product) {
        return displayDescription(product.getType(), product.getCreditCategory());
    }

    private static String displayName(FinancialProductType type, CreditProductCategory category) {
        if (type == FinancialProductType.INVESTMENT) return "Depósito a plazo fijo";
        return category == CreditProductCategory.MICROCREDITO ? "Microcrédito" : "Crédito de consumo";
    }

    private static String displayDescription(FinancialProductType type, CreditProductCategory category) {
        if (type == FinancialProductType.INVESTMENT) {
            return "Depósito de dinero por un plazo acordado, con una tasa anual y condiciones vigentes.";
        }
        return category == CreditProductCategory.MICROCREDITO
                ? "Financiamiento para actividades productivas y pequeños negocios."
                : "Financiamiento para necesidades personales de consumo.";
    }
    private FinancialProductResponse.Condition toCondition(FinancialProductCondition c) {
        return new FinancialProductResponse.Condition(c.getId(), c.getMinimumAmount(), c.getMaximumAmount(), c.getMinimumTermMonths(), c.getMaximumTermMonths(), c.getAnnualRate(), c.getValidFrom(), c.getValidUntil());
    }
}
