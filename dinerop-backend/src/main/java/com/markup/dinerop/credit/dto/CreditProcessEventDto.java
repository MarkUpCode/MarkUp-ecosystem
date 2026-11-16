package com.markup.dinerop.credit.dto;

import java.time.LocalDateTime;

public record CreditProcessEventDto(
        String tipo,
        String detalle,
        LocalDateTime fecha,
        Long actorId,
        String actorRole
) {}
