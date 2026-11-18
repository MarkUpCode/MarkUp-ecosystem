package com.markup.dinerop.cooperative.domain.service;

import com.markup.dinerop.auth.entity.User;
import com.markup.dinerop.auth.repository.UserRepository;
import com.markup.dinerop.cooperative.domain.entity.*;
import com.markup.dinerop.cooperative.domain.repository.*;
import com.markup.dinerop.cooperative.dto.*;
import com.markup.dinerop.cooperative.domain.entity.InvestmentAcceptanceRecord;
import com.markup.dinerop.notification.service.PushNotificationService;
import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import java.math.BigDecimal;
import java.math.MathContext;
import java.math.RoundingMode;
import java.time.Instant;
import java.net.URI;
import java.util.Comparator;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;
import java.util.TreeSet;

@Service
@RequiredArgsConstructor
public class InvestmentService {
    private static final List<InvestmentRequestStatus> ACTIVE_DUPLICATE_STATUSES = List.of(
            InvestmentRequestStatus.SUBMITTED,
            InvestmentRequestStatus.IN_REVIEW,
            InvestmentRequestStatus.INFORMATION_REQUIRED
    );

    private final FinancialProductRepository productRepository;
    private final FinancialProductConditionRepository conditionRepository;
    private final CooperativeRepository cooperativeRepository;
    private final InvestmentRequestRepository requestRepository;
    private final InvestmentRequestStatusEventRepository statusEventRepository;
    private final InvestmentAcceptanceRepository acceptanceRepository;
    private final PushNotificationService pushNotificationService;
    private final UserRepository userRepository;
    private final InvestmentCalculationSettingsService calculationSettingsService;

