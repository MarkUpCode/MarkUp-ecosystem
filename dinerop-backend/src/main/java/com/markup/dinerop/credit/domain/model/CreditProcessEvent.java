package com.markup.dinerop.credit.domain.model;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "solicitud_cooperativa_evento")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CreditProcessEvent {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "solicitud_id", nullable = false)
    private Long solicitudId;

    @Column(name = "solicitud_cooperativa_id", nullable = false)
    private Long solicitudCooperativaId;

    @Column(nullable = false, length = 60)
    private String tipo;

    @Column(nullable = false, length = 500)
    private String detalle;

    @Column(name = "actor_id")
    private Long actorId;

    @Column(name = "actor_role", length = 20)
    private String actorRole;

    @Column(nullable = false)
    private LocalDateTime fecha;

    @PrePersist
    void onCreate() {
        if (fecha == null) {
            fecha = LocalDateTime.now();
        }
    }
}
