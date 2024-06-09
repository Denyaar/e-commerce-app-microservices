/**
 * Created by tendaimupezeni for e-commerce-app
 * Date: 6/9/24
 * Time: 3:44 PM
 */

package com.denyaar.orderservice.order;

import com.denyaar.orderservice.product.PurchaseRequest;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;

import java.math.BigDecimal;
import java.util.List;

public record OrderRequest(
        Integer id,
        String reference,
        @NotNull(message = "Payment method is required")
        PaymentMethod paymentMethod,
        @Positive(message = "Amount must be greater than zero")
        BigDecimal amount,
        @NotNull(message = "Customer ID is required")
        @NotEmpty(message = "Customer ID is required")
        @NotBlank(message = "Customer ID is required")
        String customerId,

        @NotEmpty(message = "Order lines are required at least one product")
        List<PurchaseRequest> products

) {
}
