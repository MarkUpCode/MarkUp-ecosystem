package com.markup.dinerop.cooperative.domain.service;

import com.markup.dinerop.cooperative.domain.entity.Cooperative;
import com.markup.dinerop.cooperative.domain.entity.FinancialProduct;
import com.markup.dinerop.cooperative.domain.entity.FinancialProductCondition;
import com.markup.dinerop.cooperative.domain.entity.FinancialProductType;
import com.markup.dinerop.cooperative.domain.entity.InvestmentCalculationMethod;
import com.markup.dinerop.cooperative.domain.repository.CooperativeRepository;
import com.markup.dinerop.cooperative.domain.repository.FinancialProductConditionRepository;
import com.markup.dinerop.cooperative.domain.repository.FinancialProductRepository;
import com.markup.dinerop.cooperative.domain.repository.InvestmentAcceptanceRepository;
import com.markup.dinerop.cooperative.domain.repository.InvestmentRequestRepository;
import com.markup.dinerop.cooperative.domain.repository.InvestmentRequestStatusEventRepository;
import com.markup.dinerop.auth.repository.UserRepository;
import com.markup.dinerop.notification.service.PushNotificationService;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class InvestmentServiceCalculationTest {
    @Mock FinancialProductRepository products;
    @Mock FinancialProductConditionRepository conditions;
    @Mock CooperativeRepository cooperatives;
    @Mock InvestmentRequestRepository requests;
    @Mock InvestmentRequestStatusEventRepository events;
    @Mock InvestmentAcceptanceRepository acceptances;
    @Mock PushNotificationService notifications;
    @Mock UserRepository users;
    @Mock InvestmentCalculationSettingsService settings;
    @InjectMocks InvestmentService service;

    @Test
    void centralInterestMethodIsAppliedToOffersAndUsesAnnualNominalRate() {
        var product = product(InvestmentCalculationMethod.UNSPECIFIED);
        var condition = condition();
        var cooperative = new Cooperative(); cooperative.setId(7L); cooperative.setNombre("Cooperativa de prueba");
        when(settings.currentMethod()).thenReturn(InvestmentCalculationMethod.SIMPLE_INTEREST);
        when(products.findAll()).thenReturn(List.of(product));
        when(conditions.findByProductIdOrderByValidFromDescIdDesc(11L)).thenReturn(List.of(condition));
        when(cooperatives.findById(7L)).thenReturn(Optional.of(cooperative));

        var offer = service.compareOffers(new BigDecimal("1000"), 12, null).get(0);

        assertEquals(InvestmentCalculationMethod.SIMPLE_INTEREST, offer.calculationMethod());
        assertEquals(new BigDecimal("120.00"), offer.estimatedInterest());
        assertEquals(new BigDecimal("1120.00"), offer.estimatedTotal());
        assertEquals("Depósito a plazo fijo", offer.productName());
    }

    private FinancialProduct product(InvestmentCalculationMethod legacyMethod) {
        var product = new FinancialProduct();
        product.setId(11L); product.setCooperativeId(7L); product.setType(FinancialProductType.INVESTMENT);
        product.setName("Nombre comercial antiguo"); product.setDescription("Texto comercial antiguo");
        product.setMinimumAmount(new BigDecimal("100")); product.setMaximumAmount(new BigDecimal("5000"));
        product.setActive(true); product.setCalculationMethod(legacyMethod);
        return product;
    }

    private FinancialProductCondition condition() {
        var condition = new FinancialProductCondition();
        condition.setId(21L); condition.setProductId(11L);
        condition.setMinimumAmount(new BigDecimal("100")); condition.setMaximumAmount(new BigDecimal("5000"));
        condition.setMinimumTermMonths(12); condition.setMaximumTermMonths(12);
        condition.setAnnualRate(new BigDecimal("12")); condition.setValidFrom(Instant.now().minusSeconds(3600));
        return condition;
    }
}
