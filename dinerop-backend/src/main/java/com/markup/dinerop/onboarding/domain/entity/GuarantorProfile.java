package com.markup.dinerop.onboarding.domain.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

/** A client's reusable guarantor profile. Evaluation state belongs to a credit submission. */
@Entity
@Table(name = "guarantor_profile", uniqueConstraints = {
        @UniqueConstraint(name = "uk_guarantor_profile_person", columnNames = "persona_id"),
        @UniqueConstraint(name = "uk_guarantor_profile_owner_cedula", columnNames = {"client_user_id", "cedula"})
})
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class GuarantorProfile {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "client_user_id", nullable = false)
    private Long clientUserId;

    @Column(name = "cedula", nullable = false, length = 255)
    private String cedula;

    @OneToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "persona_id", nullable = false)
    private PersonaOnboarding persona;

    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @Column(name = "updated_at", nullable = false)
    private LocalDateTime updatedAt;

    @PrePersist
    void onCreate() {
        LocalDateTime now = LocalDateTime.now();
        if (createdAt == null) createdAt = now;
        if (updatedAt == null) updatedAt = now;
    }

    @PreUpdate
    void onUpdate() {
        updatedAt = LocalDateTime.now();
    }
}
