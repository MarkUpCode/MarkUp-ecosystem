package com.markup.dinerop.auth.config;

import com.markup.dinerop.auth.entity.Role;
import com.markup.dinerop.auth.entity.User;
import com.markup.dinerop.auth.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

@Component
@RequiredArgsConstructor
public class AdminBootstrapRunner implements ApplicationRunner {

    private static final Logger log = LoggerFactory.getLogger(AdminBootstrapRunner.class);
    private static final String ADMIN_EMAIL = "admin@markup.com";
    private static final String ADMIN_PASSWORD = "Admin123*";

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    @Override
    @Transactional
    public void run(ApplicationArguments args) {
        boolean adminExists = userRepository.existsByEmail(ADMIN_EMAIL)
                && userRepository.findByEmail(ADMIN_EMAIL)
                .map(user -> user.getRole() == Role.ADMIN)
                .orElse(false);

        if (adminExists) {
            log.info("ADMIN bootstrap skipped: user {} already exists", ADMIN_EMAIL);
            return;
        }

        if (userRepository.findByEmail(ADMIN_EMAIL).isPresent()) {
            log.warn("Skipping ADMIN bootstrap because {} already exists with another role", ADMIN_EMAIL);
            return;
        }

        User admin = User.builder()
                .email(ADMIN_EMAIL)
                .password(passwordEncoder.encode(ADMIN_PASSWORD))
                .role(Role.ADMIN)
                .active(true)
                .status("ACTIVE")
                .build();

        userRepository.save(admin);
        log.info("ADMIN bootstrap completed for {}", ADMIN_EMAIL);
    }
}