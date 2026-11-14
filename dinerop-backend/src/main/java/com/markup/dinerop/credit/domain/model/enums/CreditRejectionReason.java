package com.markup.dinerop.credit.domain.model.enums;

public enum CreditRejectionReason {
    CAPACIDAD_DE_PAGO("El crédito sobrepasa su capacidad de pago"),
    TIEMPO_DE_NEGOCIO("Tiempo de negocio mínimo no alcanzado"),
    BURO_DEL_CREDITO("Buro del crédito"),
    OTROS("Otros motivos");

    private final String label;

    CreditRejectionReason(String label) {
        this.label = label;
    }

    public String getLabel() {
        return label;
    }
}
