/**
 * Created by tendaimupezeni for e-commerce-app
 * Date: 6/9/24
 * Time: 9:38 PM
 */

package com.denyaar.paymentservice.payment;

import com.denyaar.paymentservice.notification.NotificationProducer;
import com.denyaar.paymentservice.notification.PaymentNotificationRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class PaymentService {

    private  final  PaymentRepository paymentRepository;
    private final PaymentMapper paymentMapper;
    private final NotificationProducer notificationProducer;

    public Integer createPayment(PaymentRequest paymentRequest) {
            var payment  = paymentRepository.save(paymentMapper.toPayment(paymentRequest));
            notificationProducer.sendPaymentNotification(new PaymentNotificationRequest(
                    paymentRequest.orderReference(),
                    paymentRequest.amount(),
                    paymentRequest.paymentMethod(),
                    paymentRequest.customer().firstName(),
                    paymentRequest.customer().lastName(),
                    paymentRequest.customer().email()
            ));

            return payment.getId();

    }
}
