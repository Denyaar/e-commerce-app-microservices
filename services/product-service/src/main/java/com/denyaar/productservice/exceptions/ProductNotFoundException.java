/**
 * Created by tendaimupezeni for e-commerce-app
 * Date: 6/8/24
 * Time: 11:09 PM
 */

package com.denyaar.productservice.exceptions;

public class ProductNotFoundException extends RuntimeException {
    public ProductNotFoundException(String message) {
        super(message);
    }
}
