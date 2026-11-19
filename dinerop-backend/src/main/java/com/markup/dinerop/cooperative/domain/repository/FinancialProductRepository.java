package com.markup.dinerop.cooperative.domain.repository;

import com.markup.dinerop.cooperative.domain.entity.FinancialProduct;
import com.markup.dinerop.cooperative.domain.entity.CreditProductCategory;
import com.markup.dinerop.cooperative.domain.entity.FinancialProductType;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface FinancialProductRepository extends JpaRepository<FinancialProduct, Long> {
    List<FinancialProduct> findByCooperativeIdOrderById(Long cooperativeId);

    List<FinancialProduct> findByTypeAndCreditCategoryAndActiveTrue(
            FinancialProductType type,
            CreditProductCategory creditCategory
    );
}
