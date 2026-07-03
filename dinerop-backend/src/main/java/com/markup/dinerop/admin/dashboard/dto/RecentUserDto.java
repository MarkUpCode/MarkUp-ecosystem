package com.markup.dinerop.admin.dashboard.dto;

import com.markup.dinerop.auth.entity.Role;

import java.time.LocalDateTime;

public record RecentUserDto(
        Long id,
        String email,
        Role role,
        String status,
        LocalDateTime createdAt
) {
}