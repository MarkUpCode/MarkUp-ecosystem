package com.markup.dinerop.onboarding.dto.response;

import com.markup.dinerop.onboarding.domain.enums.TipoVivienda;

public record DireccionOnboardingResponse(
        String provincia,
        String canton,
        String barrio,
        String callePrincipal,
        String numero,
        String referenciaUbicacion,
        TipoVivienda tipoVivienda
) {}
