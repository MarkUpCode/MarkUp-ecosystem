package com.markup.dinerop.auth.repository;

import com.markup.dinerop.auth.entity.CooperativeInvitation;
import jakarta.persistence.LockModeType;
import org.springframework.data.jpa.repository.*;
import org.springframework.data.repository.query.Param;
import java.util.*;

public interface CooperativeInvitationRepository extends JpaRepository<CooperativeInvitation, Long> {
    Optional<CooperativeInvitation> findByTokenHashAndUsedFalseAndRevokedFalse(String tokenHash);
    List<CooperativeInvitation> findByUser_IdUserAndUsedFalseAndRevokedFalse(Long userId);
    @Lock(LockModeType.PESSIMISTIC_WRITE)
    @Query("select i from CooperativeInvitation i join fetch i.user where i.tokenHash = :hash and i.used = false and i.revoked = false")
    Optional<CooperativeInvitation> lockValidByHash(@Param("hash") String hash);
}
