package com.markup.dinerop.cooperative.domain.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;
import java.time.Instant;

@Entity
@Table(name = "investment_requests", indexes = {
        @Index(name = "idx_investment_request_client", columnList = "client_id,created_at"),
        @Index(name = "idx_investment_request_cooperative", columnList = "cooperative_id,status,created_at")
})
@Getter
@Setter
@NoArgsConstructor
public class InvestmentRequest {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "client_id", nullable = false)
    private Long clientId;

    @Column(name = "cooperative_id", nullable = false)
    private Long cooperativeId;

    @Column(name = "product_id", nullable = false)
    private Long productId;

    @Column(name = "condition_id", nullable = false)
    private Long conditionId;

    @Column(name = "product_name_snapshot", nullable = false, length = 120)
    private String productNameSnapshot;

    @Column(name = "product_description_snapshot", length = 2000)
    private String productDescriptionSnapshot;

    @Column(name = "renewal_conditions_snapshot", length = 2000)
    private String renewalConditionsSnapshot;

    @Column(name = "early_cancellation_snapshot", length = 2000)
    private String earlyCancellationSnapshot;

    @Column(name = "target_audience_snapshot", length = 500)
    private String targetAudienceSnapshot;

    @Column(name = "client_name_snapshot", nullable = false, length = 200)
    private String clientNameSnapshot;

    @Column(name = "client_email_snapshot", nullable = false, length = 150)
    private String clientEmailSnapshot;

    @Column(name = "client_phone_snapshot", length = 30)
    private String clientPhoneSnapshot;

    @Column(nullable = false, precision = 20, scale = 2)
    private BigDecimal amount;

    @Column(name = "term_months", nullable = false)
    private Integer termMonths;

    @Enumerated(EnumType.STRING)
    @Column(name = "interest_payment_option", length = 20)
    private InterestPaymentOption interestPaymentOption;

    @Column(name = "annual_rate_snapshot", nullable = false, precision = 7, scale = 4)
    private BigDecimal annualRateSnapshot;

    @Column(name = "condition_minimum_amount_snapshot", nullable = false, precision = 20, scale = 2)
    private BigDecimal conditionMinimumAmountSnapshot;

    @Column(name = "condition_maximum_amount_snapshot", nullable = false, precision = 20, scale = 2)
    private BigDecimal conditionMaximumAmountSnapshot;

    @Column(name = "condition_minimum_term_snapshot", nullable = false)
    private Integer conditionMinimumTermSnapshot;

    @Column(name = "condition_maximum_term_snapshot", nullable = false)
    private Integer conditionMaximumTermSnapshot;

    @Column(name = "rate_valid_from_snapshot", nullable = false)
    private Instant rateValidFromSnapshot;

    @Column(name = "rate_valid_until_snapshot")
    private Instant rateValidUntilSnapshot;

    @Enumerated(EnumType.STRING)
    @Column(name = "calculation_method_snapshot", nullable = false, length = 30)
    private InvestmentCalculationMethod calculationMethodSnapshot;

    @Column(name = "estimated_interest", precision = 20, scale = 2)
    private BigDecimal estimatedInterest;

    @Column(name = "estimated_total", precision = 20, scale = 2)
    private BigDecimal estimatedTotal;

    @Column(name = "personal_data_consent", nullable = false)
    private boolean personalDataConsent;

    @Column(name = "consented_at", nullable = false)
    private Instant consentedAt;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 30)
    private InvestmentRequestStatus status;

    @Column(name = "created_at", nullable = false)
    private Instant createdAt;

    @Column(name = "updated_at", nullable = false)
    private Instant updatedAt;

    @PrePersist
    void onCreate() {
        var now = Instant.now();
        if (createdAt == null) createdAt = now;
        if (updatedAt == null) updatedAt = now;
    }

    @PreUpdate
    void onUpdate() {
        updatedAt = Instant.now();
    }
}
