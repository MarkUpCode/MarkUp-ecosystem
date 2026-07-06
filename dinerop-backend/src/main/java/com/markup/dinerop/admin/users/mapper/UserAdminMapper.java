package com.markup.dinerop.admin.users.mapper;

import com.markup.dinerop.admin.users.dto.response.UserDetailResponse;
import com.markup.dinerop.admin.users.dto.response.UserListItemResponse;
import com.markup.dinerop.auth.entity.User;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Component;

@Component
public class UserAdminMapper {

    public UserListItemResponse toListItem(User user) {
        return new UserListItemResponse(
                user.getIdUser(),
                user.getEmail(),
                user.getRole(),
                user.getStatus(),
                user.getActive(),
                user.getCreatedAt()
        );
    }

    public UserDetailResponse toDetail(User user) {
        return new UserDetailResponse(
                user.getIdUser(),
                user.getEmail(),
                user.getRole(),
                user.getStatus(),
                user.getActive(),
                user.getCooperativaId(),
                user.getCreatedAt()
        );
    }

    public Page<UserListItemResponse> toPage(Page<User> users) {
        return users.map(this::toListItem);
    }
}