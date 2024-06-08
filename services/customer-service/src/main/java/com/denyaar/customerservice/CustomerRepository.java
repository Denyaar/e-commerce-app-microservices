/**
 * Created by tendaimupezeni for e-commerce-app
 * Date: 6/8/24
 * Time: 9:20 PM
 */

package com.denyaar.customerservice;

import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface CustomerRepository extends MongoRepository<Customer, String> {
}
