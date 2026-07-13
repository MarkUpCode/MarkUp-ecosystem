package com.markup.dinerop.notification.service;

import com.markup.dinerop.notification.dto.SendEmailDto;
import com.resend.Resend;
import com.resend.core.exception.ResendException;
import com.resend.services.emails.model.CreateEmailOptions;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import com.markup.dinerop.notification.template.ActivationEmailBuilder;
import com.markup.dinerop.notification.template.EmailTemplate;
import com.markup.dinerop.notification.util.EmailTemplateEngine;

@Slf4j
@Service
@RequiredArgsConstructor
public class NotificationService {

    private final Resend resend;

    @Value("${resend.from-email}")
    private String fromEmail;

    @Value("${app.frontend-url}")
    private String frontendUrl;

    @Value("${app.email-enabled:true}")
    private boolean emailEnabled;

    private final ActivationEmailBuilder activationEmailBuilder;

    private final EmailTemplateEngine emailTemplateEngine;

    // =========================================================
    // GENERIC EMAIL
    // =========================================================
    public void sendEmail(SendEmailDto dto) {

        // En desarrollo no enviamos correos reales
        if (!emailEnabled) {

            log.info("");
            log.info("===============================================");
            log.info("   MODO DESARROLLO - EMAIL NO ENVIADO");
            log.info("===============================================");
            log.info("Para    : {}", dto.getTo());
            log.info("Asunto  : {}", dto.getSubject());
            log.info("===============================================");

            return;
        }

        try {

            CreateEmailOptions options = CreateEmailOptions.builder()
                    .from(fromEmail)
                    .to(dto.getTo())
                    .subject(dto.getSubject())
                    .html(dto.getHtmlContent())
                    .build();

            resend.emails().send(options);

            log.info("Email enviado a {}", dto.getTo());

        } catch (ResendException e) {

            // No detenemos la aplicación por un fallo del proveedor de correo
            log.error("No se pudo enviar el correo.");
            log.error("Destino : {}", dto.getTo());
            log.error("Motivo  : {}", e.getMessage());

        }
    }

    // =========================================================
    // ACTIVATION EMAIL
    // =========================================================
    public void sendActivationEmail(
            String to,
            String activationToken
    ) {

        String activationLink =
                frontendUrl + "/activate?token=" + activationToken;

        // =====================================================
        // MODO DESARROLLO
        // No enviamos correo real, mostramos el link en consola
        // =====================================================
        if (!emailEnabled) {

            log.warn("");
            log.warn("========================================================");
            log.warn("        MODO DESARROLLO - ACTIVACIÓN DE CUENTA");
            log.warn("========================================================");
            log.warn("Usuario : {}", to);
            log.warn("");
            log.warn("LINK DE ACTIVACIÓN:");
            log.warn("{}", activationLink);
            log.warn("");
            log.warn("TOKEN:");
            log.warn("{}", activationToken);
            log.warn("========================================================");
            log.warn("");

            return;
        }

        // =====================================================
        // MODO PRODUCCIÓN
        // Construimos y enviamos el correo real
        // =====================================================

        EmailTemplate template =
                activationEmailBuilder.build(activationLink);

        String html =
                emailTemplateEngine.render(template);

        sendEmail(
                SendEmailDto.builder()
                        .to(to)
                        .subject("Activa tu cuenta en Dinerop")
                        .htmlContent(html)
                        .build()
        );
    }
    
    public void sendTestEmail(String to) {

        String html = """
            <!DOCTYPE html>
            <html lang="es">
            <head>
                <meta charset="UTF-8">
            </head>
            <body style="
                font-family: Arial, sans-serif;
                background:#f4f7fb;
                padding:40px;
            ">

            <div style="
                max-width:600px;
                margin:auto;
                background:white;
                border-radius:12px;
                padding:40px;
                box-shadow:0 8px 20px rgba(0,0,0,.08);
            ">

                <h2 style="margin-top:0;color:#111827;">
                    Noe te quiero mucho ❤️🐄
                </h2>

                <p>
                    Si estás leyendo este correo significa que te quiero mucho
                </p>

                <hr style="margin:30px 0">


                <p style="
                    margin-top:35px;
                    color:#6b7280;
                    font-size:13px;
                ">
                    Att el amor de tu vida 🐄
                </p>

            </div>

            </body>
            </html>
            """;

        sendEmail(
                SendEmailDto.builder()
                        .to(to)
                        .subject("Para Noe con amor ❤️🐄")
                        .htmlContent(html)
                        .build()
        );
    }

    // =========================================================
    // RESET PASSWORD EMAIL
    // =========================================================
    public void sendResetPasswordEmail(String to, String resetToken) {

        String resetLink =
                frontendUrl + "/reset-password?token=" + resetToken;

        // Desarrollo
        if (!emailEnabled) {

            log.warn("");
            log.warn("====================================================");
            log.warn("      MODO DESARROLLO - RESET PASSWORD");
            log.warn("====================================================");
            log.warn("Usuario : {}", to);
            log.warn("");
            log.warn("LINK RESET:");
            log.warn(resetLink);
            log.warn("");
            log.warn("TOKEN:");
            log.warn(resetToken);
            log.warn("====================================================");
            log.warn("");

            return;
        }

        String html = """
                <!DOCTYPE html>
                <html lang="es">
                <head><meta charset="UTF-8"></head>
                <body style="font-family: Arial, sans-serif; background-color: #f4f4f4; padding: 40px;">
                  <div style="max-width: 600px; margin: auto; background: #ffffff; border-radius: 8px; padding: 40px;">
                    <h2 style="color: #333333;">Restablecer contraseña</h2>

                    <p style="color:#555;">
                        Recibimos una solicitud para restablecer tu contraseña.
                    </p>

                    <a href="%s"
                       style="display:inline-block;
                              margin-top:20px;
                              padding:12px 24px;
                              background:#DC2626;
                              color:white;
                              text-decoration:none;
                              border-radius:6px;
                              font-weight:bold;">
                        Restablecer contraseña
                    </a>

                    <p style="margin-top:30px;font-size:12px;color:#999;">
                        Este enlace expira en 15 minutos.
                    </p>
                  </div>
                </body>
                </html>
                """.formatted(resetLink);

        sendEmail(
                SendEmailDto.builder()
                        .to(to)
                        .subject("Restablece tu contraseña en Dinerop")
                        .htmlContent(html)
                        .build()
        );
    }

}