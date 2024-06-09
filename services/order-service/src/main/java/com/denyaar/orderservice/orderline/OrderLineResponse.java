/**
 * Created by tendaimupezeni for e-commerce-app
 * Date: 6/9/24
 * Time: 9:17 PM
 */

package com.denyaar.orderservice.orderline;

public record OrderLineResponse(
        Integer orderId,
        double quantity

) {
}
