/**
 * Created by tendaimupezeni for e-commerce-app
 * Date: 6/9/24
 * Time: 4:32 PM
 */

package com.denyaar.orderservice.product;

import java.math.BigDecimal;

public record PurchaseResponse(
        Integer productId,
        String productName,

        String description,
        BigDecimal price,

        double quantity

        ) {
}
