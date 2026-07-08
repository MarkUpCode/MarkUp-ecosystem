package com.markup.dinerop.admin.cooperative.exception;

public class CooperativeNotFoundException extends RuntimeException {

    public CooperativeNotFoundException(Long id) {

        super("No existe una cooperativa con el id " + id);

    }

}