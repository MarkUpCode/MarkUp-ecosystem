package com.markup.dinerop.credit.infrastructure.repository;

import com.markup.dinerop.credit.domain.model.CreditProcessEvent;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface CreditProcessEventRepository extends JpaRepository<CreditProcessEvent, Long> {
    List<CreditProcessEvent> findBySolicitudIdOrderByFechaAsc(Long solicitudId);
}
