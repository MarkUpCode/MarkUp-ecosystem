package com.markup.dinerop.credit.infrastructure.web.error;

import jakarta.servlet.http.HttpServletRequest;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.time.OffsetDateTime;

@RestControllerAdvice(basePackages = "com.markup.dinerop.credit")
@Slf4j
public class CreditExceptionHandler {

    @ExceptionHandler(IllegalArgumentException.class)
    public ResponseEntity<ApiError> handleInvalidCreditRequest(
            IllegalArgumentException exception,
            HttpServletRequest request
    ) {
        log.warn("Invalid credit request: path={}, reason={}", request.getRequestURI(), exception.getMessage());
        return error(HttpStatus.BAD_REQUEST, exception, request);
    }

    @ExceptionHandler(IllegalStateException.class)
    public ResponseEntity<ApiError> handleInvalidCreditTransition(
            IllegalStateException exception,
            HttpServletRequest request
    ) {
        log.warn("Credit state conflict: path={}, reason={}", request.getRequestURI(), exception.getMessage());
        return error(HttpStatus.CONFLICT, exception, request);
    }

    private ResponseEntity<ApiError> error(
            HttpStatus status,
            RuntimeException exception,
            HttpServletRequest request
    ) {
        ApiError body = new ApiError(
                OffsetDateTime.now(),
                status.value(),
                status.getReasonPhrase(),
                exception.getMessage(),
                request.getRequestURI()
        );
        return ResponseEntity.status(status).body(body);
    }
}
