package com.markup.dinerop.notification.service;

import com.markup.dinerop.notification.dto.SendEmailDto;
import com.resend.Resend;
import com.resend.core.exception.ResendException;
import com.resend.services.emails.model.CreateEmailOptions;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

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
    public void sendActivationEmail(String to, String activationToken) {

        String activationLink =
                frontendUrl + "/activate?token=" + activationToken;

        // Desarrollo
        if (!emailEnabled) {
            log.warn("");
            log.warn("====================================================");
            log.warn("MODO DESARROLLO - Link de activación: {}", activationLink);
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
                    <h2 style="color: #333333;">Activa tu cuenta en Dinerop</h2>
                    <p style="color: #555555;">Gracias por registrarte. Haz clic en el siguiente botón para activar tu cuenta:</p>

                    <a href="%s"
                       style="display:inline-block;
                              margin-top:20px;
                              padding:12px 24px;
                              background:#4F46E5;
                              color:white;
                              text-decoration:none;
                              border-radius:6px;
                              font-weight:bold;">
                        Activar cuenta
                    </a>

                    <p style="margin-top:30px;font-size:12px;color:#999;">
                        Este enlace expira en 24 horas.
                    </p>
                  </div>
                </body>
                </html>
                """.formatted(activationLink);

        sendEmail(
                SendEmailDto.builder()
                        .to(to)
                        .subject("Activa tu cuenta en Dinerop")
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

            log.info("");
            log.info("====================================================");
            log.info("      MODO DESARROLLO - RESET PASSWORD");
            log.info("====================================================");
            log.info("Usuario : {}", to);
            log.info("");
            log.info("LINK RESET:");
            log.info(resetLink);
            log.info("");
            log.info("TOKEN:");
            log.info(resetToken);
            log.info("====================================================");
            log.info("");

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