/**
 * Created by tendaimupezeni for e-commerce-app
 * Date: 6/9/24
 * Time: 11:02 PM
 */

package com.denyaar.notificationservice.kafka.payment;

import java.math.BigDecimal;

public record PaymentConfirmation(

        String orderReference,
        BigDecimal amount,
        PaymentMethod paymentMethod,
        String customerFirstName,
        String customerLastName,
        String customerEmail

) {
}
