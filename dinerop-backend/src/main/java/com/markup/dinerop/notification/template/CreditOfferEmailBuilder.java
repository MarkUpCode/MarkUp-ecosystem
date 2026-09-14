package com.markup.dinerop.notification.template;

import org.springframework.stereotype.Component;

import java.math.BigDecimal;
import java.text.NumberFormat;
import java.util.Locale;

@Component
public class CreditOfferEmailBuilder {

    private static final Locale ECUADOR = new Locale("es", "EC");

    public EmailTemplate buildPreApproved(
            String cooperativeName,
            BigDecimal amount,
            BigDecimal annualRate,
            Integer termMonths,
            BigDecimal monthlyPayment,
            String dashboardUrl
    ) {
        return EmailTemplate.builder()
                .title("Tienes una nueva oferta de crédito")
                .message("""
                        %s ha preaprobado tu solicitud. Revisa la propuesta y sus condiciones desde tu panel de Dinerop.
                        """.formatted(cooperativeName))
                .buttonText("Ver mi oferta")
                .buttonUrl(dashboardUrl)
                .info1("Monto solicitado: " + money(amount))
                .info2("Tasa anual: " + percentage(annualRate) + " · Plazo: " + termMonths + " meses")
                .info3("Cuota mensual estimada: " + money(monthlyPayment))
                .build();
    }

    public EmailTemplate buildGuaranteeRequired(String cooperativeName, String dashboardUrl) {
        return EmailTemplate.builder()
                .title("Una cooperativa solicita un garante")
                .message("""
                        %s necesita la información de un garante para continuar con la evaluación de tu solicitud de crédito.
                        """.formatted(cooperativeName))
                .buttonText("Completar información del garante")
                .buttonUrl(dashboardUrl)
                .info1("Ingresa a tu panel para revisar la solicitud.")
                .info2("Completa los datos del garante una sola vez.")
                .info3("La cooperativa continuará el análisis cuando reciba la información.")
                .build();
    }

    private String money(BigDecimal amount) {
        return NumberFormat.getCurrencyInstance(ECUADOR).format(amount);
    }

    private String percentage(BigDecimal rate) {
        return rate.stripTrailingZeros().toPlainString() + "%";
    }
}
