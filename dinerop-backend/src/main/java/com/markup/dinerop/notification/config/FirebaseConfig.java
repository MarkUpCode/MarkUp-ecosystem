package com.markup.dinerop.notification.config;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import jakarta.annotation.PostConstruct;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.util.Base64;

@Slf4j
@Configuration
public class FirebaseConfig {

        @Value("${firebase.service-account-base64:}")
        private String serviceAccountBase64;

        @PostConstruct
        public void initialize() throws IOException {
        if (serviceAccountBase64 == null || serviceAccountBase64.isBlank()) {
            log.warn("Firebase push notifications disabled: FIREBASE_SERVICE_ACCOUNT_BASE64 is not configured");
            return;
        }

        if (!FirebaseApp.getApps().isEmpty()) {
            return;
        }

        byte[] credentials = Base64.getDecoder().decode(serviceAccountBase64);
        FirebaseOptions options = FirebaseOptions.builder()
                .setCredentials(GoogleCredentials.fromStream(new ByteArrayInputStream(credentials)))
                .build();

        log.info("Firebase Admin initialized for push notifications");
        FirebaseApp.initializeApp(options);
    }
}
