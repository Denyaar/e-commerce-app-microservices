/**
 * Created by tendaimupezeni for e-commerce-app
 * Date: 6/9/24
 * Time: 12:31 PM
 */

package com.denyaar.productservice.product;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;

import java.math.BigDecimal;

public record ProductRequest(
        Integer id,
        @NotNull(message = "Product name is required")
        String name,
        @NotNull(message = "Product description is required")
        String description,
        @Positive(message = "Product price must be greater than 0")
        BigDecimal price,
        @Positive(message = "Product available quantity must be greater than 0")
        double availableQuantity,
        @NotNull(message = "Product category is required")
        Integer categoryId
) {
}
