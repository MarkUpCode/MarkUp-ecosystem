package com.markup.dinerop.auth.config;

import com.markup.dinerop.auth.entity.User;
import com.markup.dinerop.auth.repository.UserRepository;
import com.markup.dinerop.auth.service.JwtService;
import io.jsonwebtoken.JwtException;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;

@Component
@RequiredArgsConstructor
public class JwtAuthenticationFilter extends OncePerRequestFilter {

    private static final Logger log = LoggerFactory.getLogger(JwtAuthenticationFilter.class);

    private final JwtService jwtService;
    private final UserRepository userRepository;

    @Override
    protected void doFilterInternal(
            HttpServletRequest request,
            HttpServletResponse response,
            FilterChain filterChain
    ) throws ServletException, IOException {

        final String authHeader = request.getHeader("Authorization");

        // No token → continuar
        if (authHeader == null || !authHeader.startsWith("Bearer ")) {
            filterChain.doFilter(request, response);
            return;
        }

        final String jwt = authHeader.substring(7);

        try {
            String userEmail = jwtService.extractUsername(jwt);

            if (SecurityContextHolder.getContext().getAuthentication() == null) {

                User user = userRepository.findByEmail(userEmail).orElse(null);

                if (user == null) {
                    log.warn("JWT rejected for {} {}: subject has no matching user", request.getMethod(), request.getRequestURI());
                } else if (jwtService.isTokenValid(jwt, user)) {

                    UsernamePasswordAuthenticationToken authToken =
                            new UsernamePasswordAuthenticationToken(
                                    user,
                                    null,
                                    user.getAuthorities()
                            );

                    authToken.setDetails(
                            new WebAuthenticationDetailsSource().buildDetails(request)
                    );

                    SecurityContextHolder.getContext().setAuthentication(authToken);
                } else {
                    log.warn("JWT rejected for {} {}: token does not match the resolved user", request.getMethod(), request.getRequestURI());
                }
            }

        } catch (JwtException e) {
            // Log only the failure category and route. Never log the token or its claims.
            log.warn("JWT rejected for {} {}: {}", request.getMethod(), request.getRequestURI(), e.getClass().getSimpleName());
            SecurityContextHolder.clearContext();
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        filterChain.doFilter(request, response);
    }
}
