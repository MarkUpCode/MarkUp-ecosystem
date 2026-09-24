package com.markup.dinerop.notification.dto;

import jakarta.validation.constraints.NotBlank;

public record RegisterPushTokenRequest(@NotBlank String token) {
}
