package com.markup.dinerop.auth.controller;

import com.markup.dinerop.auth.dto.*;
import com.markup.dinerop.auth.service.InvitationService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/invitations")
@RequiredArgsConstructor
public class InvitationController {
    private final InvitationService service;

    @GetMapping("/details")
    public InvitationDetailsResponse details(@RequestParam String token) { return service.details(token); }

    @PostMapping("/activate")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void activate(@Valid @RequestBody InvitationActivationRequest request) { service.activate(request); }
}
