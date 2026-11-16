package com.markup.dinerop.credit.domain.model;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

/** Append-only audit record for a submission or cooperative decision. */
@Entity
@Table(name = "credit_guarantor_evaluation", indexes = {
        @Index(name = "idx_guarantor_eval_submission", columnList = "submission_id, created_at")
})
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CreditGuarantorEvaluation {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "submission_id", nullable = false)
    private Long submissionId;

    @Column(name = "decision", nullable = false, length = 40)
    private String decision;

    @Column(name = "reasons_json", columnDefinition = "text")
    private String reasonsJson;

    @Column(name = "other_reason", columnDefinition = "text")
    private String otherReason;

    @Column(name = "observation", columnDefinition = "text")
    private String observation;

    @Column(name = "actor_id", nullable = false)
    private Long actorId;

    @Column(name = "actor_role", nullable = false, length = 20)
    private String actorRole;

    @Column(name = "created_at", nullable = false)
    private LocalDateTime createdAt;

    @PrePersist
    void onCreate() {
        if (createdAt == null) createdAt = LocalDateTime.now();
    }
}
