package com.markup.dinerop.notification.repository;

import com.markup.dinerop.notification.entity.PushDeviceToken;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface PushDeviceTokenRepository extends JpaRepository<PushDeviceToken, Long> {

    Optional<PushDeviceToken> findByToken(String token);

    List<PushDeviceToken> findByUserIdUserAndEnabledTrue(Long userId);
}
