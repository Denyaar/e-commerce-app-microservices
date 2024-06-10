/**
 * Created by tendaimupezeni for e-commerce-app
 * Date: 6/9/24
 * Time: 3:49 PM
 */

package com.denyaar.orderservice.product;

import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;

public record PurchaseRequest(
        @NotNull(message = "Product ID is required")
        Integer productId,
        @NotNull(message = "Quantity is required")
        @Positive(message = "Quantity must be greater than zero")
        double quantity

) {
}
