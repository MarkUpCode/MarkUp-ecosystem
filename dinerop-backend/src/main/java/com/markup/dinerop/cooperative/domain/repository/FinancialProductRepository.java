package com.markup.dinerop.cooperative.domain.repository;

import com.markup.dinerop.cooperative.domain.entity.FinancialProduct;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface FinancialProductRepository extends JpaRepository<FinancialProduct, Long> {
    List<FinancialProduct> findByCooperativeIdOrderById(Long cooperativeId);
}
