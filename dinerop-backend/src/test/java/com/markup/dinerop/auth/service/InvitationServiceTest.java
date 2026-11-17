package com.markup.dinerop.auth.service;

import com.markup.dinerop.admin.users.dto.request.CreateUserRequest;
import com.markup.dinerop.auth.entity.CooperativeInvitation;
import com.markup.dinerop.auth.entity.Role;
import com.markup.dinerop.auth.entity.User;
import com.markup.dinerop.auth.dto.InvitationActivationRequest;
import com.markup.dinerop.auth.repository.CooperativeInvitationRepository;
import com.markup.dinerop.auth.repository.UserRepository;
import com.markup.dinerop.cooperative.domain.repository.CooperativeRepository;
import com.markup.dinerop.notification.service.NotificationService;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.security.crypto.password.PasswordEncoder;
import java.util.List;
import java.util.Optional;
import java.time.Instant;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.util.HexFormat;
import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class InvitationServiceTest {
    @Mock UserRepository users;
    @Mock CooperativeRepository cooperatives;
    @Mock CooperativeInvitationRepository invitations;
    @Mock PasswordEncoder passwordEncoder;
    @Mock NotificationService notifications;
    @InjectMocks InvitationService service;

    @Test
    void storesOnlyTokenHashAndSendsOneTimeLink() {
        when(users.findByEmailForUpdate("admin@example.com")).thenReturn(Optional.empty());
        when(users.save(any(User.class))).thenAnswer(call -> {
            User user = call.getArgument(0); user.setIdUser(42L); return user;
        });
        when(invitations.findByUser_IdUserAndUsedFalseAndRevokedFalse(42L)).thenReturn(List.of());
        when(invitations.save(any(CooperativeInvitation.class))).thenAnswer(call -> call.getArgument(0));
        var request = new CreateUserRequest("admin@example.com", "Ana", "Pérez", null, Role.ADMIN, null);

        User invited = service.invite(request);

        assertEquals("PENDING_ACTIVATION", invited.getStatus());
        assertFalse(Boolean.TRUE.equals(invited.getActive()));
        ArgumentCaptor<CooperativeInvitation> token = ArgumentCaptor.forClass(CooperativeInvitation.class);
        verify(invitations).save(token.capture());
        assertEquals(64, token.getValue().getTokenHash().length());
        assertNotNull(token.getValue().getExpiresAt());
        verify(notifications).sendInvitationEmail(eq("admin@example.com"), eq("Ana"), argThat(raw -> raw.length() >= 40));
    }

    @Test
    void accountBecomesActiveOnlyWhenTheInviteIsSubmitted() throws Exception {
        String rawToken = "a-cryptographically-random-invitation-token";
        String hash = HexFormat.of().formatHex(MessageDigest.getInstance("SHA-256").digest(rawToken.getBytes(StandardCharsets.UTF_8)));
        User user = User.builder().idUser(42L).email("cooperative@example.com").role(Role.COOPERATIVE)
                .cooperativaId(9L).status("PENDING_ACTIVATION").active(false).build();
        CooperativeInvitation invitation = new CooperativeInvitation(); invitation.setUser(user);
        invitation.setTokenHash(hash); invitation.setExpiresAt(Instant.now().plusSeconds(3600));
        when(invitations.lockValidByHash(hash)).thenReturn(Optional.of(invitation));
        when(cooperatives.existsById(9L)).thenReturn(true);
        when(passwordEncoder.encode("a-long-secure-password")).thenReturn("encoded-password");

        service.activate(new InvitationActivationRequest(rawToken, "a-long-secure-password"));

        assertTrue(Boolean.TRUE.equals(user.getActive()));
        assertEquals("ACTIVE", user.getStatus());
        assertEquals("encoded-password", user.getPassword());
        assertTrue(invitation.isUsed());
        verify(users).save(user);
        verify(invitations).save(invitation);
    }
}
