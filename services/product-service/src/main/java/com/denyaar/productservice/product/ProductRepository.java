/**
 * Created by tendaimupezeni for e-commerce-app
 * Date: 6/8/24
 * Time: 11:05 PM
 */

package com.denyaar.productservice.product;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ProductRepository extends JpaRepository<Product, Integer> {
}
