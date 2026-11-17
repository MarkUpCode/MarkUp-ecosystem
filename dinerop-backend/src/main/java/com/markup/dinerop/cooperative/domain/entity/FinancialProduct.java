package com.markup.dinerop.cooperative.domain.entity;

import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.LinkedHashSet;
import java.util.Set;

@Entity
@Table(name = "financial_products", indexes = @Index(name = "idx_financial_product_coop", columnList = "cooperative_id,type"))
@Getter @Setter @NoArgsConstructor
public class FinancialProduct {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "cooperative_id", nullable = false)
    private Long cooperativeId;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private FinancialProductType type;

    @Enumerated(EnumType.STRING)
    @Column(name = "credit_category", length = 30)
    private CreditProductCategory creditCategory;

    @Column(nullable = false, length = 120)
    private String name;

    @Column(length = 2000)
    private String description;

    @Column(name = "renewal_conditions", length = 2000)
    private String renewalConditions;

    @Column(name = "early_cancellation_conditions", length = 2000)
    private String earlyCancellationConditions;

    @Column(name = "target_audience", length = 500)
    private String targetAudience;

    @Enumerated(EnumType.STRING)
    @Column(name = "calculation_method", nullable = false, length = 30)
    private InvestmentCalculationMethod calculationMethod = InvestmentCalculationMethod.UNSPECIFIED;

    @ElementCollection(fetch = FetchType.EAGER)
    @CollectionTable(name = "financial_product_interest_options", joinColumns = @JoinColumn(name = "product_id"))
    @Enumerated(EnumType.STRING)
    @Column(name = "payment_option", nullable = false, length = 20)
    private Set<InterestPaymentOption> interestPaymentOptions = new LinkedHashSet<>();

    @Column(name = "minimum_amount", nullable = false, precision = 20, scale = 2)
    private BigDecimal minimumAmount;

    @Column(name = "maximum_amount", nullable = false, precision = 20, scale = 2)
    private BigDecimal maximumAmount;

    @Column(nullable = false)
    private boolean active = true;

    @Column(name = "created_at", nullable = false, updatable = false)
    private Instant createdAt;

    @PrePersist
    void onCreate() { if (createdAt == null) createdAt = Instant.now(); }
}
