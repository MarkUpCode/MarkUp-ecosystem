package com.markup.dinerop.auth.dto;

import com.markup.dinerop.auth.entity.Role;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

public record InviteUserRequest(

        @Email
        @NotBlank
        String email,

        @NotNull
        Role role,

        Long cooperativaId

) {
}