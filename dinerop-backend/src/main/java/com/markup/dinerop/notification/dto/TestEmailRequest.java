package com.markup.dinerop.notification.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class TestEmailRequest {

    @Email
    @NotBlank
    private String to;

}