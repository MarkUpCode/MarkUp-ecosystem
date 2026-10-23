package com.markup.dinerop.security;

import com.markup.dinerop.auth.service.AuthService;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.security.test.context.support.WithMockUser;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.beans.factory.annotation.Autowired;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest(properties = {
        "spring.datasource.url=jdbc:h2:mem:dinerop_security_test;MODE=PostgreSQL;DB_CLOSE_DELAY=-1;DB_CLOSE_ON_EXIT=FALSE",
        "spring.datasource.driver-class-name=org.h2.Driver",
        "spring.datasource.username=sa",
        "spring.jpa.hibernate.ddl-auto=create-drop",
        "spring.jpa.database-platform=org.hibernate.dialect.H2Dialect"
})
@ActiveProfiles("dev")
@AutoConfigureMockMvc
class SecurityActivityTest {

    @Autowired
    private MockMvc mockMvc;

    @MockBean
    private AuthService authService;

    @Test
    void anonymousUserCannotAccessPrivateCreditsEndpoint() throws Exception {
        mockMvc.perform(get("/api/credits/me"))
                .andExpect(status().isUnauthorized());
    }

    @Test
    @WithMockUser(roles = "CLIENT")
    void clientCannotCreateAdminThroughInternalRegistration() throws Exception {
        mockMvc.perform(post("/api/internal/auth/pre-register")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {"email":"synthetic-admin@example.com","role":"ADMIN"}
                                """))
                .andExpect(status().isForbidden());
    }

    @Test
    @WithMockUser(roles = "ADMIN")
    void unsupportedRoleIsRejectedByBackend() throws Exception {
        mockMvc.perform(post("/api/internal/auth/pre-register")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {"email":"synthetic-user@example.com","role":"ROOT"}
                                """))
                .andExpect(status().isBadRequest());
    }

    @Test
    @WithMockUser(roles = "CLIENT")
    void clientCannotExecuteAdminOperation() throws Exception {
        mockMvc.perform(get("/api/admin/users"))
                .andExpect(status().isForbidden());
    }

    @Test
    @WithMockUser(roles = "CLIENT")
    void clientCannotExecuteCooperativeOperation() throws Exception {
        mockMvc.perform(get("/api/credits/cooperative/me/requests"))
                .andExpect(status().isForbidden());
    }

    @Test
    void invalidRegistrationPayloadIsRejected() throws Exception {
        mockMvc.perform(post("/api/auth/register")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {"email":"not-an-email","firstName":"","lastName":""}
                                """))
                .andExpect(status().isBadRequest());
    }
}
