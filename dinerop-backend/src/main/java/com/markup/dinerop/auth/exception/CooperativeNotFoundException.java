package com.markup.dinerop.auth.exception;

public class CooperativeNotFoundException extends RuntimeException {

    public CooperativeNotFoundException(Long id) {
        super("No existe una cooperativa con id " + id);
    }

}