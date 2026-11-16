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
                .info2("Puedes reutilizar un perfil anterior, pero debes confirmar el envío para esta solicitud de crédito.")
                .info3("La cooperativa continuará el análisis cuando reciba la información.")
                .build();
    }

    public EmailTemplate buildNewGuaranteeRequired(
            String cooperativeName,
            String dashboardUrl,
            java.util.List<String> reasons
    ) {
        String reasonList = reasons.stream()
                .map(this::escapeHtml)
                .collect(java.util.stream.Collectors.joining("; "));
        return EmailTemplate.builder()
                .title("La cooperativa solicita otro garante")
                .message("""
                        %s revisó la información enviada y necesita que registres un nuevo garante para continuar con tu solicitud.
                        """.formatted(cooperativeName))
                .buttonText("Registrar nuevo garante")
                .buttonUrl(dashboardUrl)
                .info1("Motivos: " + reasonList)
                .info2("Ingresa a tu solicitud y completa nuevamente la información.")
                .info3("Podrás hacerlo hasta que la cooperativa apruebe un garante.")
                .build();
    }

    public EmailTemplate buildGuaranteeReviewUpdate(
            String cooperativeName,
            String dashboardUrl,
            java.util.List<String> reasons,
            boolean correctionRequested,
            String observation
    ) {
        String reasonList = reasons.stream().map(this::escapeHtml)
                .collect(java.util.stream.Collectors.joining("; "));
        return EmailTemplate.builder()
                .title(correctionRequested ? "Corrige la información del garante" : "Actualización del garante")
                .message(correctionRequested
                        ? cooperativeName + " revisó los datos del garante y solicita corregirlos."
                        : cooperativeName + " no aprobó al garante. Puedes registrar otro si el proceso sigue disponible.")
                .buttonText(correctionRequested ? "Actualizar información" : "Registrar otro garante")
                .buttonUrl(dashboardUrl)
                .info1(reasonList.isBlank() ? "Revisa la observación de la cooperativa." : "Motivos: " + reasonList)
                .info2(observation == null || observation.isBlank() ? "" : "Observación: " + escapeHtml(observation))
                .info3("Abre la solicitud en DINEROP para continuar.")
                .build();
    }

    private String escapeHtml(String value) {
        return value.replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }

    private String money(BigDecimal amount) {
        return NumberFormat.getCurrencyInstance(ECUADOR).format(amount);
    }

    private String percentage(BigDecimal rate) {
        return rate.stripTrailingZeros().toPlainString() + "%";
    }
}
