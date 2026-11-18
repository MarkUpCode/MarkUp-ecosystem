package com.markup.dinerop.auth.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class PasswordResetOtpVerificationResponse {
    private String resetToken;
}
