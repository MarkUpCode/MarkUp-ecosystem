package com.markup.dinerop.credit.infrastructure.repository;

import com.markup.dinerop.credit.domain.model.CreditGuarantorSubmission;
import com.markup.dinerop.credit.domain.model.enums.CreditGuarantorStatus;
import jakarta.persistence.LockModeType;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Lock;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface CreditGuarantorSubmissionRepository extends JpaRepository<CreditGuarantorSubmission, Long> {
    Optional<CreditGuarantorSubmission> findTopBySolicitudCooperativaIdOrderByAttemptNumberDesc(Long solicitudCooperativaId);
    List<CreditGuarantorSubmission> findBySolicitudCooperativaIdOrderByAttemptNumberDesc(Long solicitudCooperativaId);
    long countBySolicitudCooperativaId(Long solicitudCooperativaId);
    boolean existsBySolicitudCooperativaIdAndStatus(Long solicitudCooperativaId, CreditGuarantorStatus status);

    @Lock(LockModeType.PESSIMISTIC_WRITE)
    @Query("select s from CreditGuarantorSubmission s where s.id = :id")
    Optional<CreditGuarantorSubmission> findForUpdate(@Param("id") Long id);
}
