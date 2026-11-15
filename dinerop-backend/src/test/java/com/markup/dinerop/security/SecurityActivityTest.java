package com.markup.dinerop.security;

import com.markup.dinerop.auth.entity.Role;
import com.markup.dinerop.auth.entity.User;
import com.markup.dinerop.auth.repository.UserRepository;
import com.markup.dinerop.auth.service.JwtService;
import com.markup.dinerop.credit.domain.model.CreditRequest;
import com.markup.dinerop.credit.domain.model.SolicitudCooperativa;
import com.markup.dinerop.credit.domain.model.enums.CreditRejectionReason;
import com.markup.dinerop.credit.domain.model.enums.CreditRequestType;
import com.markup.dinerop.credit.domain.model.enums.SolicitudCooperativaStatus;
import com.markup.dinerop.credit.infrastructure.repository.CreditRequestRepository;
import com.markup.dinerop.credit.infrastructure.repository.SolicitudCooperativaRepository;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.security.test.context.support.WithMockUser;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.test.web.servlet.MvcResult;

import java.math.BigDecimal;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.put;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;

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

    @Autowired
    private JwtService jwtService;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private ObjectMapper objectMapper;

    @Autowired
    private CreditRequestRepository creditRequestRepository;

    @Autowired
    private SolicitudCooperativaRepository solicitudCooperativaRepository;

    @Test
    void anonymousUserCannotAccessPrivateCreditsEndpoint() throws Exception {
        mockMvc.perform(get("/api/credits/me"))
                .andExpect(status().isUnauthorized());
    }

    @Test
    void loginTokenForClientCanAccessMyCreditsEndpoint() throws Exception {
        User client = userRepository.saveAndFlush(User.builder()
                .email("jwt-client@example.com")
                .password(passwordEncoder.encode("test-password"))
                .role(Role.CLIENT)
                .status("ACTIVE")
                .active(true)
                .build());

        CreditRequest request = creditRequestRepository.saveAndFlush(CreditRequest.builder()
                .clientId(client.getIdUser())
                .email(client.getEmail())
                .identification("1234567890")
                .amount(new BigDecimal("1000.00"))
                .tipo(CreditRequestType.CREDITO)
                .build());
        solicitudCooperativaRepository.saveAndFlush(SolicitudCooperativa.builder()
                .solicitudId(request.getId())
                .cooperativaId(1L)
                .estado(SolicitudCooperativaStatus.RECHAZADA)
                .motivosRechazo(java.util.List.of(CreditRejectionReason.CAPACIDAD_DE_PAGO))
                .build());

        MvcResult login = mockMvc.perform(post("/api/auth/login")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {"email":"jwt-client@example.com","password":"test-password"}
                                """))
                .andExpect(status().isOk())
                .andReturn();
        String token = objectMapper.readTree(login.getResponse().getContentAsString())
                .get("accessToken").asText();

        mockMvc.perform(get("/api/credits/me")
                        .header("Authorization", "Bearer " + token))
                .andExpect(status().isOk())
                .andExpect(content().json("[{\"motivosRechazo\":[\"El crédito sobrepasa su capacidad de pago\"]}]", false));
    }

    @Test
    void validAdminJwtCannotAccessClientCreditsEndpoint() throws Exception {
        User admin = userRepository.saveAndFlush(User.builder()
                .email("jwt-admin@example.com")
                .password("not-used-by-this-test")
                .role(Role.ADMIN)
                .status("ACTIVE")
                .active(true)
                .build());
        String token = jwtService.generateToken(admin);

        mockMvc.perform(get("/api/credits/me")
                        .header("Authorization", "Bearer " + token))
                .andExpect(status().isForbidden());
    }

    @Test
    void invalidJwtCannotAccessMyCreditsEndpoint() throws Exception {
        mockMvc.perform(get("/api/credits/me")
                        .header("Authorization", "Bearer not.a.valid.jwt"))
                .andExpect(status().isUnauthorized());
    }

    @Test
    void cooperativeCanRejectAndClientReceivesReasons() throws Exception {
        User client = userRepository.saveAndFlush(User.builder()
                .email("reject-client@example.com")
                .password(passwordEncoder.encode("test-password"))
                .role(Role.CLIENT)
                .status("ACTIVE")
                .active(true)
                .build());
        User cooperative = userRepository.saveAndFlush(User.builder()
                .email("reject-cooperative@example.com")
                .password("not-used-by-this-test")
                .role(Role.COOPERATIVE)
                .cooperativaId(1L)
                .status("ACTIVE")
                .active(true)
                .build());
        CreditRequest request = creditRequestRepository.saveAndFlush(CreditRequest.builder()
                .clientId(client.getIdUser())
                .email(client.getEmail())
                .identification("0987654321")
                .amount(new BigDecimal("1000.00"))
                .tipo(CreditRequestType.CREDITO)
                .build());
        solicitudCooperativaRepository.saveAndFlush(SolicitudCooperativa.builder()
                .solicitudId(request.getId())
                .cooperativaId(1L)
                .estado(SolicitudCooperativaStatus.ENVIADA)
                .build());

        String cooperativeToken = jwtService.generateToken(cooperative);
        mockMvc.perform(put("/api/credits/cooperative/me/requests/{id}/decision", request.getId())
                        .header("Authorization", "Bearer " + cooperativeToken)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {"decision":"RECHAZAR","motivosRechazo":["CAPACIDAD_DE_PAGO"]}
                                """))
                .andExpect(status().isOk());

        String clientToken = jwtService.generateToken(client);
        mockMvc.perform(get("/api/credits/me")
                        .header("Authorization", "Bearer " + clientToken))
                .andExpect(status().isOk())
                .andExpect(content().json("[{\"estado\":\"RECHAZADA\",\"motivosRechazo\":[\"El crédito sobrepasa su capacidad de pago\"]}]", false));
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
