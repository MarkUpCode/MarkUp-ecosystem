package com.markup.dinerop.credit.domain.model;

import com.markup.dinerop.credit.domain.model.enums.CreditGuarantorStatus;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "credit_guarantor_submission", uniqueConstraints = {
        @UniqueConstraint(name = "uk_credit_guarantor_attempt", columnNames = {"solicitud_cooperativa_id", "attempt_number"})
}, indexes = {
        @Index(name = "idx_credit_guarantor_credit", columnList = "credit_request_id"),
        @Index(name = "idx_credit_guarantor_profile", columnList = "profile_id")
})
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CreditGuarantorSubmission {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "profile_id", nullable = false)
    private Long profileId;

    @Column(name = "credit_request_id", nullable = false)
    private Long creditRequestId;

    @Column(name = "solicitud_cooperativa_id", nullable = false)
    private Long solicitudCooperativaId;

    @Column(name = "attempt_number", nullable = false)
    private Integer attemptNumber;

    @Column(name = "snapshot_json", nullable = false, columnDefinition = "text")
    private String snapshotJson;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false, length = 40)
    private CreditGuarantorStatus status;

    @Column(name = "submitted_by", nullable = false)
    private Long submittedBy;

    @Column(name = "submitted_at", nullable = false)
    private LocalDateTime submittedAt;

    @PrePersist
    void onCreate() {
        if (submittedAt == null) submittedAt = LocalDateTime.now();
        if (status == null) status = CreditGuarantorStatus.EN_REVISION;
    }
}
