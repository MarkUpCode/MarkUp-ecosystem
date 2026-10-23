package com.markup.dinerop.auth.controller;

import com.markup.dinerop.auth.dto.PreRegisterRequest;
import com.markup.dinerop.auth.dto.PreRegisterResponse;
import com.markup.dinerop.auth.service.AuthService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/internal/auth")
@RequiredArgsConstructor
@PreAuthorize("hasRole('ADMIN')")
public class InternalAuthController {

    private final AuthService authService;

    @PostMapping("/pre-register")
    public ResponseEntity<PreRegisterResponse> preRegister(
            @Valid @RequestBody PreRegisterRequest request
    ) {
        String token = authService.preRegister(
                request.getEmail(),
                request.getRole(),
                null
        );

        return ResponseEntity.ok(new PreRegisterResponse(token));
    }
}
