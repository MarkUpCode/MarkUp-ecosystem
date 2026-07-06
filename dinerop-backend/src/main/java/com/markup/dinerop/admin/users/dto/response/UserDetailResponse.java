package com.markup.dinerop.admin.users.dto.response;

import com.markup.dinerop.auth.entity.Role;

import java.time.LocalDateTime;

public record UserDetailResponse(

        Long id,

        String email,

        Role role,

        String status,

        Boolean active,

        Long cooperativaId,

        LocalDateTime createdAt

) {
}