/**
 * Created by tendaimupezeni for e-commerce-app
 * Date: 6/9/24
 * Time: 10:02 PM
 */

package com.denyaar.paymentservice.notification;

import com.denyaar.paymentservice.payment.PaymentMethod;

import java.math.BigDecimal;

public record PaymentNotificationRequest(
        String orderReference,
        BigDecimal amount,
        PaymentMethod paymentMethod,
        String customerFirstName,
        String customerLastName,
        String customerEmail
) {
}
