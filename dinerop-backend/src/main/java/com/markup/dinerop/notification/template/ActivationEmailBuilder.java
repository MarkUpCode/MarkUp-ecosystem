package com.markup.dinerop.notification.template;

import org.springframework.stereotype.Component;

@Component
public class ActivationEmailBuilder {

    public EmailTemplate build(String activationLink) {

        return EmailTemplate.builder()

                .title("Activa tu cuenta")

                .message("""
                        Bienvenido a Dinerop.
                        
                        Tu cuenta ha sido creada correctamente.
                        
                        Solo falta un último paso para comenzar a utilizar la plataforma.
                        Presiona el siguiente botón para activar tu cuenta.
                        """)

                .buttonText("Activar cuenta")

                .buttonUrl(activationLink)

                .info1("Este enlace expira en 24 horas.")

                .info2("Solo puede utilizarse una vez.")

                .info3("Si no solicitaste este correo puedes ignorarlo.")

                .build();

    }

}