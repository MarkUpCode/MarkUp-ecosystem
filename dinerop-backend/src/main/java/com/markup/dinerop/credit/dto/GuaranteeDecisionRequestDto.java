package com.markup.dinerop.credit.dto;

import com.markup.dinerop.credit.domain.model.enums.CreditRejectionReason;

import java.util.List;
import jakarta.validation.constraints.Size;

public record GuaranteeDecisionRequestDto(
        String decision,
        List<CreditRejectionReason> motivosRechazo,
        String motivoRechazoOtro,
        @Size(max = 1000) String observacion
) {}
