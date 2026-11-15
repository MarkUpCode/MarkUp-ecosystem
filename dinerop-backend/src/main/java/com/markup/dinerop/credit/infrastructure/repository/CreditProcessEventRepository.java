package com.markup.dinerop.credit.infrastructure.repository;

import com.markup.dinerop.credit.domain.model.CreditProcessEvent;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface CreditProcessEventRepository extends JpaRepository<CreditProcessEvent, Long> {
    List<CreditProcessEvent> findBySolicitudCooperativaIdOrderByFechaAsc(Long solicitudCooperativaId);

    Optional<CreditProcessEvent> findTopBySolicitudCooperativaIdOrderByFechaDescIdDesc(Long solicitudCooperativaId);

    boolean existsBySolicitudCooperativaIdAndTipo(Long solicitudCooperativaId, String tipo);
}
