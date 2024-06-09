/**
 * Created by tendaimupezeni for e-commerce-app
 * Date: 6/9/24
 * Time: 11:13 PM
 */

package com.denyaar.notificationservice.kafka;

import com.denyaar.notificationservice.email.EmailService;
import com.denyaar.notificationservice.kafka.order.OrderConfirmation;
import com.denyaar.notificationservice.kafka.payment.PaymentConfirmation;
import com.denyaar.notificationservice.notification.NotificationRepository;
import com.denyaar.notificationservice.notification.PaymentConfirmationMapper;
import jakarta.mail.MessagingException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
@Slf4j
public class NotificationConsumer {

    private final NotificationRepository notificationRepository;
    private  final PaymentConfirmationMapper paymentConfirmationMapper;
    private  final EmailService emailService;
    @KafkaListener(topics = "payment-topic")
    public void consumePaymentSuccessNotification(PaymentConfirmation paymentConfirmation) throws MessagingException {
        log.info("Consuming  payment confirmation from payment topic :: {}", paymentConfirmation);
        notificationRepository.save(paymentConfirmationMapper.toNotification(paymentConfirmation));

        var customerName = paymentConfirmation.customerFirstName()+ " "+ paymentConfirmation.customerLastName();
        emailService.sendPaymentSuccessEmail(
                paymentConfirmation.customerEmail(),
                customerName,
                paymentConfirmation.amount(),
                paymentConfirmation.orderReference()
        );
    }

    @KafkaListener(topics = "order-topic")
    public void consumeOrderSuccessNotification(OrderConfirmation orderConfirmation) throws MessagingException {
        log.info("Consuming  order confirmation from order topic :: {}", orderConfirmation);
        notificationRepository.save(paymentConfirmationMapper.toNotification(orderConfirmation));

        var customerName = orderConfirmation.customer().firstName()+ " "+ orderConfirmation.customer().lastName();
        emailService.sendOrderSuccessEmail(
                orderConfirmation.customer().email(),
                customerName,
                orderConfirmation.amount(),
                orderConfirmation.orderReference(),
                orderConfirmation.products()
        );
    }
}
