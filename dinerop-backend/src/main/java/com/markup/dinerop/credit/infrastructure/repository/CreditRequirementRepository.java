package com.markup.dinerop.credit.infrastructure.repository;

import com.markup.dinerop.credit.domain.model.CreditRequirement;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface CreditRequirementRepository extends JpaRepository<CreditRequirement, Long> {
    List<CreditRequirement> findBySolicitudCooperativaIdOrderByDisplayOrderAsc(Long solicitudCooperativaId);
    void deleteBySolicitudCooperativaId(Long solicitudCooperativaId);
}
