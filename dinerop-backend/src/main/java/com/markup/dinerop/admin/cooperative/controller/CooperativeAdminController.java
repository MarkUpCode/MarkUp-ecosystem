package com.markup.dinerop.admin.cooperative.controller;

import com.markup.dinerop.admin.cooperative.dto.response.CooperativeDetailResponse;
import com.markup.dinerop.admin.cooperative.dto.response.PagedCooperativesResponse;
import com.markup.dinerop.admin.cooperative.service.CooperativeAdminService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import com.markup.dinerop.admin.cooperative.dto.request.CreateCooperativeRequest;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;
import com.markup.dinerop.admin.cooperative.dto.request.UpdateCooperativeRequest;

@RestController
@RequestMapping("/api/admin/cooperatives")
@RequiredArgsConstructor
@PreAuthorize("hasRole('ADMIN')")
public class CooperativeAdminController {

    private final CooperativeAdminService cooperativeAdminService;

    @GetMapping
    public PagedCooperativesResponse getCooperatives(

            @RequestParam(defaultValue = "0")
            int page,

            @RequestParam(defaultValue = "10")
            int size

    ) {

        return cooperativeAdminService.getCooperatives(
                page,
                size
        );

    }

    @GetMapping("/{id}")
    public CooperativeDetailResponse getCooperative(

            @PathVariable Long id

    ) {

        return cooperativeAdminService.getCooperative(id);

    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public CooperativeDetailResponse createCooperative(

            @Valid
            @RequestBody
            CreateCooperativeRequest request

    ) {

        return cooperativeAdminService.createCooperative(request);

    }

    @PutMapping("/{id}")
    public CooperativeDetailResponse updateCooperative(

            @PathVariable Long id,

            @Valid
            @RequestBody
            UpdateCooperativeRequest request

    ) {

        return cooperativeAdminService.updateCooperative(

                id,

                request

        );

    }

}