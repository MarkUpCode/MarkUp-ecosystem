package com.markup.dinerop.admin.users.dto.request;

import jakarta.validation.constraints.NotNull;

public record ChangeStatusRequest(

        @NotNull
        Boolean active

) {
}