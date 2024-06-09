/**
 * Created by tendaimupezeni for e-commerce-app
 * Date: 6/9/24
 * Time: 4:29 PM
 */

package com.denyaar.orderservice.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.client.RestTemplate;

@Configuration
public class RestTemplateConfig {
    @Bean
    public RestTemplate restTemplate() {
        return new RestTemplate();
    }
}
