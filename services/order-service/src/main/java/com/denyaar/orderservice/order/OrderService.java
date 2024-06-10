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
import com.denyaar.orderservice.orderline.OrderLineRequest;
import com.denyaar.orderservice.orderline.OrderLineService;
import com.denyaar.orderservice.payment.PaymentClient;
import com.denyaar.orderservice.payment.PaymentRequest;
import com.denyaar.orderservice.product.ProductClient;
import com.denyaar.orderservice.product.PurchaseRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class OrderService {

    private final OrderRepository orderRepository;
    private final CustomerClient customerClient;
    private final ProductClient productClient;
    private final OrderMapper mapper;
    private final OrderLineService orderLineService;
    private  final OrderProducer orderProducer;
    private final PaymentClient paymentClient;


    public Integer createOrder(OrderRequest request) {
        var customer = customerClient.findCustomerById(request.customerId())
                .orElseThrow(() -> new BussinesException("Customer not found"));

        var purchasedProduct  =  this.productClient.purchaseProducts(request.products());

        var order  = orderRepository.save(mapper.toOrder(request));

        for(PurchaseRequest purchaseRequest : request.products()) {
            orderLineService.saveOrderLine(new OrderLineRequest(null, order.getId(), purchaseRequest.productId(), purchaseRequest.quantity()));
        }

        paymentClient.requestPayment(
                new PaymentRequest(
                        request.id(),
                        request.amount(),
                        request.paymentMethod(),
                        order.getId(),
                        order.getReference(),
                        customer
                ));

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

    public List<OrderResponse> findAll() {
            return  orderRepository.findAll().stream()
                    .map(mapper::toOrderResponse)
                    .toList();
    }

    public OrderResponse findByIdAndOrderById(Integer id) {
        return orderRepository.findById(id)
                .map(mapper::toOrderResponse)
                .orElseThrow(() -> new BussinesException("Order not found"));
    }
}
