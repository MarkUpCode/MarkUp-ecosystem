package com.markup.dinerop.cooperative.domain.repository;

import com.markup.dinerop.cooperative.domain.entity.InvestmentAcceptanceRecord;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

public interface InvestmentAcceptanceRepository extends JpaRepository<InvestmentAcceptanceRecord, Long> {
    Optional<InvestmentAcceptanceRecord> findByRequestId(Long requestId);
}

