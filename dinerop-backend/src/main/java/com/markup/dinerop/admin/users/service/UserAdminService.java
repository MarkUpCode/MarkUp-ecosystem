package com.markup.dinerop.admin.users.service;

import com.markup.dinerop.admin.users.dto.response.PagedUsersResponse;
import com.markup.dinerop.admin.users.dto.response.UserDetailResponse;
import com.markup.dinerop.admin.users.dto.response.UserListItemResponse;
import com.markup.dinerop.admin.users.exception.UserNotFoundException;
import com.markup.dinerop.admin.users.mapper.UserAdminMapper;
import com.markup.dinerop.auth.entity.User;
import com.markup.dinerop.auth.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;
import com.markup.dinerop.admin.users.dto.request.CreateUserRequest;
import com.markup.dinerop.auth.dto.InviteUserRequest;
import com.markup.dinerop.auth.service.AuthService;
import com.markup.dinerop.admin.users.dto.response.UserStatsResponse;

@Service
@RequiredArgsConstructor
public class UserAdminService {

    private final UserRepository userRepository;
    private final UserAdminMapper mapper;
    private final AuthService authService;

    public PagedUsersResponse getUsers(int page, int size) {

        Page<User> users = userRepository.findAll(PageRequest.of(page, size));

        Page<UserListItemResponse> mappedUsers = mapper.toPage(users);

        UserStatsResponse stats = new UserStatsResponse(

            userRepository.count(),

            userRepository.countByStatus("ACTIVE"),

            userRepository.countByStatus("PENDING_ACTIVATION"),

            userRepository.countByStatus("DISABLED")

        );

        return new PagedUsersResponse(
            mappedUsers.getContent(),
            mappedUsers.getNumber(),
            mappedUsers.getSize(),
            mappedUsers.getTotalElements(),
            mappedUsers.getTotalPages(),
            mappedUsers.isFirst(),
            mappedUsers.isLast(),
            stats
        );
    }

    public UserDetailResponse getUser(Long id) {

        User user = userRepository.findById(id)
            .orElseThrow(() -> new UserNotFoundException(id));
        return mapper.toDetail(user);
    }
    public UserDetailResponse createUser(CreateUserRequest request) {

        InviteUserRequest inviteRequest =
                new InviteUserRequest(

                        request.email(),

                        request.role(),

                        request.cooperativaId()

                );

        User user = authService.inviteUser(inviteRequest);

        return mapper.toDetail(user);

    }

    public UserDetailResponse changeStatus(
            Long id,
            Boolean active
    ) {

        User user = userRepository.findById(id)
                .orElseThrow(() -> new UserNotFoundException(id));

        user.setActive(active);

        if (Boolean.TRUE.equals(active)) {
            user.setStatus("ACTIVE");
        } else {
            user.setStatus("DISABLED");
        }

        user = userRepository.save(user);

        return mapper.toDetail(user);

    }

}