/**
 * Created by tendaimupezeni for e-commerce-app
 * Date: 6/9/24
 * Time: 9:59 PM
 */

package com.denyaar.paymentservice.config;

import org.apache.kafka.clients.admin.NewTopic;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.kafka.config.TopicBuilder;

@Configuration
public class KafkaPaymentTopicConfiguration {
    @Bean
    public NewTopic paymentTopic() {
        return TopicBuilder.name("payment-topic")
                .build();
    }
}
