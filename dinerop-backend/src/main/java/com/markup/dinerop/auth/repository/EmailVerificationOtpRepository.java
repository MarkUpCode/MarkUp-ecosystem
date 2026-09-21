package com.markup.dinerop.auth.repository;

import com.markup.dinerop.auth.entity.EmailVerificationOtp;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface EmailVerificationOtpRepository extends JpaRepository<EmailVerificationOtp, Long> {

    Optional<EmailVerificationOtp> findTopByEmailAndUsedFalseAndRevokedFalseOrderByCreatedAtDesc(String email);

    Optional<EmailVerificationOtp> findTopByEmailOrderByCreatedAtDesc(String email);
}
