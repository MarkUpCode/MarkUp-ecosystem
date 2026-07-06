package com.markup.dinerop.admin.common.exception;

import com.markup.dinerop.admin.common.dto.ApiErrorResponse;
import com.markup.dinerop.admin.users.exception.*;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;

@RestControllerAdvice
public class AdminGlobalExceptionHandler {

    @ExceptionHandler(UserNotFoundException.class)
    @ResponseStatus(HttpStatus.NOT_FOUND)
    public ApiErrorResponse handleUserNotFound(
            UserNotFoundException ex,
            HttpServletRequest request
    ) {

        return new ApiErrorResponse(
                LocalDateTime.now(),
                404,
                "NOT_FOUND",
                ex.getMessage(),
                request.getRequestURI()
        );
    }

    @ExceptionHandler(UserAlreadyExistsException.class)
    @ResponseStatus(HttpStatus.CONFLICT)
    public ApiErrorResponse handleAlreadyExists(
            UserAlreadyExistsException ex,
            HttpServletRequest request
    ) {

        return new ApiErrorResponse(
                LocalDateTime.now(),
                409,
                "CONFLICT",
                ex.getMessage(),
                request.getRequestURI()
        );
    }

    @ExceptionHandler({
            InvalidUserRoleException.class,
            CooperativeRequiredException.class
    })
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public ApiErrorResponse handleBadRequest(
            RuntimeException ex,
            HttpServletRequest request
    ) {

        return new ApiErrorResponse(
                LocalDateTime.now(),
                400,
                "BAD_REQUEST",
                ex.getMessage(),
                request.getRequestURI()
        );
    }

}