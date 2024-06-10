/**
 * Created by tendaimupezeni for e-commerce-app
 * Date: 6/9/24
 * Time: 10:30 PM
 */

package com.denyaar.orderservice.payment;

import com.denyaar.orderservice.customer.CustomerResponse;
import com.denyaar.orderservice.order.PaymentMethod;

import java.math.BigDecimal;

public record PaymentRequest(
        Integer id,
        BigDecimal amount,
        PaymentMethod paymentMethod,
        Integer orderId,
        String orderReference,
        CustomerResponse customer
) {
}
