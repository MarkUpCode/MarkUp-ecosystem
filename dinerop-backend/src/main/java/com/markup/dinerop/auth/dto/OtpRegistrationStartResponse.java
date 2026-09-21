package com.markup.dinerop.auth.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class OtpRegistrationStartResponse {
    private String email;
    private String message;
    private boolean requiresVerification;

    public PublicRegistrationResponse toLegacyResponse() {
        return PublicRegistrationResponse.builder()
                .email(this.email)
                .message(this.message)
                .build();
    }
}
