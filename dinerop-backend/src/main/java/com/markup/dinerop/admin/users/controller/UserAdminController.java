package com.markup.dinerop.admin.users.controller;

import com.markup.dinerop.admin.users.dto.response.PagedUsersResponse;
import com.markup.dinerop.admin.users.dto.response.UserDetailResponse;
import com.markup.dinerop.admin.users.service.UserAdminService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import com.markup.dinerop.admin.users.dto.request.CreateUserRequest;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;
import com.markup.dinerop.admin.users.dto.request.ChangeStatusRequest;

@RestController
@RequestMapping("/api/admin/users")
@RequiredArgsConstructor
@PreAuthorize("hasRole('ADMIN')")
public class UserAdminController {

    private final UserAdminService userAdminService;

    @GetMapping
    public PagedUsersResponse getUsers(

            @RequestParam(defaultValue = "0")
            int page,

            @RequestParam(defaultValue = "10")
            int size

    ) {

        return userAdminService.getUsers(page, size);

    }

    @GetMapping("/{id}")
    public UserDetailResponse getUser(
            @PathVariable Long id
    ) {

        return userAdminService.getUser(id);

    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public UserDetailResponse createUser(
            @Valid @RequestBody CreateUserRequest request
    ) {
        return userAdminService.createUser(request);
    }

    @PatchMapping("/{id}/status")
    public UserDetailResponse changeStatus(

            @PathVariable Long id,

            @Valid @RequestBody ChangeStatusRequest request

    ) {

        return userAdminService.changeStatus(

                id,

                request.active()

        );

    }

}