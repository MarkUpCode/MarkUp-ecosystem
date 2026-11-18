package com.markup.dinerop.auth.service;

import com.markup.dinerop.auth.dto.ForgotPasswordRequest;
import com.markup.dinerop.auth.dto.PasswordResetOtpVerificationRequest;
import com.markup.dinerop.auth.dto.ResetPasswordRequest;
import com.markup.dinerop.auth.entity.PasswordResetToken;
import com.markup.dinerop.auth.entity.Role;
import com.markup.dinerop.auth.entity.User;
import com.markup.dinerop.auth.exception.OtpInvalidException;
import com.markup.dinerop.auth.repository.ActivationTokenRepository;
import com.markup.dinerop.auth.repository.EmailVerificationOtpRepository;
import com.markup.dinerop.auth.repository.PasswordResetTokenRepository;
import com.markup.dinerop.auth.repository.UserPreRegistrationRepository;
import com.markup.dinerop.auth.repository.UserRepository;
import com.markup.dinerop.cooperative.domain.repository.CooperativeRepository;
import com.markup.dinerop.notification.service.NotificationService;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.crypto.password.PasswordEncoder;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class AuthServicePasswordResetOtpTest {
    @Mock private UserRepository userRepository;
    @Mock private ActivationTokenRepository activationTokenRepository;
    @Mock private PasswordEncoder passwordEncoder;
    @Mock private AuthenticationManager authenticationManager;
    @Mock private JwtService jwtService;
    @Mock private PasswordResetTokenRepository passwordResetTokenRepository;
    @Mock private NotificationService notificationService;
    @Mock private UserPreRegistrationRepository userPreRegistrationRepository;
    @Mock private CooperativeRepository cooperativeRepository;
    @Mock private EmailVerificationOtpRepository emailVerificationOtpRepository;

    @InjectMocks private AuthService authService;

    @Test
    void forgotPasswordSendsHashedOtpAndKeepsResponseIndependentOfAccountExistence() {
        User user = activeUser();
        when(userRepository.findByEmail("client@example.com")).thenReturn(Optional.of(user));
        when(passwordResetTokenRepository.findTopByUser_IdUserOrderByCreatedAtDesc(7L))
                .thenReturn(Optional.empty());
        when(passwordResetTokenRepository.findAllByUser_IdUserAndUsedFalse(7L)).thenReturn(List.of());
        when(passwordEncoder.encode(anyString())).thenAnswer(call -> "bcrypt:" + call.getArgument(0));
        when(passwordResetTokenRepository.save(any(PasswordResetToken.class)))
                .thenAnswer(call -> call.getArgument(0));

        authService.forgotPassword(ForgotPasswordRequest.builder().email("Client@Example.com").build());

        ArgumentCaptor<String> code = ArgumentCaptor.forClass(String.class);
        verify(notificationService).sendResetPasswordOtpEmail(eq("client@example.com"), code.capture());
        assertTrue(code.getValue().matches("\\d{6}"));
        ArgumentCaptor<PasswordResetToken> challenge = ArgumentCaptor.forClass(PasswordResetToken.class);
        verify(passwordResetTokenRepository).save(challenge.capture());
        assertEquals("bcrypt:" + code.getValue(), challenge.getValue().getToken());
        assertFalse(challenge.getValue().isVerified());
        assertEquals(0, challenge.getValue().getAttempts());

        when(userRepository.findByEmail("missing@example.com")).thenReturn(Optional.empty());
        assertDoesNotThrow(() -> authService.forgotPassword(
                ForgotPasswordRequest.builder().email("missing@example.com").build()));
        verify(notificationService, times(1)).sendResetPasswordOtpEmail(anyString(), anyString());
    }

    @Test
    void invalidCodeIncrementsAttemptCounter() {
        User user = activeUser();
        PasswordResetToken challenge = challenge(user, "bcrypt:123456");
        when(userRepository.findByEmail("client@example.com")).thenReturn(Optional.of(user));
        when(passwordResetTokenRepository.findTopByUser_IdUserAndUsedFalseOrderByCreatedAtDesc(7L))
                .thenReturn(Optional.of(challenge));
        when(passwordEncoder.matches("000000", challenge.getToken())).thenReturn(false);

        assertThrows(OtpInvalidException.class, () -> authService.verifyPasswordResetOtp(
                PasswordResetOtpVerificationRequest.builder()
                        .email("client@example.com").code("000000").build()));

        assertEquals(1, challenge.getAttempts());
        verify(passwordResetTokenRepository).save(challenge);
    }

    @Test
    void validOtpCanResetPasswordOnceAndConsumesResetGrant() throws Exception {
        User user = activeUser();
        PasswordResetToken challenge = challenge(user, "bcrypt:123456");
        when(userRepository.findByEmail("client@example.com")).thenReturn(Optional.of(user));
        when(passwordResetTokenRepository.findTopByUser_IdUserAndUsedFalseOrderByCreatedAtDesc(7L))
                .thenReturn(Optional.of(challenge));
        when(passwordEncoder.matches("123456", challenge.getToken())).thenReturn(true);
        when(passwordEncoder.encode("NewPassword123")).thenReturn("encoded-new-password");
        when(passwordResetTokenRepository.findAllByUser_IdUserAndUsedFalse(7L))
                .thenReturn(List.of(challenge));
        when(passwordResetTokenRepository.saveAll(any())).thenAnswer(call -> call.getArgument(0));

        var verified = authService.verifyPasswordResetOtp(PasswordResetOtpVerificationRequest.builder()
                .email("client@example.com").code("123456").build());
        when(passwordResetTokenRepository.findByToken(hash(verified.getResetToken())))
                .thenReturn(Optional.of(challenge));
        assertTrue(challenge.isVerified());
        assertNotEquals("bcrypt:123456", challenge.getToken());
        assertThrows(OtpInvalidException.class, () -> authService.verifyPasswordResetOtp(
                PasswordResetOtpVerificationRequest.builder()
                        .email("client@example.com").code("123456").build()));

        authService.resetPassword(ResetPasswordRequest.builder()
                .token(verified.getResetToken()).newPassword("NewPassword123").build());

        assertEquals("encoded-new-password", user.getPassword());
        assertTrue(challenge.isUsed());
        verify(userRepository).save(user);
        verify(passwordResetTokenRepository, atLeast(2)).save(challenge);
        verify(passwordResetTokenRepository).saveAll(List.of(challenge));
    }

    private static User activeUser() {
        return User.builder().idUser(7L).email("client@example.com")
                .role(Role.CLIENT).status("ACTIVE").active(true).build();
    }

    private static PasswordResetToken challenge(User user, String token) {
        return PasswordResetToken.builder().id(3L).user(user).token(token)
                .expiresAt(LocalDateTime.now().plusMinutes(10)).createdAt(LocalDateTime.now())
                .used(false).verified(false).attempts(0).build();
    }

    private static String hash(String value) throws Exception {
        byte[] bytes = MessageDigest.getInstance("SHA-256").digest(value.getBytes(StandardCharsets.UTF_8));
        StringBuilder result = new StringBuilder();
        for (byte valueByte : bytes) result.append(String.format("%02x", valueByte));
        return result.toString();
    }
}
