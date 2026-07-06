package com.markup.dinerop.admin.users.dto.request;

import com.markup.dinerop.auth.entity.Role;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

public record CreateUserRequest(

        @Email
        @NotBlank
        String email,

        @NotNull
        Role role,

        Long cooperativaId

) {
}