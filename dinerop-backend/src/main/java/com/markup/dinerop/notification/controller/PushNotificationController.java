package com.markup.dinerop.notification.controller;

import com.markup.dinerop.auth.entity.User;
import com.markup.dinerop.notification.dto.RegisterPushTokenRequest;
import com.markup.dinerop.notification.service.PushNotificationService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/notifications")
@RequiredArgsConstructor
public class PushNotificationController {

    private final PushNotificationService pushNotificationService;

    @PostMapping("/devices/token")
    public ResponseEntity<Void> registerToken(
            @AuthenticationPrincipal User user,
            @Valid @RequestBody RegisterPushTokenRequest request
    ) {
        pushNotificationService.registerToken(user.getIdUser(), request.token());
        return ResponseEntity.noContent().build();
    }

    @DeleteMapping("/devices/token")
    public ResponseEntity<Void> disableToken(
            @AuthenticationPrincipal User user,
            @RequestParam String token
    ) {
        pushNotificationService.disableToken(token);
        return ResponseEntity.noContent().build();
    }
}
