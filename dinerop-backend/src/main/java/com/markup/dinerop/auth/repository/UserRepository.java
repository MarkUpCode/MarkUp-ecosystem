package com.markup.dinerop.auth.repository;

import com.markup.dinerop.auth.entity.Role;
import com.markup.dinerop.auth.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface UserRepository extends JpaRepository<User, Long> {

    Optional<User> findByEmail(String email);

    boolean existsByEmail(String email);

    
    long countByRole(Role role);

    long countByActive(Boolean active);

    List<User> findTop10ByOrderByCreatedAtDesc();

}
