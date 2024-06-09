/**
 * Created by tendaimupezeni for e-commerce-app
 * Date: 6/9/24
 * Time: 4:53 PM
 */

package com.denyaar.orderservice.order;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface OrderRepository  extends JpaRepository<Order, Integer> {
}
