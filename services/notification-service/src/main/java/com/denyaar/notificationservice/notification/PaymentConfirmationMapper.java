/**
 * Created by tendaimupezeni for e-commerce-app
 * Date: 6/9/24
 * Time: 11:19 PM
 */

package com.denyaar.notificationservice.notification;

import com.denyaar.notificationservice.kafka.order.OrderConfirmation;
import com.denyaar.notificationservice.kafka.payment.PaymentConfirmation;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;

@Service
public class PaymentConfirmationMapper {
    public Notification toNotification(Object paymentConfirmation) {

        return Notification.builder()
                .notificationType(NotificationType.PAYMENT_CONFIRMATION)
                .notificationDate(LocalDateTime.now())
                .paymentConfirmation((paymentConfirmation instanceof PaymentConfirmation) ?
                        (PaymentConfirmation) paymentConfirmation : null)
                .orderConfirmation((paymentConfirmation instanceof OrderConfirmation) ?
                        (OrderConfirmation) paymentConfirmation : null)
                .build();
    }
}
