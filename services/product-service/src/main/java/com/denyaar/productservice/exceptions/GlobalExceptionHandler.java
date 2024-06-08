/**
 * Created by tendaimupezeni for e-commerce-app
 * Date: 6/8/24
 * Time: 11:08 PM
 */

package com.denyaar.productservice.exceptions;

import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

@RestControllerAdvice
public class GlobalExceptionHandler {
    @ExceptionHandler(ProductNotFoundException.class)
    public String handleProductNotFoundException(ProductNotFoundException e) {
        return e.getMessage();
    }

}
