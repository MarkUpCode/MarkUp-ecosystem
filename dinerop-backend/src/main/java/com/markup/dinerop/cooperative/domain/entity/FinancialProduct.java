package com.markup.dinerop.cooperative.domain.entity;

import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;
import java.time.Instant;

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

    @Column(nullable = false, length = 120)
    private String name;

    @Column(length = 2000)
    private String description;

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
