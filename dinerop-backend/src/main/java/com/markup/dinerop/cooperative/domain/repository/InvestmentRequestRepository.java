package com.markup.dinerop.cooperative.domain.repository;

import com.markup.dinerop.cooperative.domain.entity.InvestmentRequest;
import com.markup.dinerop.cooperative.domain.entity.InvestmentRequestStatus;
import org.springframework.data.jpa.repository.JpaRepository;

import java.math.BigDecimal;
import java.util.Collection;
import java.util.List;

public interface InvestmentRequestRepository extends JpaRepository<InvestmentRequest, Long> {
    List<InvestmentRequest> findByClientIdOrderByCreatedAtDesc(Long clientId);
    List<InvestmentRequest> findByCooperativeIdOrderByCreatedAtDesc(Long cooperativeId);
    boolean existsByClientIdAndProductIdAndConditionIdAndAmountAndTermMonthsAndStatusIn(
            Long clientId, Long productId, Long conditionId, BigDecimal amount,
            Integer termMonths, Collection<InvestmentRequestStatus> statuses);
}
