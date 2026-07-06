package com.markup.dinerop.auth.exception;

public class UserAlreadyActiveException extends RuntimeException {

    public UserAlreadyActiveException(String email) {
        super("El usuario " + email + " ya tiene una cuenta activa.");
    }

}