/**
 * Created by tendaimupezeni for e-commerce-app
 * Date: 6/9/24
 * Time: 5:42 PM
 */

package com.denyaar.orderservice.kafka;

import com.denyaar.orderservice.customer.CustomerResponse;
import com.denyaar.orderservice.order.PaymentMethod;
import com.denyaar.orderservice.product.PurchaseResponse;

import java.math.BigDecimal;
import java.util.List;

public record OrderConfirmation(
        String orderReference,
        BigDecimal amount,
        PaymentMethod paymentMethod,
        CustomerResponse customer,
        List<PurchaseResponse> products
) {
}
