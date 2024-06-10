/**
 * Created by tendaimupezeni for e-commerce-app
 * Date: 6/9/24
 * Time: 5:04 PM
 */

package com.denyaar.orderservice.orderline;

public record OrderLineRequest(Integer id, Integer orderId, Integer productId, double quantity) {
}
