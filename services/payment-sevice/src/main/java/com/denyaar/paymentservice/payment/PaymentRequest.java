/**
 * Created by tendaimupezeni for e-commerce-app
 * Date: 6/9/24
 * Time: 9:43 PM
 */

package com.denyaar.paymentservice.payment;

import java.math.BigDecimal;

public record PaymentRequest(

        Integer id,
        BigDecimal amount,
        PaymentMethod paymentMethod,
        Integer orderId,
        String orderReference,
        Customer customer

) {
}
