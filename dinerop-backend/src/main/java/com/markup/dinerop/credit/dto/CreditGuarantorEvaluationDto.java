package com.markup.dinerop.credit.dto;

import java.time.LocalDateTime;
import java.util.List;

public record CreditGuarantorEvaluationDto(Long id, String decision, List<String> motivosRechazo,
        String motivoRechazoOtro, String observacion, Long actorId, String actorRole, LocalDateTime fecha) {}
