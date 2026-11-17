package com.markup.dinerop.cooperative.domain.repository;

import com.markup.dinerop.cooperative.domain.entity.InvestmentRequestStatusEvent;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface InvestmentRequestStatusEventRepository extends JpaRepository<InvestmentRequestStatusEvent, Long> {
    List<InvestmentRequestStatusEvent> findByRequestIdOrderByCreatedAtAscIdAsc(Long requestId);
}
