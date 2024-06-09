/**
 * Created by tendaimupezeni for e-commerce-app
 * Date: 6/9/24
 * Time: 5:41 PM
 */

package com.denyaar.orderservice.kafka;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.kafka.clients.producer.KafkaProducer;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.kafka.support.KafkaHeaders;
import org.springframework.messaging.Message;
import org.springframework.messaging.support.MessageBuilder;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
@Slf4j
public class OrderProducer {

    private  final KafkaTemplate<String, OrderConfirmation> kafkaTemplate;
        public void sendOrderConfirmation(OrderConfirmation order) {
            log.info("Sending order confirmation to kafka topic");
            Message<OrderConfirmation> message = MessageBuilder
                    .withPayload(order)
                    .setHeader(KafkaHeaders.TOPIC , "order-topic")
                    .build();

            kafkaTemplate.send(message);
        }
}
