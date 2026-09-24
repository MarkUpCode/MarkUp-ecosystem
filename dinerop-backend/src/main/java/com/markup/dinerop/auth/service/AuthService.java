package com.markup.dinerop.auth.service;

import com.markup.dinerop.admin.users.exception.CooperativeRequiredException;
import com.markup.dinerop.auth.dto.*;

import com.markup.dinerop.auth.entity.ActivationToken;
import com.markup.dinerop.auth.entity.EmailVerificationOtp;
import com.markup.dinerop.auth.entity.Role;
import com.markup.dinerop.auth.entity.User;
import com.markup.dinerop.auth.exception.AccountNotActiveException;
import com.markup.dinerop.auth.exception.AccountDisabledException;
import com.markup.dinerop.auth.exception.OtpAttemptsExceededException;
import com.markup.dinerop.auth.exception.OtpExpiredException;
import com.markup.dinerop.auth.exception.OtpInvalidException;
import com.markup.dinerop.auth.exception.OtpRateLimitException;
import com.markup.dinerop.auth.repository.ActivationTokenRepository;
import com.markup.dinerop.auth.repository.EmailVerificationOtpRepository;
import com.markup.dinerop.auth.repository.UserRepository;
import com.markup.dinerop.auth.entity.UserPreRegistration;
import com.markup.dinerop.auth.repository.UserPreRegistrationRepository;
import com.markup.dinerop.notification.service.NotificationService;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import jakarta.transaction.Transactional;


import com.markup.dinerop.auth.entity.PasswordResetToken;
import com.markup.dinerop.auth.repository.PasswordResetTokenRepository;
import com.markup.dinerop.auth.dto.ForgotPasswordRequest;
import com.markup.dinerop.auth.dto.ResetPasswordRequest;
import com.markup.dinerop.auth.dto.InviteUserRequest;
import com.markup.dinerop.cooperative.domain.repository.CooperativeRepository;

import com.markup.dinerop.auth.exception.UserAlreadyActiveException;
import com.markup.dinerop.auth.exception.CooperativeNotFoundException;

import org.springframework.security.authentication.BadCredentialsException;

