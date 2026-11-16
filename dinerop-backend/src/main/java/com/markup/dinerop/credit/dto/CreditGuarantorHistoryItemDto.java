package com.markup.dinerop.credit.dto;

import com.markup.dinerop.onboarding.dto.response.PersonaOnboardingResponse;
import java.time.LocalDateTime;
import java.util.List;

public record CreditGuarantorHistoryItemDto(Long id, Long perfilId, Long solicitudId, Long cooperativaId,
        Integer intento, String estado, LocalDateTime enviadoEn, PersonaOnboardingResponse fotografia,
        List<CreditGuarantorEvaluationDto> evaluaciones) {}
