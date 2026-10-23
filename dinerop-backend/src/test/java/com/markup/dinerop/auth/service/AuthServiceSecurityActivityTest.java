package com.markup.dinerop.auth.service;

import com.markup.dinerop.auth.dto.LoginRequest;
import com.markup.dinerop.auth.entity.Role;
import com.markup.dinerop.auth.entity.User;
import com.markup.dinerop.auth.repository.*;
import com.markup.dinerop.cooperative.domain.repository.CooperativeRepository;
import com.markup.dinerop.notification.service.NotificationService;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.crypto.password.PasswordEncoder;

import java.util.Optional;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class AuthServiceSecurityActivityTest {

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

    @InjectMocks
    private AuthService authService;

    @Test
    void validCredentialsGenerateAccessToken() {
        User user = activeClient();
        Authentication authentication = new UsernamePasswordAuthenticationToken(user, null, user.getAuthorities());
        when(userRepository.findByEmail(user.getEmail())).thenReturn(Optional.of(user));
        when(authenticationManager.authenticate(any(UsernamePasswordAuthenticationToken.class)))
                .thenReturn(authentication);
        when(jwtService.generateToken(user)).thenReturn("synthetic.jwt.token");

        var response = authService.login(loginRequest(user.getEmail(), "correct-password"));

        assertEquals("synthetic.jwt.token", response.getAccessToken());
        verify(jwtService).generateToken(user);
    }

    @Test
    void invalidCredentialsAreRejected() {
        User user = activeClient();
        when(userRepository.findByEmail(user.getEmail())).thenReturn(Optional.of(user));
        when(authenticationManager.authenticate(any(UsernamePasswordAuthenticationToken.class)))
                .thenThrow(new BadCredentialsException("invalid"));

        assertThrows(BadCredentialsException.class,
                () -> authService.login(loginRequest(user.getEmail(), "wrong-password")));
        verify(jwtService, never()).generateToken(any());
    }

    private User activeClient() {
        return User.builder()
                .idUser(10L)
                .email("client@example.com")
                .role(Role.CLIENT)
                .status("ACTIVE")
                .active(true)
                .build();
    }

    private LoginRequest loginRequest(String email, String password) {
        LoginRequest request = new LoginRequest();
        request.setEmail(email);
        request.setPassword(password);
        return request;
    }
}
