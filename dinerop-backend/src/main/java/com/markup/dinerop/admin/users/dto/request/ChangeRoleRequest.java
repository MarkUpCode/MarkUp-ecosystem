package com.markup.dinerop.admin.users.dto.request;

import com.markup.dinerop.auth.entity.Role;
import jakarta.validation.constraints.NotNull;

public record ChangeRoleRequest(

        @NotNull
        Role role

) {
}