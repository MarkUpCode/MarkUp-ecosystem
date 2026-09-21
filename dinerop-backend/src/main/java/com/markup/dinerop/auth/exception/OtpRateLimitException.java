package com.markup.dinerop.auth.exception;

public class OtpRateLimitException extends RuntimeException {
    public OtpRateLimitException(String message) {
        super(message);
    }
}
