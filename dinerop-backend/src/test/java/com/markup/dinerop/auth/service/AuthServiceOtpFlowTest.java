package com.markup.dinerop.auth.service;

import com.markup.dinerop.auth.dto.PublicRegistrationRequest;
import com.markup.dinerop.auth.entity.Role;
import com.markup.dinerop.auth.entity.User;
import com.markup.dinerop.auth.repository.ActivationTokenRepository;
import com.markup.dinerop.auth.repository.EmailVerificationOtpRepository;
import com.markup.dinerop.auth.repository.PasswordResetTokenRepository;
import com.markup.dinerop.auth.repository.UserPreRegistrationRepository;
import com.markup.dinerop.auth.repository.UserRepository;
import com.markup.dinerop.cooperative.domain.repository.CooperativeRepository;
import com.markup.dinerop.notification.service.NotificationService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.crypto.password.PasswordEncoder;

import java.util.Optional;

import static org.junit.jupiter.api.Assertions.assertDoesNotThrow;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class AuthServiceOtpFlowTest {

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

    @BeforeEach
    void setUp() {
        when(userRepository.save(any(User.class))).thenAnswer(invocation -> invocation.getArgument(0));
    }

    @Test
    void publicRegisterGeneratesOtpAndKeepsUserPending() {
        final String email = "cliente@dinerop.com";
        when(userRepository.findByEmail(anyString())).thenReturn(Optional.empty());

        PublicRegistrationRequest request = PublicRegistrationRequest.builder()
                .email(email)
                .firstName("Ana")
                .lastName("Lopez")
                .identification("1712345678")
                .phone("0999999999")
                .province("Pichincha")
                .city("Quito")
                .build();

        var response = assertDoesNotThrow(() -> authService.publicRegister(request));

        assertEquals(email.toLowerCase(), response.getEmail());
        assertEquals("Verificación enviada. Revisa tu correo.", response.getMessage());
    }

    @Test
    void pendingUserCanBeActivatedWithPassword() {
        User user = User.builder()
                .idUser(7L)
                .email("cliente@dinerop.com")
                .role(Role.CLIENT)
                .status("ACTIVE")
                .active(true)
                .build();

        when(userRepository.findByEmail("cliente@dinerop.com")).thenReturn(Optional.of(user));
        when(passwordEncoder.encode("Password123!")).thenReturn("hashed-password");

        assertDoesNotThrow(() -> authService.completeRegistration("cliente@dinerop.com", "Password123!"));
        assertEquals("ACTIVE", user.getStatus());
    }
}
