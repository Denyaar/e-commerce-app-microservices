/**
 * Created by tendaimupezeni for e-commerce-app
 * Date: 6/9/24
 * Time: 4:19 PM
 */

package com.denyaar.orderservice.customer;

public record CustomerResponse(
        String customerId,
        String firstName,
        String lastName,
        String email

) {
}
