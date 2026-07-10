package com.markup.dinerop.notification.controller;

import com.markup.dinerop.notification.dto.TestEmailRequest;
import com.markup.dinerop.notification.service.NotificationService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/test")
@RequiredArgsConstructor
public class TestEmailController {

    private final NotificationService notificationService;

    @PostMapping("/email")
    public ResponseEntity<String> sendTestEmail(
            @Valid @RequestBody TestEmailRequest request
    ) {

        notificationService.sendTestEmail(request.getTo());

        return ResponseEntity.ok("Correo enviado correctamente.");

    }

}