package com.markup.dinerop.cooperative.domain.entity;

import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;
import java.time.Instant;

@Entity
@Table(name = "financial_product_conditions", indexes = @Index(name = "idx_product_condition_product", columnList = "product_id,valid_from,valid_until"))
@Getter @Setter @NoArgsConstructor
public class FinancialProductCondition {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "product_id", nullable = false)
    private Long productId;

    @Column(name = "minimum_amount", nullable = false, precision = 20, scale = 2)
    private BigDecimal minimumAmount;

    @Column(name = "maximum_amount", nullable = false, precision = 20, scale = 2)
    private BigDecimal maximumAmount;

    @Column(name = "minimum_term_months", nullable = false)
    private Integer minimumTermMonths;

    @Column(name = "maximum_term_months", nullable = false)
    private Integer maximumTermMonths;

    @Column(name = "annual_rate", nullable = false, precision = 7, scale = 4)
    private BigDecimal annualRate;

    @Column(name = "valid_from", nullable = false)
    private Instant validFrom;

    @Column(name = "valid_until")
    private Instant validUntil;

    @Column(name = "created_at", nullable = false, updatable = false)
    private Instant createdAt;

    @PrePersist
    void onCreate() { if (createdAt == null) createdAt = Instant.now(); }
}
