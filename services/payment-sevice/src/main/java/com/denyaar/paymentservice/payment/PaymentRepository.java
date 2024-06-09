/**
 * Created by tendaimupezeni for e-commerce-app
 * Date: 6/9/24
 * Time: 9:42 PM
 */

package com.denyaar.paymentservice.payment;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface PaymentRepository extends JpaRepository<Payment, Integer>{
}
