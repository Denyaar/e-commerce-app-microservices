/**
 * Created by tendaimupezeni for e-commerce-app
 * Date: 6/9/24
 * Time: 5:09 PM
 */

package com.denyaar.orderservice.orderline;

import com.denyaar.orderservice.order.Order;
import org.springframework.stereotype.Service;

@Service
public class OrderLineMapper {
    public OrderLine mapToOrderLine(OrderLineRequest orderLineRequest) {
        return  OrderLine.builder()
                .order(Order.builder()
                        .id(orderLineRequest.orderId())
                        .build())
                .productId(orderLineRequest.productId())
                .quantity(orderLineRequest.quantity())
                .build();
    }

    public OrderLineResponse toOrderLIneResponse(OrderLine orderLine) {
        return new OrderLineResponse(
                orderLine.getOrder().getId(),
                orderLine.getQuantity()
        );
    }
}
