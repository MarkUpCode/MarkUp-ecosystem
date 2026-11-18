package com.markup.dinerop.cooperative.infrastructure.web;

import com.markup.dinerop.auth.entity.User;
import com.markup.dinerop.auth.dto.PublicRegistrationRequest;
import com.markup.dinerop.auth.service.AuthService;
import com.markup.dinerop.cooperative.domain.entity.InterestPaymentOption;
import com.markup.dinerop.cooperative.domain.service.InvestmentService;
import com.markup.dinerop.cooperative.dto.CreateInvestmentRequest;
import com.markup.dinerop.cooperative.dto.InvestmentOfferResponse;
import com.markup.dinerop.cooperative.dto.InvestmentAvailabilityResponse;
import com.markup.dinerop.cooperative.dto.InvestmentRequestResponse;
import com.markup.dinerop.cooperative.dto.PublicInvestmentRegistrationRequest;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.util.List;
import org.springframework.transaction.annotation.Transactional;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/investments")
public class InvestmentController {
    private final InvestmentService investmentService;
    private final AuthService authService;

    @GetMapping("/availability")
    public InvestmentAvailabilityResponse getAvailability(
            @RequestParam BigDecimal amount,
            @RequestParam(required = false) Integer termMonths
    ) {
        return investmentService.getAvailability(amount, termMonths);
    }

    @GetMapping("/offers")
    public List<InvestmentOfferResponse> compareOffers(
            @RequestParam BigDecimal amount,
            @RequestParam Integer termMonths,
            @RequestParam(required = false) InterestPaymentOption interestPaymentOption
    ) {
        return investmentService.compareOffers(amount, termMonths, interestPaymentOption);
    }

    @PostMapping("/requests")
    @PreAuthorize("hasRole('CLIENT')")
    public InvestmentRequestResponse createRequest(
            @Valid @RequestBody CreateInvestmentRequest request,
            @AuthenticationPrincipal User user
    ) {
        return investmentService.createRequest(user.getIdUser(), request);
    }

    @PostMapping("/public-requests")
    @Transactional
    public Object createPublicRequest(@Valid @RequestBody PublicInvestmentRegistrationRequest request) {
        User user = authService.prepareInvestmentRegistration(request.registrationData());
        InvestmentRequestResponse saved = investmentService.createRequest(user.getIdUser(),
                request.investmentData(), request.firstName() + " " + request.lastName(), request.phone());
        var otp = authService.startRegistrationOtp(request.registrationData());
        return java.util.Map.of("investment", saved, "email", otp.getEmail(),
                "message", otp.getMessage(), "requiresVerification", otp.isRequiresVerification());
    }

    @GetMapping("/requests/me")
    @PreAuthorize("hasRole('CLIENT')")
    public List<InvestmentRequestResponse> getMyRequests(@AuthenticationPrincipal User user) {
        return investmentService.getClientRequests(user.getIdUser());
    }
}
