/**
 * Created by tendaimupezeni for e-commerce-app
 * Date: 6/8/24
 * Time: 9:07 PM
 */

package com.denyaar.customerservice;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.mongodb.core.mapping.Document;

@Document
@AllArgsConstructor
@NoArgsConstructor
@Builder
@Data
public class Customer {

    private String id;
    private String firstName;
    private String latsName;
    private String email;
    private Address address;

}
