package com.markup.dinerop.credit.dto;

import com.markup.dinerop.credit.domain.model.enums.CreditRejectionReason;

import java.util.List;

public record GuaranteeDecisionRequestDto(
        String decision,
        List<CreditRejectionReason> motivosRechazo,
        String motivoRechazoOtro
) {}
