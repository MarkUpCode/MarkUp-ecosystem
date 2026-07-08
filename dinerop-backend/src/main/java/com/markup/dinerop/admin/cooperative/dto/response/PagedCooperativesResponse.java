package com.markup.dinerop.admin.cooperative.dto.response;

import java.util.List;

public record PagedCooperativesResponse(

        List<CooperativeListItemResponse> content,

        int page,

        int size,

        long totalElements,

        int totalPages,

        boolean first,

        boolean last

) {
}