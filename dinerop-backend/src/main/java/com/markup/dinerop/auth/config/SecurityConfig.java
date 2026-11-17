package com.markup.dinerop.auth.config;

import com.markup.dinerop.auth.service.CustomUserDetailsService;
import jakarta.servlet.DispatcherType;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.web.cors.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.List;

@Configuration
@EnableWebSecurity
@RequiredArgsConstructor
public class SecurityConfig {

    private static final Logger log = LoggerFactory.getLogger(SecurityConfig.class);

    private final JwtAuthenticationFilter jwtAuthenticationFilter;
    private final CustomUserDetailsService userDetailsService;
    private final PasswordEncoder passwordEncoder;

    @Value("${CORS_ALLOWED_ORIGINS:https://markupadmin-tau.vercel.app,https://markupusers.vercel.app,https://markupusers-8919qrktg-mark-up.vercel.app,https://markupadmin-8p5d0s9sd-mark-up.vercel.app,http://localhost:5173,http://localhost:5174,https://www.dinerop.com,https://dinerop.com,http://markup-ecosystem-production.up.railway.app,https://markup-ecosystem-production.up.railway.app}")
    private String allowedOriginsRaw;

    // Dominio desde el que Railway lanza el healthcheck — debe estar permitido
    private static final String RAILWAY_HEALTHCHECK_HOST = "healthcheck.railway.app";

    private static final String[] PUBLIC_ENDPOINTS = {
            "/api/auth/**",
            "/api/invitations/**",
            "/api/cooperatives/**",
            "/api/visits/**",
            "/v3/api-docs/**",
            "/api/test/**",
            "/swagger-ui/**",
            "/swagger-ui.html",
            "/actuator/**"
    };

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
                .csrf(AbstractHttpConfigurer::disable)
                .cors(cors -> cors.configurationSource(corsConfigurationSource()))
                .authorizeHttpRequests(auth -> auth
                        .dispatcherTypeMatchers(DispatcherType.ERROR).permitAll()
                        .requestMatchers(HttpMethod.OPTIONS, "/**").permitAll()
                        .requestMatchers(PUBLIC_ENDPOINTS).permitAll()
                        .requestMatchers(HttpMethod.GET, "/api/investments/offers").permitAll()
                        .requestMatchers(HttpMethod.GET, "/api/investments/availability").permitAll()
                        .requestMatchers(HttpMethod.GET, "/api/credits/public-offers").permitAll()
                        .requestMatchers(HttpMethod.POST, "/api/credits/public-request").permitAll()
                        .anyRequest().authenticated()
                )
                .exceptionHandling(exceptions -> exceptions.authenticationEntryPoint((request, response, authException) -> {
                    log.warn("Unauthenticated request to protected endpoint: {} {}", request.getMethod(), request.getRequestURI());
                    response.setStatus(org.springframework.http.HttpStatus.UNAUTHORIZED.value());
                }))
                .sessionManagement(sess ->
                        sess.sessionCreationPolicy(SessionCreationPolicy.STATELESS)
                )
                .authenticationProvider(authenticationProvider())
                .addFilterBefore(jwtAuthenticationFilter, UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }

    @Bean
    public DaoAuthenticationProvider authenticationProvider() {
        DaoAuthenticationProvider provider = new DaoAuthenticationProvider();
        provider.setUserDetailsService(userDetailsService);
        provider.setPasswordEncoder(passwordEncoder);
        return provider;
    }

    @Bean
    public AuthenticationManager authenticationManager(AuthenticationConfiguration config) throws Exception {
        return config.getAuthenticationManager();
    }

    @Bean
    public CorsConfigurationSource corsConfigurationSource() {
        // Orígenes del frontend
        List<String> allowedOrigins = new java.util.ArrayList<>(List.of(allowedOriginsRaw.split(",")));
        // Agrega el host de Railway healthcheck para que no sea bloqueado
        allowedOrigins.add("https://" + RAILWAY_HEALTHCHECK_HOST);
        allowedOrigins.add("http://" + RAILWAY_HEALTHCHECK_HOST);

        CorsConfiguration config = new CorsConfiguration();
        config.setAllowedOrigins(allowedOrigins);
        config.setAllowedMethods(List.of(
                "GET",
                "POST",
                "PUT",
                "PATCH",
                "DELETE",
                "OPTIONS"
        ));
        config.setAllowedHeaders(List.of("*"));
        config.setAllowCredentials(true);

        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", config);
        return source;
    }
}
