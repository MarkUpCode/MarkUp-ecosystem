package com.markup.dinerop.notification.util;

import com.markup.dinerop.notification.template.EmailTemplate;
import lombok.RequiredArgsConstructor;
import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.nio.charset.StandardCharsets;

@Component
@RequiredArgsConstructor
public class EmailTemplateEngine {

    public String render(EmailTemplate template) {

        String html = loadTemplate("base.html");

        return html

                .replace(
                        "{{LOGO_URL}}",
                        "https://dinerop.com/logo.png"
                )

                .replace(
                        "{{TITLE}}",
                        template.getTitle()
                )

                .replace(
                        "{{MESSAGE}}",
                        template.getMessage()
                )

                .replace(
                        "{{BUTTON_TEXT}}",
                        template.getButtonText()
                )

                .replace(
                        "{{BUTTON_URL}}",
                        template.getButtonUrl()
                )

                .replace(
                        "{{INFO_1}}",
                        template.getInfo1()
                )

                .replace(
                        "{{INFO_2}}",
                        template.getInfo2()
                )

                .replace(
                        "{{INFO_3}}",
                        template.getInfo3());

    }

    private String loadTemplate(String template) {

        try {

            ClassPathResource resource =
                    new ClassPathResource(
                            "templates/email/" + template
                    );

            byte[] bytes =
                    resource.getInputStream()
                            .readAllBytes();

            return new String(
                    bytes,
                    StandardCharsets.UTF_8
            );

        } catch (IOException e) {

            throw new RuntimeException(e);

        }

    }

}