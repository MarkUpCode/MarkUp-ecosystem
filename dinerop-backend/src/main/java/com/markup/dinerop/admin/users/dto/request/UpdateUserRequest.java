package com.markup.dinerop.admin.users.dto.request;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;

public record UpdateUserRequest(

        @Email
        @NotBlank
        String email

) {
}