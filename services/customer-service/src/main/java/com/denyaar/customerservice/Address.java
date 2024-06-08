/**
 * Created by tendaimupezeni for e-commerce-app
 * Date: 6/8/24
 * Time: 9:09 PM
 */

package com.denyaar.customerservice;


import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.validation.annotation.Validated;

@Document
@AllArgsConstructor
@NoArgsConstructor
@Builder
@Data
@Validated
public class Address {

        private String street;
        private String houseNumber;
        private String zipCode;
}
