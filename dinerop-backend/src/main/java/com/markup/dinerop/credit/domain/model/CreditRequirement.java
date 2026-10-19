package com.markup.dinerop.credit.domain.model;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "credit_requirements")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class CreditRequirement {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @Column(name = "solicitud_cooperativa_id", nullable = false)
    private Long solicitudCooperativaId;
    @Column(nullable = false, length = 180)
    private String title;
    @Column(length = 1000)
    private String description;
    @Column(nullable = false, length = 40)
    private String category;
    @Column(nullable = false)
    private boolean mandatory;
    @Column(nullable = false)
    private int displayOrder;
}
