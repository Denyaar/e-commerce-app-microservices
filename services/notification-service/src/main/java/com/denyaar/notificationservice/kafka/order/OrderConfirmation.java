/**
 * Created by tendaimupezeni for e-commerce-app
 * Date: 6/9/24
 * Time: 11:01 PM
 */

package com.denyaar.notificationservice.kafka.order;

import com.denyaar.notificationservice.kafka.payment.PaymentMethod;

import java.math.BigDecimal;
import java.util.List;

public record OrderConfirmation(
        String orderReference,
        BigDecimal amount,
        PaymentMethod paymentMethod,
        Customer customer,
        List<Product> products

) {
}
