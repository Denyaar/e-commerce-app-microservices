/**
 * Created by tendaimupezeni for e-commerce-app
 * Date: 6/9/24
 * Time: 3:39 PM
 */

package com.denyaar.orderservice.order;

import com.denyaar.orderservice.customer.CustomerClient;
import com.denyaar.orderservice.exception.BussinesException;
import com.denyaar.orderservice.kafka.OrderConfirmation;
import com.denyaar.orderservice.kafka.OrderProducer;
import com.denyaar.orderservice.product.ProductClient;
import com.denyaar.orderservice.product.PurchaseRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class OrderService {

    private final OrderRepository orderRepository;
    private final CustomerClient customerClient;
    private final ProductClient productClient;
    private final OrderMapper mapper;
    private final OrderLineService orderLineService;
    private  final OrderProducer orderProducer;


    public Integer createOrder(OrderRequest request) {
        //check if customer exist
        var customer = customerClient.findCustomerById(request.customerId())
                .orElseThrow(() -> new BussinesException("Customer not found"));

        var purchasedProduct  =  this.productClient.purchaseProducts(request.products());

        var order  = orderRepository.save(mapper.toOrder(request));

        for(PurchaseRequest purchaseRequest : request.products()) {
            orderLineService.saveOrderLine(new OrderLineRequest(null, order.getId(), purchaseRequest.productId(), purchaseRequest.quantity()));
        }

        //todo impliment payment service

        orderProducer.sendOrderConfirmation(
                new OrderConfirmation(
                        request.reference(),
                        request.amount(),
                        request.paymentMethod(),
                        customer,
                        purchasedProduct
                )
        );

        return  order.getId();

    }
}
