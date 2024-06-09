/**
 * Created by tendaimupezeni for e-commerce-app
 * Date: 6/9/24
 * Time: 11:07 PM
 */

package com.denyaar.notificationservice.kafka.order;

public record Customer(
        Integer id,
        String firstName,
        String lastName,

        String email
) {
}
