package com.markup.dinerop.admin.users.dto.response;

public record UserStatsResponse(

        long total,

        long active,

        long pending,

        long disabled

) {
}