package com.markup.dinerop.onboarding.infrastructure.repository;

import com.markup.dinerop.onboarding.domain.entity.GuarantorProfile;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface GuarantorProfileRepository extends JpaRepository<GuarantorProfile, Long> {
    @EntityGraph(attributePaths = {"persona", "persona.direccion", "persona.actividadEconomica", "persona.ingresoEgreso", "persona.referencias"})
    List<GuarantorProfile> findByClientUserIdOrderByUpdatedAtDescIdDesc(Long clientUserId);

    @EntityGraph(attributePaths = {"persona", "persona.direccion", "persona.actividadEconomica", "persona.ingresoEgreso", "persona.referencias"})
    Optional<GuarantorProfile> findByIdAndClientUserId(Long id, Long clientUserId);

    @EntityGraph(attributePaths = {"persona", "persona.direccion", "persona.actividadEconomica", "persona.ingresoEgreso", "persona.referencias"})
    Optional<GuarantorProfile> findFirstByClientUserIdAndCedula(Long clientUserId, String cedula);
}
