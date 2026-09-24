package com.markup.dinerop.notification.service;

import com.google.firebase.FirebaseApp;
import com.google.firebase.messaging.FirebaseMessaging;
import com.google.firebase.messaging.Message;
import com.google.firebase.messaging.Notification;
import com.markup.dinerop.auth.entity.User;
import com.markup.dinerop.auth.repository.UserRepository;
import com.markup.dinerop.notification.entity.PushDeviceToken;
import com.markup.dinerop.notification.repository.PushDeviceTokenRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;

@Slf4j
@Service
@RequiredArgsConstructor
public class PushNotificationService {

    private final PushDeviceTokenRepository tokenRepository;
    private final UserRepository userRepository;

    @Transactional
    public void registerToken(Long userId, String rawToken) {
        String token = rawToken == null ? "" : rawToken.trim();
        if (token.isEmpty()) {
            throw new IllegalArgumentException("El token del dispositivo es obligatorio");
        }

        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("Usuario no encontrado"));

        PushDeviceToken deviceToken = tokenRepository.findByToken(token)
                .orElseGet(PushDeviceToken::new);
        deviceToken.setUser(user);
        deviceToken.setToken(token);
        deviceToken.setEnabled(true);
        deviceToken.setUpdatedAt(LocalDateTime.now());
        tokenRepository.save(deviceToken);
    }

    @Transactional
    public void disableToken(String rawToken) {
        tokenRepository.findByToken(rawToken.trim()).ifPresent(token -> {
            token.setEnabled(false);
            token.setUpdatedAt(LocalDateTime.now());
            tokenRepository.save(token);
        });
    }

    @Transactional
    public void sendCreditAccepted(Long userId, String title, String body, Long solicitudId) {
        if (FirebaseApp.getApps().isEmpty()) {
            log.warn("Push notification skipped: Firebase is not configured");
            return;
        }

        for (PushDeviceToken deviceToken : tokenRepository.findByUserIdUserAndEnabledTrue(userId)) {
            try {
                Message message = Message.builder()
                        .setToken(deviceToken.getToken())
                        .setNotification(Notification.builder().setTitle(title).setBody(body).build())
                        .putData("type", "CREDIT_ACCEPTED")
                        .putData("solicitudId", String.valueOf(solicitudId))
                        .build();
                FirebaseMessaging.getInstance().send(message);
            } catch (Exception exception) {
                log.error("Could not send push notification to user {}", userId, exception);
                if (exception.getMessage() != null && exception.getMessage().contains("registration-token-not-registered")) {
                    disableToken(deviceToken.getToken());
                }
            }
        }
    }
}