    @Transactional(readOnly = true)
    public List<InvestmentOfferResponse> compareOffers(
            BigDecimal amount,
            Integer termMonths,
            InterestPaymentOption paymentOption
    ) {
        if (amount == null || amount.signum() <= 0 || termMonths == null || termMonths <= 0) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Ingresa un monto y plazo válidos.");
        }
        Instant now = Instant.now();
        InvestmentCalculationMethod centralMethod = calculationSettingsService.currentMethod();
        return productRepository.findAll().stream()
                .filter(FinancialProduct::isActive)
                .filter(product -> product.getType() == FinancialProductType.INVESTMENT)
                .filter(product -> within(amount, product.getMinimumAmount(), product.getMaximumAmount()))
                .flatMap(product -> conditionRepository.findByProductIdOrderByValidFromDescIdDesc(product.getId())
                        .stream()
                        .filter(condition -> !condition.getValidFrom().isAfter(now))
                        .filter(condition -> condition.getValidUntil() == null || condition.getValidUntil().isAfter(now))
                        .filter(condition -> within(amount, condition.getMinimumAmount(), condition.getMaximumAmount()))
                        .filter(condition -> termMonths >= condition.getMinimumTermMonths()
                                && termMonths <= condition.getMaximumTermMonths())
                        .filter(condition -> paymentOption == null || product.getInterestPaymentOptions().contains(paymentOption))
                        .map(condition -> toOffer(product, condition, amount, termMonths, paymentOption,
                                effectiveCalculationMethod(product, centralMethod))))
                .sorted(Comparator
                        .comparing(InvestmentOfferResponse::estimatedInterest,
                                Comparator.nullsLast(Comparator.reverseOrder()))
                        .thenComparing(InvestmentOfferResponse::annualRate, Comparator.reverseOrder()))
                .toList();
    }

    @Transactional(readOnly = true)
    public InvestmentAvailabilityResponse getAvailability(BigDecimal amount, Integer termMonths) {
        if (amount == null || amount.signum() <= 0 || (termMonths != null && (termMonths < 1 || termMonths > 600))) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Ingresa un monto y plazo válidos.");
        }
        Instant now = Instant.now();
        var terms = new TreeSet<Integer>();
        var options = new LinkedHashSet<InterestPaymentOption>();
        for (var product : productRepository.findAll()) {
            if (!product.isActive() || product.getType() != FinancialProductType.INVESTMENT
                    || !within(amount, product.getMinimumAmount(), product.getMaximumAmount())) continue;
            for (var condition : conditionRepository.findByProductIdOrderByValidFromDescIdDesc(product.getId())) {
                if (condition.getValidFrom().isAfter(now)
                        || (condition.getValidUntil() != null && !condition.getValidUntil().isAfter(now))
                        || !within(amount, condition.getMinimumAmount(), condition.getMaximumAmount())) continue;
                if (termMonths == null) {
                    for (int month = condition.getMinimumTermMonths(); month <= condition.getMaximumTermMonths(); month++) {
                        terms.add(month);
                    }
                } else if (termMonths >= condition.getMinimumTermMonths()
                        && termMonths <= condition.getMaximumTermMonths()) {
                    options.addAll(product.getInterestPaymentOptions());
                }
            }
        }
        return new InvestmentAvailabilityResponse(List.copyOf(terms), Set.copyOf(options));
    }

    @Transactional
    public InvestmentRequestResponse createRequest(Long clientId, CreateInvestmentRequest request) {
        return createRequest(clientId, request, null, null);
    }

    @Transactional
    public InvestmentRequestResponse createRequest(Long clientId, CreateInvestmentRequest request,
                                                   String submittedClientName, String submittedPhone) {
        if (!Boolean.TRUE.equals(request.personalDataConsent())) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                    "Debes autorizar el envío de tus datos únicamente a la cooperativa seleccionada.");
        }
        var user = userRepository.findById(clientId)
                .orElseThrow(() -> new EntityNotFoundException("Usuario no encontrado."));
        var product = productRepository.findById(request.productId())
                .filter(FinancialProduct::isActive)
                .filter(item -> item.getType() == FinancialProductType.INVESTMENT)
                .orElseThrow(() -> new EntityNotFoundException("La oferta ya no está disponible."));
        var condition = conditionRepository.findById(request.conditionId())
                .filter(item -> item.getProductId().equals(product.getId()))
                .orElseThrow(() -> new EntityNotFoundException("La tasa seleccionada ya no está disponible."));

        Instant now = Instant.now();
        if (condition.getValidFrom().isAfter(now)
                || (condition.getValidUntil() != null && !condition.getValidUntil().isAfter(now))) {
            throw new ResponseStatusException(HttpStatus.CONFLICT,
                    "La vigencia de esta tasa cambió. Compara las ofertas nuevamente.");
        }
        if (!within(request.amount(), product.getMinimumAmount(), product.getMaximumAmount())
                || !within(request.amount(), condition.getMinimumAmount(), condition.getMaximumAmount())
                || request.termMonths() < condition.getMinimumTermMonths()
                || request.termMonths() > condition.getMaximumTermMonths()) {
            throw new ResponseStatusException(HttpStatus.CONFLICT,
                    "La oferta ya no coincide con el monto o plazo. Compara nuevamente.");
        }
        if (!product.getInterestPaymentOptions().isEmpty()
                && request.interestPaymentOption() != null
                && !product.getInterestPaymentOptions().contains(request.interestPaymentOption())) {
            throw new ResponseStatusException(HttpStatus.CONFLICT,
                    "Selecciona una forma de pago de intereses disponible para esta oferta.");
        }
        if (product.getInterestPaymentOptions().isEmpty() && request.interestPaymentOption() != null) {
            throw new ResponseStatusException(HttpStatus.CONFLICT,
                    "Esta oferta no tiene una forma de pago configurada. Compara nuevamente.");
        }
        if (requestRepository.existsByClientIdAndProductIdAndConditionIdAndAmountAndTermMonthsAndStatusIn(
                clientId, product.getId(), condition.getId(), request.amount(), request.termMonths(),
                ACTIVE_DUPLICATE_STATUSES)) {
            throw new ResponseStatusException(HttpStatus.CONFLICT,
                    "Ya tienes una solicitud activa para esta misma oferta.");
        }

        var cooperative = cooperativeRepository.findById(product.getCooperativeId())
                .orElseThrow(() -> new EntityNotFoundException("Cooperativa no encontrada."));
        InvestmentCalculationMethod calculationMethod = effectiveCalculationMethod(product,
                calculationSettingsService.currentMethod());
        var estimate = calculateInterest(request.amount(), condition.getAnnualRate(),
                request.termMonths(), calculationMethod, request.interestPaymentOption());
        String clientName = submittedClientName != null && !submittedClientName.isBlank()
                ? submittedClientName.trim()
                : ((user.getFirstName() == null ? "" : user.getFirstName().trim()) + " "
                + (user.getLastName() == null ? "" : user.getLastName().trim())).trim();
        if (clientName.isBlank()) clientName = user.getEmail();

        var investmentRequest = new InvestmentRequest();
        investmentRequest.setClientId(clientId);
        investmentRequest.setCooperativeId(product.getCooperativeId());
        investmentRequest.setProductId(product.getId());
        investmentRequest.setConditionId(condition.getId());
        investmentRequest.setProductNameSnapshot(FinancialProductService.displayName(product));
        investmentRequest.setProductDescriptionSnapshot(FinancialProductService.displayDescription(product));
        investmentRequest.setRenewalConditionsSnapshot(product.getRenewalConditions());
        investmentRequest.setEarlyCancellationSnapshot(product.getEarlyCancellationConditions());
        investmentRequest.setTargetAudienceSnapshot(product.getTargetAudience());
        investmentRequest.setClientNameSnapshot(clientName);
        investmentRequest.setClientEmailSnapshot(user.getEmail());
        investmentRequest.setClientPhoneSnapshot(submittedPhone == null ? user.getPhone() : submittedPhone);
        investmentRequest.setAmount(request.amount().setScale(2, RoundingMode.HALF_UP));
        investmentRequest.setTermMonths(request.termMonths());
        investmentRequest.setInterestPaymentOption(request.interestPaymentOption());
        investmentRequest.setAnnualRateSnapshot(condition.getAnnualRate());
        investmentRequest.setConditionMinimumAmountSnapshot(condition.getMinimumAmount());
        investmentRequest.setConditionMaximumAmountSnapshot(condition.getMaximumAmount());
        investmentRequest.setConditionMinimumTermSnapshot(condition.getMinimumTermMonths());
        investmentRequest.setConditionMaximumTermSnapshot(condition.getMaximumTermMonths());
        investmentRequest.setRateValidFromSnapshot(condition.getValidFrom());
        investmentRequest.setRateValidUntilSnapshot(condition.getValidUntil());
        investmentRequest.setCalculationMethodSnapshot(calculationMethod);
        investmentRequest.setEstimatedInterest(estimate);
        investmentRequest.setEstimatedTotal(estimate == null ? null : request.amount().add(estimate).setScale(2, RoundingMode.HALF_UP));
        investmentRequest.setPersonalDataConsent(true);
        investmentRequest.setConsentedAt(now);
        investmentRequest.setStatus(InvestmentRequestStatus.SUBMITTED);
        var saved = requestRepository.save(investmentRequest);
        recordStatus(saved.getId(), InvestmentRequestStatus.SUBMITTED,
                "La solicitud fue enviada a " + cooperative.getNombre() + ".", clientId);
        return toResponse(saved, cooperative, true);
    }

    @Transactional(readOnly = true)
    public List<InvestmentRequestResponse> getClientRequests(Long clientId) {
        return requestRepository.findByClientIdOrderByCreatedAtDesc(clientId).stream()
                .map(request -> toResponse(request,
                        cooperativeRepository.findById(request.getCooperativeId()).orElse(null), true))
                .toList();
    }

    @Transactional(readOnly = true)
    public List<InvestmentRequestResponse> getCooperativeRequests(Long cooperativeId) {
        return requestRepository.findByCooperativeIdOrderByCreatedAtDesc(cooperativeId).stream()
                .map(request -> toResponse(request,
                        cooperativeRepository.findById(request.getCooperativeId()).orElse(null), true))
                .toList();
    }

    @Transactional
    public InvestmentRequestResponse updateStatus(
            Long cooperativeId, Long requestId, UpdateInvestmentRequestStatus update, Long actorId
    ) {
        var request = requestRepository.findById(requestId)
                .filter(item -> item.getCooperativeId().equals(cooperativeId))
                .orElseThrow(() -> new EntityNotFoundException("Solicitud de inversión no encontrada."));
        if (request.getStatus() == InvestmentRequestStatus.CONDITIONS_CONFIRMED
                || request.getStatus() == InvestmentRequestStatus.DECLINED) {
            throw new ResponseStatusException(HttpStatus.CONFLICT,
                    "Esta solicitud ya tiene una respuesta final de la cooperativa.");
        }
        if (update.status() == InvestmentRequestStatus.SUBMITTED) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                    "No se puede devolver una solicitud a su estado inicial.");
        }
        if (update.status() == InvestmentRequestStatus.CONDITIONS_CONFIRMED) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                    "Usa la respuesta de aceptación para registrar agencia y requisitos.");
        }
        if ((update.status() == InvestmentRequestStatus.INFORMATION_REQUIRED
                || update.status() == InvestmentRequestStatus.DECLINED)
                && (update.note() == null || update.note().isBlank())) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                    "Explica al cliente qué información o motivo debe conocer.");
        }
        request.setStatus(update.status());
        var saved = requestRepository.save(request);
        recordStatus(saved.getId(), update.status(), update.note(), actorId);
        return toResponse(saved,
                cooperativeRepository.findById(cooperativeId).orElse(null), true);
    }

    @Transactional
    public InvestmentRequestResponse acceptRequest(Long cooperativeId, Long requestId,
            InvestmentAcceptanceRequest payload, Long actorId) {
        var request = requestRepository.findByIdForUpdate(requestId)
                .filter(item -> item.getCooperativeId().equals(cooperativeId))
                .orElseThrow(() -> new EntityNotFoundException("Solicitud de inversión no encontrada."));
        if (request.getStatus() == InvestmentRequestStatus.CONDITIONS_CONFIRMED
                || request.getStatus() == InvestmentRequestStatus.DECLINED
                || acceptanceRepository.findByRequestId(requestId).isPresent()) {
            throw new ResponseStatusException(HttpStatus.CONFLICT,
                    "Esta solicitud ya recibió una respuesta final.");
        }
        validateMapsUrl(payload.mapsUrl());
        var response = new InvestmentAcceptanceRecord();
        response.setRequestId(requestId);
        response.setCooperativeId(cooperativeId);
        response.setActorUserId(actorId);
        response.setAcceptanceMessage(payload.acceptanceMessage().trim());
        response.setConfirmedAnnualRate(payload.confirmedAnnualRate());
        response.setAgencyName(payload.agencyName().trim());
        response.setAgencyAddress(payload.agencyAddress().trim());
        response.setAgencyCity(payload.agencyCity().trim());
        response.setMapsUrl(payload.mapsUrl());
        response.setContactPhone(payload.contactPhone());
        response.setOpeningHours(payload.openingHours());
        response.setContactDepartment(payload.contactDepartment());
        response.setResponseDeadline(payload.responseDeadline());
        response.setInstructions(payload.instructions());
        response.setRequirements(payload.requirements().stream()
                .map(item -> new InvestmentAcceptanceRecord.Requirement(item.description().trim(), item.mandatory()))
                .toList());
        acceptanceRepository.save(response);
        request.setStatus(InvestmentRequestStatus.CONDITIONS_CONFIRMED);
        var saved = requestRepository.save(request);
        recordStatus(saved.getId(), InvestmentRequestStatus.CONDITIONS_CONFIRMED,
                payload.acceptanceMessage().trim(), actorId);
        pushNotificationService.sendInvestmentAccepted(saved.getClientId(), saved.getId(),
                cooperativeRepository.findById(cooperativeId).map(
                        com.markup.dinerop.cooperative.domain.entity.Cooperative::getNombre).orElse("La cooperativa"));
        return toResponse(saved, cooperativeRepository.findById(cooperativeId).orElse(null), true);
    }

    private void validateMapsUrl(String rawUrl) {
        if (rawUrl == null || rawUrl.isBlank()) return;
        try {
            URI uri = URI.create(rawUrl.trim());
            String host = uri.getHost() == null ? "" : uri.getHost().toLowerCase();
            boolean mapsHost = host.equals("maps.google.com") || host.equals("www.google.com")
                    || host.equals("google.com") || host.equals("maps.app.goo.gl")
                    || host.equals("goo.gl") || host.equals("www.google.com.ec");
            if (!"https".equalsIgnoreCase(uri.getScheme()) || !mapsHost || uri.getUserInfo() != null) {
                throw new IllegalArgumentException();
            }
        } catch (RuntimeException ex) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                    "El enlace debe ser una URL HTTPS válida de Google Maps.");
        }
    }

    private InvestmentOfferResponse toOffer(FinancialProduct product, FinancialProductCondition condition,
            BigDecimal amount, Integer months, InterestPaymentOption paymentOption,
            InvestmentCalculationMethod calculationMethod) {
        var cooperative = cooperativeRepository.findById(product.getCooperativeId()).orElse(null);
        var estimatedInterest = calculateInterest(amount, condition.getAnnualRate(), months,
                calculationMethod, paymentOption);
        return new InvestmentOfferResponse(
                product.getCooperativeId(), cooperative == null ? "Cooperativa" : cooperative.getNombre(),
                cooperative == null ? null : cooperative.getLogoUrl(), product.getId(), condition.getId(),
                FinancialProductService.displayName(product), FinancialProductService.displayDescription(product), product.getMinimumAmount(), product.getMaximumAmount(),
                condition.getMinimumAmount(), condition.getMaximumAmount(), condition.getMinimumTermMonths(),
                condition.getMaximumTermMonths(), condition.getAnnualRate(), condition.getValidFrom(),
                condition.getValidUntil(), product.getInterestPaymentOptions(), calculationMethod,
                product.getRenewalConditions(), product.getEarlyCancellationConditions(), product.getTargetAudience(),
                estimatedInterest, estimatedInterest == null ? null : amount.add(estimatedInterest).setScale(2, RoundingMode.HALF_UP));
    }

    private InvestmentCalculationMethod effectiveCalculationMethod(FinancialProduct product,
            InvestmentCalculationMethod centralMethod) {
        if (centralMethod != null && centralMethod != InvestmentCalculationMethod.UNSPECIFIED) {
            return centralMethod;
        }
        return product.getCalculationMethod() == null
                ? InvestmentCalculationMethod.UNSPECIFIED
                : product.getCalculationMethod();
    }

    private InvestmentRequestResponse toResponse(InvestmentRequest request,
            com.markup.dinerop.cooperative.domain.entity.Cooperative cooperative, boolean includeClientData) {
        var events = statusEventRepository.findByRequestIdOrderByCreatedAtAscIdAsc(request.getId());
        var lastEvent = events.isEmpty() ? null : events.get(events.size() - 1);
        return new InvestmentRequestResponse(
                request.getId(), request.getCooperativeId(),
                cooperative == null ? "Cooperativa" : cooperative.getNombre(),
                cooperative == null ? null : cooperative.getLogoUrl(), request.getProductId(), request.getConditionId(),
                request.getProductNameSnapshot(), request.getProductDescriptionSnapshot(), request.getAmount(),
                request.getTermMonths(), request.getInterestPaymentOption(), request.getAnnualRateSnapshot(),
                request.getConditionMinimumAmountSnapshot(), request.getConditionMaximumAmountSnapshot(),
                request.getConditionMinimumTermSnapshot(), request.getConditionMaximumTermSnapshot(),
                request.getRateValidFromSnapshot(), request.getRateValidUntilSnapshot(),
                request.getCalculationMethodSnapshot(), request.getEstimatedInterest(), request.getEstimatedTotal(),
                request.getRenewalConditionsSnapshot(), request.getEarlyCancellationSnapshot(),
                request.getTargetAudienceSnapshot(), request.getStatus(), lastEvent == null ? null : lastEvent.getNote(),
                request.getConsentedAt(), request.getCreatedAt(), request.getUpdatedAt(),
                includeClientData ? request.getClientNameSnapshot() : null,
                includeClientData ? request.getClientEmailSnapshot() : null,
                includeClientData ? request.getClientPhoneSnapshot() : null,
                events.stream().map(event -> new InvestmentRequestResponse.StatusEvent(
                        event.getStatus(), event.getNote(), event.getCreatedAt())).toList(),
                acceptanceRepository.findByRequestId(request.getId()).map(this::toAcceptanceResponse).orElse(null));
    }

    private com.markup.dinerop.cooperative.dto.InvestmentAcceptanceResponse toAcceptanceResponse(InvestmentAcceptanceRecord response) {
        return new com.markup.dinerop.cooperative.dto.InvestmentAcceptanceResponse(response.getAcceptanceMessage(), response.getConfirmedAnnualRate(),
                response.getAgencyName(), response.getAgencyAddress(), response.getAgencyCity(), response.getMapsUrl(),
                response.getContactPhone(), response.getOpeningHours(), response.getContactDepartment(),
                response.getResponseDeadline(), response.getInstructions(), response.getRespondedAt(),
                response.getRequirements().stream().map(item -> new com.markup.dinerop.cooperative.dto.InvestmentAcceptanceResponse.Requirement(
                        item.getDescription(), item.isMandatory())).toList());
    }

    private void recordStatus(Long requestId, InvestmentRequestStatus status, String note, Long actorId) {
        var event = new InvestmentRequestStatusEvent();
        event.setRequestId(requestId);
        event.setStatus(status);
        event.setNote(note);
        event.setChangedBy(actorId);
        statusEventRepository.save(event);
    }

    private BigDecimal calculateInterest(BigDecimal amount, BigDecimal annualRatePercent,
            int months, InvestmentCalculationMethod method, InterestPaymentOption paymentOption) {
        if (method == null || method == InvestmentCalculationMethod.UNSPECIFIED) return null;
        BigDecimal monthlyRate = annualRatePercent
                .divide(BigDecimal.valueOf(1200), 12, RoundingMode.HALF_UP);
        BigDecimal interest;
        if (method == InvestmentCalculationMethod.SIMPLE_INTEREST
                || paymentOption == InterestPaymentOption.MONTHLY) {
            interest = amount.multiply(annualRatePercent)
                    .multiply(BigDecimal.valueOf(months))
                    .divide(BigDecimal.valueOf(1200), 2, RoundingMode.HALF_UP);
        } else {
            BigDecimal growth = BigDecimal.ONE.add(monthlyRate)
                    .pow(months, MathContext.DECIMAL128);
            interest = amount.multiply(growth.subtract(BigDecimal.ONE))
                    .setScale(2, RoundingMode.HALF_UP);
        }
        return interest.max(BigDecimal.ZERO);
    }

    private boolean within(BigDecimal value, BigDecimal min, BigDecimal max) {
        return value.compareTo(min) >= 0 && value.compareTo(max) <= 0;
    }
}

