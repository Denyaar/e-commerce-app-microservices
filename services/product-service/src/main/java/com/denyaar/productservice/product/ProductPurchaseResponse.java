/**
 * Created by tendaimupezeni for e-commerce-app
 * Date: 6/9/24
 * Time: 12:13 PM
 */

package com.denyaar.productservice.product;

import java.math.BigDecimal;

public record ProductPurchaseResponse(
        Integer productId,
        String productName,
        String description,
        BigDecimal price,
        double quantity
) {
}
