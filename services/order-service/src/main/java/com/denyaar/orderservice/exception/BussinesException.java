/**
 * Created by tendaimupezeni for e-commerce-app
 * Date: 6/9/24
 * Time: 4:24 PM
 */

package com.denyaar.orderservice.exception;

public class BussinesException extends RuntimeException {
    public BussinesException(String customerNotFound) {
        super(customerNotFound);
    }
}
