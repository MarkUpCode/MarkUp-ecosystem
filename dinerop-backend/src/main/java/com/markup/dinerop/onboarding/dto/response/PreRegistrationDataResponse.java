package com.markup.dinerop.onboarding.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PreRegistrationDataResponse {

    private String firstName;
    private String lastName;
    private String identification;
    private String phone;
    private String email;
    private String province;
    private String city;
}