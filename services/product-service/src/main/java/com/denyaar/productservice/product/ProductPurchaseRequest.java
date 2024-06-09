/**
 * Created by tendaimupezeni for e-commerce-app
 * Date: 6/9/24
 * Time: 12:14 PM
 */

package com.denyaar.productservice.product;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;

public record ProductPurchaseRequest(
        @NotNull(message = "Product id is required")
        Integer productId,
        @Positive(message = "Quantity must be greater than 0")
        double quantity

) {
}
