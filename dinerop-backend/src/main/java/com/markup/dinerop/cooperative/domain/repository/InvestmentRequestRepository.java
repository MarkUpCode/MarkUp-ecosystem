package com.markup.dinerop.cooperative.domain.repository;

import com.markup.dinerop.cooperative.domain.entity.InvestmentRequest;
import com.markup.dinerop.cooperative.domain.entity.InvestmentRequestStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Lock;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import jakarta.persistence.LockModeType;
import java.util.Optional;

import java.math.BigDecimal;
import java.util.Collection;
import java.util.List;

public interface InvestmentRequestRepository extends JpaRepository<InvestmentRequest, Long> {
    @Lock(LockModeType.PESSIMISTIC_WRITE)
    @Query("select r from InvestmentRequest r where r.id = :id")
    Optional<InvestmentRequest> findByIdForUpdate(@Param("id") Long id);
    List<InvestmentRequest> findByClientIdOrderByCreatedAtDesc(Long clientId);
    List<InvestmentRequest> findByCooperativeIdOrderByCreatedAtDesc(Long cooperativeId);
    boolean existsByClientIdAndProductIdAndConditionIdAndAmountAndTermMonthsAndStatusIn(
            Long clientId, Long productId, Long conditionId, BigDecimal amount,
            Integer termMonths, Collection<InvestmentRequestStatus> statuses);
}
