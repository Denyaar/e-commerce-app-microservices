/**
 * Created by tendaimupezeni for e-commerce-app
 * Date: 6/9/24
 * Time: 8:31 PM
 */

package com.denyaar.orderservice.order;

import java.math.BigDecimal;

public record OrderResponse(
        Integer id,
        String customerId,
        String reference,
        BigDecimal amount,
        PaymentMethod paymentMethod
) {
}
