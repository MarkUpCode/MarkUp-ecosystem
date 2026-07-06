package com.markup.dinerop.admin.users.exception;

public class CooperativeRequiredException extends RuntimeException {

    public CooperativeRequiredException() {
        super("Debe especificar una cooperativa para un usuario COOPERATIVE.");
    }

}