package com.markup.dinerop.onboarding.dto.response;

import com.markup.dinerop.onboarding.domain.enums.TipoReferencia;

public record ReferenciaPersonalResponse(
        String nombreCompleto,
        TipoReferencia tipo,
        String parentesco,
        String telefono
) {}
