package com.markup.dinerop.cooperative.domain.service;

import com.markup.dinerop.cooperative.domain.entity.FinancialProduct;
import com.markup.dinerop.cooperative.domain.entity.Cooperative;
import com.markup.dinerop.cooperative.domain.entity.FinancialProductCondition;
import com.markup.dinerop.cooperative.domain.repository.FinancialProductConditionRepository;
import com.markup.dinerop.cooperative.domain.repository.FinancialProductRepository;
import com.markup.dinerop.cooperative.domain.repository.CooperativeRepository;
import com.markup.dinerop.cooperative.dto.FinancialProductConditionRequest;
import com.markup.dinerop.cooperative.dto.FinancialProductRequest;
import com.markup.dinerop.cooperative.domain.entity.FinancialProductType;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import java.math.BigDecimal;
import java.time.Instant;
import java.util.List;
import java.util.Optional;
import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class FinancialProductServiceTest {
    @Mock FinancialProductRepository products;
    @Mock FinancialProductConditionRepository conditions;
    @Mock CooperativeRepository cooperatives;
    @InjectMocks FinancialProductService service;

    @BeforeEach
    void lockCooperative() {
        Cooperative cooperative = new Cooperative(); cooperative.setId(7L);
        when(cooperatives.lockById(7L)).thenReturn(Optional.of(cooperative));
    }

    @Test
    void rejectsOverlappingRangesWithinProduct() {
        when(products.save(any(FinancialProduct.class))).thenAnswer(call -> {
            FinancialProduct p = call.getArgument(0); p.setId(11L); return p;
        });
        when(products.findByCooperativeIdOrderById(7L)).thenAnswer(call -> List.of());
        var condition = condition("100", "1000", 12, 24, "9.5", Instant.parse("2026-01-01T00:00:00Z"), null);
        var request = new FinancialProductRequest(FinancialProductType.CREDIT, "Crédito A", null,
                new BigDecimal("100"), new BigDecimal("1000"), true, List.of(condition, condition));

        assertThrows(IllegalArgumentException.class, () -> service.create(7L, request));
        verify(conditions, never()).save(any());
    }

    @Test
    void keepsNonOverlappingValidityPeriodsAsSeparateHistory() {
        when(products.save(any(FinancialProduct.class))).thenAnswer(call -> {
            FinancialProduct p = call.getArgument(0); p.setId(11L); return p;
        });
        when(products.findByCooperativeIdOrderById(7L)).thenReturn(List.of());
        when(conditions.findByProductIdOrderByValidFromDescIdDesc(11L)).thenReturn(List.of());
        when(conditions.save(any(FinancialProductCondition.class))).thenAnswer(call -> call.getArgument(0));
        var early = condition("100", "1000", 12, 24, "9.5", Instant.parse("2026-01-01T00:00:00Z"), Instant.parse("2026-07-01T00:00:00Z"));
        var later = condition("100", "1000", 12, 24, "10.0", Instant.parse("2026-07-01T00:00:00Z"), null);
        var request = new FinancialProductRequest(FinancialProductType.CREDIT, "Crédito A", null,
                new BigDecimal("100"), new BigDecimal("1000"), true, List.of(early, later));

        assertDoesNotThrow(() -> service.create(7L, request));
        verify(conditions, times(2)).save(any(FinancialProductCondition.class));
    }

    @Test
    void closesPreviousRangeWhenAReplacementRateStarts() {
        FinancialProduct product = new FinancialProduct(); product.setId(11L); product.setCooperativeId(7L);
        product.setType(FinancialProductType.CREDIT); product.setMinimumAmount(new BigDecimal("100"));
        product.setMaximumAmount(new BigDecimal("1000"));
        FinancialProductCondition previous = new FinancialProductCondition();
        previous.setId(5L); previous.setProductId(11L); previous.setMinimumAmount(new BigDecimal("100"));
        previous.setMaximumAmount(new BigDecimal("1000")); previous.setMinimumTermMonths(12); previous.setMaximumTermMonths(24);
        previous.setValidFrom(Instant.parse("2026-01-01T00:00:00Z")); previous.setAnnualRate(new BigDecimal("9.5"));
        when(products.findById(11L)).thenReturn(Optional.of(product));
        when(products.findByCooperativeIdOrderById(7L)).thenReturn(List.of(product));
        when(conditions.findByProductIdOrderByValidFromDescIdDesc(11L)).thenReturn(List.of(previous));
        when(conditions.save(any(FinancialProductCondition.class))).thenAnswer(call -> call.getArgument(0));

        Instant replacementDate = Instant.parse("2026-07-01T00:00:00Z");
        service.addCondition(7L, 11L, condition("100", "1000", 12, 24, "10.0", replacementDate, null));

        assertEquals(replacementDate, previous.getValidUntil());
        verify(conditions, times(2)).save(any(FinancialProductCondition.class));
    }

    private FinancialProductConditionRequest condition(String min, String max, int termMin, int termMax,
            String rate, Instant from, Instant until) {
        return new FinancialProductConditionRequest(new BigDecimal(min), new BigDecimal(max), termMin,
                termMax, new BigDecimal(rate), from, until);
    }
}
