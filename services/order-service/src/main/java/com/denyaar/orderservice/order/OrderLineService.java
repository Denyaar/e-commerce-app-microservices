/**
 * Created by tendaimupezeni for e-commerce-app
 * Date: 6/9/24
 * Time: 5:02 PM
 */

package com.denyaar.orderservice.order;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class OrderLineService {

    private final OrderLineRepository orderLineRepository;
    private  OrderLineMapper orderLineMapper;
    public Integer saveOrderLine(OrderLineRequest orderLineRequest) {
        var order  =  orderLineMapper.mapToOrderLine(orderLineRequest);
        return orderLineRepository.save(order).getId();

    }
}
