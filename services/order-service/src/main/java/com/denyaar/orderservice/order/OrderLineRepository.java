/**
 * Created by tendaimupezeni for e-commerce-app
 * Date: 6/9/24
 * Time: 5:08 PM
 */

package com.denyaar.orderservice.order;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface OrderLineRepository extends JpaRepository<OrderLine, Integer> {
}
