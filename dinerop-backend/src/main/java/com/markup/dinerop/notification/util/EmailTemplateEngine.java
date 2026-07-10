package com.markup.dinerop.notification.util;

import lombok.RequiredArgsConstructor;
import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.nio.charset.StandardCharsets;

@Component
@RequiredArgsConstructor
public class EmailTemplateEngine {

    public String loadTemplate(String template) {

        try {

            ClassPathResource resource =
                    new ClassPathResource(
                            "templates/email/" + template
                    );

            byte[] bytes =
                    resource.getInputStream().readAllBytes();

            return new String(
                    bytes,
                    StandardCharsets.UTF_8
            );

        } catch (IOException e) {

            throw new RuntimeException(
                    "No se pudo cargar la plantilla: "
                            + template
            );

        }

    }

}