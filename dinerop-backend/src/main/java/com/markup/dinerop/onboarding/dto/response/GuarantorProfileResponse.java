package com.markup.dinerop.onboarding.dto.response;

import java.time.LocalDateTime;

public record GuarantorProfileResponse(Long id, PersonaOnboardingResponse persona, LocalDateTime actualizadoEn) {}
