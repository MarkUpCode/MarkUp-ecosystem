package com.markup.dinerop.admin.users.exception;

public class UserNotFoundException extends RuntimeException {

    public UserNotFoundException(Long id) {
        super("No existe un usuario con id: " + id);
    }

}