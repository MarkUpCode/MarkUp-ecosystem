package com.markup.dinerop.auth.service;

import com.markup.dinerop.admin.users.dto.request.CreateUserRequest;
import com.markup.dinerop.auth.dto.InvitationDetailsResponse;
import com.markup.dinerop.auth.dto.InvitationActivationRequest;
import com.markup.dinerop.auth.entity.*;
import com.markup.dinerop.auth.repository.*;
import com.markup.dinerop.cooperative.domain.repository.CooperativeRepository;
import com.markup.dinerop.notification.service.NotificationService;
import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.nio.charset.StandardCharsets;
import java.security.*;
import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.*;

@Service
@RequiredArgsConstructor
public class InvitationService {
    private static final SecureRandom RANDOM = new SecureRandom();
    private final UserRepository users;
    private final CooperativeRepository cooperatives;
    private final CooperativeInvitationRepository invitations;
    private final PasswordEncoder passwordEncoder;
    private final NotificationService notifications;

    @Transactional
    public User invite(CreateUserRequest request) {
        String email = request.email().trim().toLowerCase(Locale.ROOT);
        if (request.role() == Role.COOPERATIVE) {
            if (request.cooperativaId() == null) throw new IllegalArgumentException("Selecciona una cooperativa.");
            cooperatives.findById(request.cooperativaId()).orElseThrow(() -> new EntityNotFoundException("Cooperativa no encontrada."));
        } else if (request.cooperativaId() != null) {
            throw new IllegalArgumentException("Solo los usuarios COOPERATIVE pueden asociarse a una cooperativa.");
        }
        User user = users.findByEmailForUpdate(email).orElseGet(() -> User.builder().email(email).active(false).status("PENDING_ACTIVATION").build());
        if ("ACTIVE".equals(user.getStatus())) throw new IllegalArgumentException("El correo ya pertenece a una cuenta activa.");
        if ("DISABLED".equals(user.getStatus())) throw new IllegalArgumentException("No se puede invitar una cuenta deshabilitada.");
        user.setRole(request.role()); user.setCooperativaId(request.cooperativaId());
        user.setFirstName(request.firstName().trim()); user.setLastName(request.lastName().trim()); user.setPhone(request.phone());
        user.setActive(false); user.setStatus("PENDING_ACTIVATION");
        user = users.save(user);
        revokePending(user.getIdUser());
        sendInvitation(user);
        return user;
    }

    @Transactional(readOnly = true)
    public InvitationDetailsResponse details(String rawToken) {
        CooperativeInvitation invitation = valid(rawToken);
        User user = invitation.getUser();
        String cooperativeName = user.getCooperativaId() == null ? null : cooperatives.findById(user.getCooperativaId()).map(c -> c.getNombre()).orElse(null);
        return new InvitationDetailsResponse(user.getFirstName(), user.getLastName(), user.getEmail(), user.getRole().name(), cooperativeName, invitation.getExpiresAt());
    }

    @Transactional
    public void activate(InvitationActivationRequest request) {
        CooperativeInvitation invitation = invitations.lockValidByHash(hash(request.token()))
                .orElseThrow(() -> new IllegalArgumentException("La invitación no es válida o ha expirado."));
        if (!invitation.getExpiresAt().isAfter(Instant.now())) throw new IllegalArgumentException("La invitación no es válida o ha expirado.");
        User user = invitation.getUser();
        if (!"PENDING_ACTIVATION".equals(user.getStatus()) || user.getPassword() != null)
            throw new IllegalArgumentException("La invitación no es válida o ha expirado.");
        if (user.getRole() == Role.COOPERATIVE && (user.getCooperativaId() == null || !cooperatives.existsById(user.getCooperativaId())))
            throw new IllegalArgumentException("La invitación no es válida o ha expirado.");
        user.setPassword(passwordEncoder.encode(request.password())); user.setActive(true); user.setStatus("ACTIVE");
        invitation.setUsed(true);
        users.save(user); invitations.save(invitation);
    }

    @Transactional
    public void resend(Long userId) {
        User user = users.findById(userId).orElseThrow(() -> new EntityNotFoundException("Usuario no encontrado."));
        if (!"PENDING_ACTIVATION".equals(user.getStatus()) || user.getPassword() != null) throw new IllegalArgumentException("La cuenta no tiene una invitación pendiente.");
        if (user.getRole() == Role.COOPERATIVE && (user.getCooperativaId() == null || !cooperatives.existsById(user.getCooperativaId())))
            throw new IllegalArgumentException("No se puede reenviar la invitación porque la cooperativa ya no existe.");
        revokePending(userId); sendInvitation(user);
    }

    @Transactional
    public void revoke(Long userId) {
        if (!users.existsById(userId)) throw new EntityNotFoundException("Usuario no encontrado.");
        revokePending(userId);
    }

    private void sendInvitation(User user) {
        byte[] bytes = new byte[32]; RANDOM.nextBytes(bytes);
        String rawToken = Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);
        CooperativeInvitation invitation = new CooperativeInvitation(); invitation.setUser(user);
        invitation.setTokenHash(hash(rawToken)); invitation.setExpiresAt(Instant.now().plus(48, ChronoUnit.HOURS));
        invitation.setUsed(false); invitation.setRevoked(false); invitations.save(invitation);
        notifications.sendInvitationEmail(user.getEmail(), user.getFirstName(), rawToken);
    }

    private void revokePending(Long userId) {
        invitations.findByUser_IdUserAndUsedFalseAndRevokedFalse(userId).forEach(i -> i.setRevoked(true));
    }

    private CooperativeInvitation valid(String rawToken) {
        CooperativeInvitation invitation = invitations.findByTokenHashAndUsedFalseAndRevokedFalse(hash(rawToken))
                .orElseThrow(() -> new IllegalArgumentException("La invitación no es válida o ha expirado."));
        if (!invitation.getExpiresAt().isAfter(Instant.now())) throw new IllegalArgumentException("La invitación no es válida o ha expirado.");
        return invitation;
    }

    private String hash(String value) {
        try { return HexFormat.of().formatHex(MessageDigest.getInstance("SHA-256").digest(value.getBytes(StandardCharsets.UTF_8))); }
        catch (NoSuchAlgorithmException e) { throw new IllegalStateException("SHA-256 no está disponible.", e); }
    }
}
