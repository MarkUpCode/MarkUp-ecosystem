package com.markup.dinerop.admin.users.dto.response;

import java.util.List;

public record PagedUsersResponse(

        List<UserListItemResponse> content,

        int page,

        int size,

        long totalElements,

        int totalPages,

        boolean first,

        boolean last

) {
}