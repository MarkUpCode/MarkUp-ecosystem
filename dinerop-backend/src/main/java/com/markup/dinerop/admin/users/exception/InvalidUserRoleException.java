package com.markup.dinerop.admin.users.exception;

public class InvalidUserRoleException extends RuntimeException {

    public InvalidUserRoleException() {
        super("El CRM no permite crear usuarios CLIENT.");
    }

}