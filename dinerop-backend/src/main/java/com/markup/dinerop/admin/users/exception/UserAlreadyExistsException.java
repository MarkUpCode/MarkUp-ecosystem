package com.markup.dinerop.admin.users.exception;

public class UserAlreadyExistsException extends RuntimeException {

    public UserAlreadyExistsException(String email) {
        super("Ya existe un usuario con el correo: " + email);
    }

}