package com.markup.dinerop.cooperative.domain.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.Instant;

@Entity
@Table(name = "investment_request_status_events", indexes = @Index(name = "idx_investment_request_events", columnList = "request_id,created_at,id"))
@Getter
@Setter
@NoArgsConstructor
public class InvestmentRequestStatusEvent {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "request_id", nullable = false)
    private Long requestId;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 30)
    private InvestmentRequestStatus status;

    @Column(length = 1000)
    private String note;

    @Column(name = "changed_by", nullable = false)
    private Long changedBy;

    @Column(name = "created_at", nullable = false)
    private Instant createdAt;

    @PrePersist
    void onCreate() {
        if (createdAt == null) createdAt = Instant.now();
    }
}
