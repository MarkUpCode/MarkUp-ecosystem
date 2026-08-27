package com.markup.dinerop.auth.exception;

public class AccountDisabledException extends RuntimeException {

    public AccountDisabledException() {
        super("Esta cuenta está deshabilitada. Contacta con soporte.");
    }
}