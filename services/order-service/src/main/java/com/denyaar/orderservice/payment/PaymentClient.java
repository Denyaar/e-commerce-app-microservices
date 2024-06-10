/**
 * Created by tendaimupezeni for e-commerce-app
 * Date: 6/9/24
 * Time: 10:25 PM
 */

package com.denyaar.orderservice.payment;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
@FeignClient(
        name = "payment-service",
        url = "${application.config.payment-url}"
)
public interface PaymentClient {
    @PostMapping
    Integer requestPayment(@RequestBody PaymentRequest paymentRequest);
}
