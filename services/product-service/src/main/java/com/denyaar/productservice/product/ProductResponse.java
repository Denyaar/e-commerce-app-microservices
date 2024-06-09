/**
 * Created by tendaimupezeni for e-commerce-app
 * Date: 6/9/24
 * Time: 12:17 PM
 */

package com.denyaar.productservice.product;

import com.denyaar.productservice.category.Category;

import java.math.BigDecimal;

public record ProductResponse(
        Integer id,

        String name,
        String description,
        BigDecimal price,
        double availableQuantity,
        Integer categoryId,

        String categoryName,
        String categoryDescription
) {
}
