package com.markup.dinerop.auth.dto;

import jakarta.validation.constraints.*;

public record InvitationActivationRequest(
        @NotBlank String token,
        @NotBlank @Size(min = 10, max = 128) String password
) {}
