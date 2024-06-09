/**
 * Created by tendaimupezeni for e-commerce-app
 * Date: 6/9/24
 * Time: 5:09 PM
 */

package com.denyaar.orderservice.order;

import org.springframework.stereotype.Service;

@Service
public class OrderLineMapper {
    public OrderLine mapToOrderLine(OrderLineRequest orderLineRequest) {
        return  OrderLine.builder()
                .id(orderLineRequest.id())
                .order(Order.builder()
                        .id(orderLineRequest.orderId())
                        .build())
                .productId(orderLineRequest.productId())
                .quantity(orderLineRequest.quantity())
                .build();
    }
}
