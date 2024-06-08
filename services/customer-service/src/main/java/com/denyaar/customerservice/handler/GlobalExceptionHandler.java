/**
 * Created by tendaimupezeni for e-commerce-app
 * Date: 6/8/24
 * Time: 9:52 PM
 */

package com.denyaar.customerservice.handler;

import com.denyaar.customerservice.ErrorResponse;
import org.apache.hc.core5.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.servlet.View;

import java.util.HashMap;

@RestControllerAdvice
public class GlobalExceptionHandler {

    private final View error;

    public GlobalExceptionHandler(View error) {
        this.error = error;
    }

    @ExceptionHandler(RuntimeException.class)
    public ResponseEntity handleRuntimeException(RuntimeException ex) {
        return ResponseEntity
                .status(HttpStatus.SC_NOT_FOUND)
                .body(ex.getMessage());
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ErrorResponse> handleRuntimeException(MethodArgumentNotValidException ex) {

        var errors = new HashMap<String, String>();
        ex.getBindingResult().getFieldErrors().forEach(error -> {
                    var fieldName = error.getField();
                    var errorMessage = error.getDefaultMessage();
                    errors.put(fieldName, errorMessage);
                }
        );
        return ResponseEntity
                .status(HttpStatus.SC_BAD_REQUEST)
                .body(new ErrorResponse(errors));
    }
}
