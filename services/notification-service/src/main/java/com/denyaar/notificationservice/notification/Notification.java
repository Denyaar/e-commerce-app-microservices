/**
 * Created by tendaimupezeni for e-commerce-app
 * Date: 6/9/24
 * Time: 10:58 PM
 */

package com.denyaar.notificationservice.notification;

import com.denyaar.notificationservice.kafka.order.OrderConfirmation;
import com.denyaar.notificationservice.kafka.payment.PaymentConfirmation;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.time.LocalDateTime;

@Builder
@AllArgsConstructor
@NoArgsConstructor
@Document
@Data
public class Notification {
    @Id
    private String id;
    private NotificationType notificationType;
    private LocalDateTime notificationDate;
    private OrderConfirmation orderConfirmation;
    private PaymentConfirmation paymentConfirmation;
}