import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.Optional;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class AuthService {

    private static final Logger log = LoggerFactory.getLogger(AuthService.class);

    private final UserRepository userRepository;
    private final ActivationTokenRepository activationTokenRepository;
    private final PasswordEncoder passwordEncoder;
    private final AuthenticationManager authenticationManager;
    private final JwtService jwtService;
    private final PasswordResetTokenRepository passwordResetTokenRepository;
    private final NotificationService notificationService;
    private final UserPreRegistrationRepository userPreRegistrationRepository;
    private final CooperativeRepository cooperativeRepository;
    private final EmailVerificationOtpRepository emailVerificationOtpRepository;

    private static final int OTP_LENGTH = 6;
    private static final int OTP_TTL_SECONDS = 600;
    private static final int OTP_MAX_ATTEMPTS = 5;
    private static final int OTP_RESEND_SECONDS = 45;


    // =========================================================
    // PRE-REGISTRO (SIN contraseÃ±a, SIN JWT)
    // =========================================================
    @Transactional
    public String preRegister(String email, Role role, Long cooperativaId) {

        String normalizedEmail = email.toLowerCase().trim();

        Optional<User> existingOpt = userRepository.findByEmail(normalizedEmail);

        // =============================
        // USUARIO YA EXISTE
        // =============================
        if (existingOpt.isPresent()) {
            User existing = existingOpt.get();

            if ("ACTIVE".equals(existing.getStatus())) {
                throw new UserAlreadyActiveException(existing.getEmail());
            }

                        if ("DISABLED".equals(existing.getStatus())) {
                                throw new AccountDisabledException();
                        }

            Optional<ActivationToken> tokenOpt =
                    activationTokenRepository.findByUser_IdUserAndUsedFalse(existing.getIdUser());

            if (tokenOpt.isPresent()) {
                                tokenOpt.get().markAsUsed();
                                activationTokenRepository.save(tokenOpt.get());
            }
        }

                User savedUser = existingOpt.orElseGet(() -> {
                        User user = User.builder()
                                        .email(normalizedEmail)
                                        .role(role)
                                        .cooperativaId(cooperativaId)
                                        .status("PENDING_ACTIVATION")
                                        .active(false)
                                        .build();

                        log.info("Pre-register request for {}", normalizedEmail);
                        return userRepository.save(user);
                });

        // =============================
        // GENERAR NUEVO TOKEN
        // =============================
        String tokenValue = UUID.randomUUID().toString();

        ActivationToken newToken = ActivationToken.builder()
                .token(tokenValue)
                .user(savedUser)
                .expiresAt(Instant.now().plus(24, ChronoUnit.HOURS))
                .used(false)
                .build();


        activationTokenRepository.save(newToken);

        // =============================
        // Enviar correo
        // =============================


        notificationService.sendActivationEmail(savedUser.getEmail(), tokenValue);

        log.info("New activation token generated for {}", savedUser.getEmail());


        return tokenValue;
    }

    @Transactional
    public User preRegisterClient(PublicRegistrationRequest request) {

        String normalizedEmail = request.getEmail()
                .toLowerCase()
                .trim();

        log.info(
                "[PRE_REGISTER_CLIENT] Inicio | email={}",
                normalizedEmail
        );

        // 1. Crear usuario pendiente + OTP + enviar código
        startRegistrationOtp(request);

        // 2. Recuperar usuario creado o existente
        User user = userRepository
                .findByEmail(normalizedEmail)
                .orElseThrow(() ->
                        new RuntimeException("USER_NOT_FOUND")
                );

        // 3. Buscar preregistro existente o crear uno nuevo
        UserPreRegistration preReg = userPreRegistrationRepository
                .findByUserId(user.getIdUser())
                .orElseGet(() ->
                        UserPreRegistration.builder()
                                .userId(user.getIdUser())
                                .build()
                );

        // 4. Guardar los datos personales
        preReg.setFirstName(request.getFirstName());
        preReg.setLastName(request.getLastName());
        preReg.setIdentification(request.getIdentification());
        preReg.setPhone(request.getPhone());
        preReg.setProvince(request.getProvince());
        preReg.setCity(request.getCity());

        userPreRegistrationRepository.save(preReg);

        log.info(
                "[PRE_REGISTER_CLIENT] Datos guardados | userId={} email={}",
                user.getIdUser(),
                normalizedEmail
        );

        return user;
    }

    @Transactional
    public User inviteUser(InviteUserRequest request) {

        Role role = request.role();

        if (role == Role.COOPERATIVE) {

            if (request.cooperativaId() == null) {
                throw new CooperativeRequiredException();
            }

            cooperativeRepository
                    .findById(request.cooperativaId())
                    .orElseThrow(() ->
                        new CooperativeNotFoundException(request.cooperativaId()));

        }

        preRegister(
                request.email(),
                role,
                request.cooperativaId()
        );

        return userRepository
                .findByEmail(request.email().toLowerCase().trim())
                .orElseThrow(() -> new RuntimeException("USER_NOT_FOUND"));
    }



    // =========================================================
    // REGISTRO PÚBLICO SIN CRÉDITO
    // =========================================================
    @Transactional
    public PublicRegistrationResponse publicRegister(
            PublicRegistrationRequest request
    ) {
        return startRegistrationOtp(request).toLegacyResponse();
    }

    @Transactional
    public OtpRegistrationStartResponse startRegistrationOtp(PublicRegistrationRequest request) {
        String normalizedEmail = normalizeEmail(request.getEmail());

        Optional<User> existingUser = userRepository.findByEmail(normalizedEmail);
        User user = existingUser.orElseGet(() -> createPendingUser(normalizedEmail, Role.CLIENT));

        if (existingUser.isPresent() && "ACTIVE".equals(user.getStatus()) && user.getPassword() != null) {
            throw new UserAlreadyActiveException(normalizedEmail);
        }

        if (user.getCooperativaId() == null && request.getFirstName() != null) {
            upsertPreRegistration(user, request);
        }

        EmailVerificationOtp latest = emailVerificationOtpRepository
                .findTopByEmailAndUsedFalseAndRevokedFalseOrderByCreatedAtDesc(normalizedEmail)
                .orElse(null);

        if (latest != null && latest.getCreatedAt().plusSeconds(OTP_RESEND_SECONDS).isAfter(Instant.now())) {
            throw new OtpRateLimitException("Puedes solicitar un nuevo código en 45 s.");
        }

        emailVerificationOtpRepository.findTopByEmailOrderByCreatedAtDesc(normalizedEmail)
                .ifPresent(oldOtp -> {
                    oldOtp.setUsed(true);
                    oldOtp.setRevoked(true);
                    emailVerificationOtpRepository.save(oldOtp);
                });

        String rawCode = generateCode();
        EmailVerificationOtp otp = EmailVerificationOtp.builder()
                .email(normalizedEmail)
                .otpHash(hashOtp(rawCode))
                .expiresAt(Instant.now().plusSeconds(OTP_TTL_SECONDS))
                .attempts(0)
                .used(false)
                .revoked(false)
                .build();

        emailVerificationOtpRepository.save(otp);
        notificationService.sendRegistrationOtpEmail(normalizedEmail, rawCode);

        return OtpRegistrationStartResponse.builder()
                .email(normalizedEmail)
                .message("Verificación enviada. Revisa tu correo.")
                .requiresVerification(true)
                .build();
    }

    @Transactional
    public void verifyRegistrationOtp(String email, String rawCode) {
        String normalizedEmail = normalizeEmail(email);
        String normalizedCode = rawCode == null ? "" : rawCode.trim();

        EmailVerificationOtp otp = emailVerificationOtpRepository
                .findTopByEmailAndUsedFalseAndRevokedFalseOrderByCreatedAtDesc(normalizedEmail)
                .orElseThrow(() -> new OtpInvalidException("El código no es correcto. Verifica e inténtalo nuevamente."));

        if (otp.isExpired()) {
            otp.setRevoked(true);
            emailVerificationOtpRepository.save(otp);
            throw new OtpExpiredException("Este código ha expirado. Solicita uno nuevo.");
        }

        if (otp.getAttempts() >= OTP_MAX_ATTEMPTS) {
            otp.setRevoked(true);
            emailVerificationOtpRepository.save(otp);
            throw new OtpAttemptsExceededException("Has superado el número de intentos permitidos. Solicita un nuevo código.");
        }

        if (!hashOtp(normalizedCode).equals(otp.getOtpHash())) {
            otp.setAttempts(otp.getAttempts() + 1);
            emailVerificationOtpRepository.save(otp);
            int remaining = Math.max(0, OTP_MAX_ATTEMPTS - otp.getAttempts());
            if (remaining == 0) {
                otp.setRevoked(true);
                emailVerificationOtpRepository.save(otp);
                throw new OtpAttemptsExceededException("Has superado el número de intentos permitidos. Solicita un nuevo código.");
            }
            throw new OtpInvalidException("El código no es correcto. Verifica e inténtalo nuevamente.");
        }

        otp.setUsed(true);
        emailVerificationOtpRepository.save(otp);

        userRepository.findByEmail(normalizedEmail)
                .ifPresent(user -> {
                    user.setStatus("ACTIVE");
                    user.setActive(true);
                    userRepository.save(user);
                });
    }

    @Transactional
    public OtpRegistrationStartResponse resendRegistrationOtp(String email) {
        String normalizedEmail = normalizeEmail(email);
        Optional<User> existingUser = userRepository.findByEmail(normalizedEmail);
        if (existingUser.isEmpty()) {
            User user = createPendingUser(normalizedEmail, Role.CLIENT);
            existingUser = Optional.of(user);
        }

        if (existingUser.get().getPassword() != null && "ACTIVE".equals(existingUser.get().getStatus())) {
            throw new UserAlreadyActiveException(normalizedEmail);
        }

        EmailVerificationOtp activeOtp = emailVerificationOtpRepository
                .findTopByEmailAndUsedFalseAndRevokedFalseOrderByCreatedAtDesc(normalizedEmail)
                .orElse(null);

        if (activeOtp != null && activeOtp.getCreatedAt().plusSeconds(OTP_RESEND_SECONDS).isAfter(Instant.now())) {
            throw new OtpRateLimitException("Puedes solicitar un nuevo código en 45 s.");
        }

        return startRegistrationOtp(PublicRegistrationRequest.builder().email(normalizedEmail).build());
    }

    @Transactional
    public OtpRegistrationStartResponse changeRegistrationEmail(PublicRegistrationRequest request) {
        return startRegistrationOtp(request);
    }

    @Transactional
    public OtpRegistrationStartResponse changeRegistrationEmail(
            String currentEmail,
            String newEmail
    ) {
        String normalizedCurrentEmail = normalizeEmail(currentEmail);
        String normalizedNewEmail = normalizeEmail(newEmail);

        if (normalizedCurrentEmail.equals(normalizedNewEmail)) {
            throw new IllegalArgumentException("El nuevo correo debe ser diferente al actual.");
        }

        if (userRepository.existsByEmail(normalizedNewEmail)) {
            throw new UserAlreadyActiveException(normalizedNewEmail);
        }

        User user = userRepository.findByEmail(normalizedCurrentEmail)
                .orElseThrow(() -> new OtpInvalidException("No existe un registro pendiente para ese correo."));

        if (user.getPassword() != null || "ACTIVE".equals(user.getStatus())) {
            throw new UserAlreadyActiveException(normalizedCurrentEmail);
        }

        emailVerificationOtpRepository.findTopByEmailOrderByCreatedAtDesc(normalizedCurrentEmail)
                .ifPresent(oldOtp -> {
                    oldOtp.setUsed(true);
                    oldOtp.setRevoked(true);
                    emailVerificationOtpRepository.save(oldOtp);
                });

        user.setEmail(normalizedNewEmail);
        userRepository.save(user);

        return startRegistrationOtp(PublicRegistrationRequest.builder()
                .email(normalizedNewEmail)
                .build());
    }

    private User createPendingUser(String email, Role role) {
        User user = User.builder()
                .email(email)
                .role(role)
                .status("PENDING_ACTIVATION")
                .active(false)
                .cooperativaId(null)
                .build();
        return userRepository.save(user);
    }

    private void upsertPreRegistration(User user, PublicRegistrationRequest request) {
        UserPreRegistration preReg = userPreRegistrationRepository.findByUserId(user.getIdUser())
                .orElseGet(() -> UserPreRegistration.builder().userId(user.getIdUser()).build());

        preReg.setFirstName(request.getFirstName());
        preReg.setLastName(request.getLastName());
        preReg.setIdentification(request.getIdentification());
        preReg.setPhone(request.getPhone());
        preReg.setProvince(request.getProvince());
        preReg.setCity(request.getCity());
        userPreRegistrationRepository.save(preReg);
    }

    private String normalizeEmail(String email) {
        return email == null ? "" : email.trim().toLowerCase();
    }

    private String generateCode() {
        return String.format("%06d", new java.security.SecureRandom().nextInt(1_000_000));
    }

    private String hashOtp(String rawCode) {
        try {
            java.security.MessageDigest digest = java.security.MessageDigest.getInstance("SHA-256");
            byte[] hash = digest.digest(rawCode.getBytes(java.nio.charset.StandardCharsets.UTF_8));
            StringBuilder builder = new StringBuilder();
            for (byte b : hash) {
                builder.append(String.format("%02x", b));
            }
            return builder.toString();
        } catch (java.security.NoSuchAlgorithmException e) {
            throw new IllegalStateException("SHA-256 not available", e);
        }
    }

    @Transactional
    public String adminRegister(String email) {
        return preRegister(email, Role.ADMIN, null);
    }

    // =========================================================
    // OBTENER EMAIL POR CLIENT ID
    // =========================================================
    public String getEmailByClientId(Long clientId) {
        return userRepository.findById(clientId)
                .orElseThrow(() -> new RuntimeException("USER_NOT_FOUND"))
                .getEmail();
    }

    // =========================================================
    // LOGIN
    // =========================================================
    public LoginResponse login(LoginRequest request) {


        User user = userRepository.findByEmail(request.getEmail())
                .orElseThrow(() ->
                        new BadCredentialsException("Correo o contraseña incorrectos.")
                );


        if (!user.isEnabled()) {
            throw new AccountNotActiveException("Cuenta no activada. Revisa tu correo.");
        }

        Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(
                        request.getEmail(),
                        request.getPassword()
                )
        );

        User authenticatedUser = (User) authentication.getPrincipal();

        String accessToken = jwtService.generateToken(authenticatedUser);

        LoginResponse.UserInfo userInfo = new LoginResponse.UserInfo(
                authenticatedUser.getIdUser(),
                authenticatedUser.getEmail(),
                authenticatedUser.getRole().name(),
                authenticatedUser.getStatus()
        );

        return new LoginResponse(accessToken, userInfo);
    }


    // =========================================================
    // Activar Cuenta
    // =========================================================

    @Transactional
    public void activateAccount(String tokenValue) {

        ActivationToken token = activationTokenRepository
                .findByTokenAndUsedFalse(tokenValue)
                .orElseThrow(() -> new RuntimeException("INVALID_OR_USED_TOKEN"));

        if (token.getExpiresAt().isBefore(Instant.now())) {
            throw new RuntimeException("TOKEN_EXPIRED");
        }

        User user = token.getUser();
        user.setStatus("ACTIVE");
        user.setActive(true);

        token.markAsUsed();

        userRepository.save(user);
        activationTokenRepository.save(token);

        log.info("Cuenta activada correctamente: {}", user.getEmail());
    }


    // =========================================================
    // Completar registro
    // =========================================================

    @Transactional
    public void completeRegistration(String email, String rawPassword) {

        User user = userRepository.findByEmail(email.toLowerCase().trim())
                .orElseThrow(() -> new RuntimeException("USER_NOT_FOUND"));

        if (!"ACTIVE".equals(user.getStatus())) {
            throw new RuntimeException("USER_NOT_ACTIVE");
        }

        if (user.getPassword() != null) {
            throw new RuntimeException("PASSWORD_ALREADY_SET");
        }

        user.setPassword(passwordEncoder.encode(rawPassword));
        user.setActive(true);

        userRepository.save(user);


    }



    // =========================================================
    // FORGOT PASSWORD
    // =========================================================
    @Transactional
    public void forgotPassword(ForgotPasswordRequest request) {

        String email = request.getEmail().toLowerCase().trim();

        Optional<User> userOpt = userRepository.findByEmail(email);

        // 1. Siempre responder OK (seguridad)
        if (userOpt.isEmpty()) {
            log.warn("Password reset requested for non-existing email: {}", email);
            return;
        }

        User user = userOpt.get();

        // 2. Solo permitir reset a usuarios ACTIVE
        if (!"ACTIVE".equals(user.getStatus())) {
            log.warn("Password reset requested for non-active user: {}", email);
            return;
        }

        // 3. Invalidar tokens anteriores
        passwordResetTokenRepository
                .findAllByUser_IdUserAndUsedFalse(user.getIdUser())
                .forEach(token -> {
                    token.setUsed(true);
                    passwordResetTokenRepository.save(token);
                });

        // 4. Generar nuevo token
        String tokenValue = UUID.randomUUID().toString();

        var expiresAt = Instant.now()
                .plus(15, ChronoUnit.MINUTES)
                .atZone(java.time.ZoneId.systemDefault())
                .toLocalDateTime();

        PasswordResetToken resetToken = PasswordResetToken.builder()
                .token(tokenValue)
                .user(user)
                .expiresAt(expiresAt)
                .used(false)
                .build();

        passwordResetTokenRepository.save(resetToken);

        //envio de correo
        notificationService.sendResetPasswordEmail(user.getEmail(), tokenValue);


        log.info("Password reset token generated for {}", email);
    }


    // =========================================================
    // RESET PASSWORD
    // =========================================================

    @Transactional
    public void resetPassword(ResetPasswordRequest request) {

        PasswordResetToken token = passwordResetTokenRepository
                .findByToken(request.getToken())
                .orElseThrow(() -> new RuntimeException("INVALID_OR_USED_TOKEN"));

        if (token.isUsed()) {
            throw new RuntimeException("TOKEN_ALREADY_USED");
        }

        if (token.getExpiresAt().isBefore(
                Instant.now()
                        .atZone(java.time.ZoneId.systemDefault())
                        .toLocalDateTime()
        )) {
            throw new RuntimeException("TOKEN_EXPIRED");
        }

        User user = token.getUser();

        user.setPassword(passwordEncoder.encode(request.getNewPassword()));
        user.setActive(true);

        token.setUsed(true);

        userRepository.save(user);
        passwordResetTokenRepository.save(token);

        log.info("Password successfully reset for {}", user.getEmail());
    }


}
