package com.markup.dinerop.cooperative.dto;

import com.markup.dinerop.auth.dto.PublicRegistrationRequest;
import com.markup.dinerop.cooperative.domain.entity.InterestPaymentOption;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

import java.math.BigDecimal;

public record PublicInvestmentRegistrationRequest(
        @NotBlank @Email String email,
        @NotBlank String firstName,
        @NotBlank String lastName,
        @NotBlank String identification,
        @NotBlank String phone,
        @NotBlank String province,
        @NotBlank String city,
        @NotBlank String parish,
        @NotNull Long productId,
        @NotNull Long conditionId,
        @NotNull @DecimalMin("0.01") BigDecimal amount,
        @NotNull @Min(1) Integer termMonths,
        InterestPaymentOption interestPaymentOption,
        @NotNull Boolean personalDataConsent
) {
    public PublicRegistrationRequest registrationData() {
        return PublicRegistrationRequest.builder().email(email).firstName(firstName)
                .lastName(lastName).identification(identification).phone(phone)
                .province(province).city(city).parish(parish).build();
    }

    public CreateInvestmentRequest investmentData() {
        return new CreateInvestmentRequest(productId, conditionId, amount, termMonths,
                interestPaymentOption, personalDataConsent);
    }
}
