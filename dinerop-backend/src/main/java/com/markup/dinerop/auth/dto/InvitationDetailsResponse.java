package com.markup.dinerop.auth.dto;

import java.time.Instant;

public record InvitationDetailsResponse(String firstName, String lastName, String email, String role,
        String cooperativeName, Instant expiresAt) {}
