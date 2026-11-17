package com.markup.dinerop.cooperative.domain.repository;

import com.markup.dinerop.cooperative.domain.entity.FinancialProductCondition;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface FinancialProductConditionRepository extends JpaRepository<FinancialProductCondition, Long> {
    List<FinancialProductCondition> findByProductIdOrderByValidFromDescIdDesc(Long productId);
}
