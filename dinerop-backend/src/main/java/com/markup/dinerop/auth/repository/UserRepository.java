package com.markup.dinerop.auth.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.markup.dinerop.auth.entity.Role;
import com.markup.dinerop.auth.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

import java.util.List;
import java.util.Optional;

public interface UserRepository extends JpaRepository<User, Long>,
        JpaSpecificationExecutor<User> {

    Optional<User> findByEmail(String email);

    boolean existsByEmail(String email);

    
    long countByRole(Role role);

    long countByActive(Boolean active);

    long countByStatus(String status);

    List<User> findTop10ByOrderByCreatedAtDesc();

    Page<User> findAll(Pageable pageable);

    Page<User> findByRole(Role role, Pageable pageable);

    Page<User> findByStatus(String status, Pageable pageable);

    Page<User> findByEmailContainingIgnoreCase(
            String email,
            Pageable pageable
    );

    Page<User> findByRoleAndStatus(
            Role role,
            String status,
            Pageable pageable
    );

}
