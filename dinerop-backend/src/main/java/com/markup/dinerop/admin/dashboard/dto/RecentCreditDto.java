package com.markup.dinerop.admin.dashboard.dto;

import com.markup.dinerop.credit.domain.model.enums.CreditRequestStatus;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public record RecentCreditDto(
        Long id,
        String email,
        BigDecimal amount,
        CreditRequestStatus status,
        LocalDateTime fechaSolicitud
) {
}