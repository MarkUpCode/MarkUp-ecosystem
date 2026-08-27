package com.markup.dinerop.auth.exception;

public class UserAlreadyActiveException extends RuntimeException {

    public UserAlreadyActiveException(String email) {
        super("Este correo ya tiene una cuenta registrada. Inicia sesión para continuar.");
    }

}