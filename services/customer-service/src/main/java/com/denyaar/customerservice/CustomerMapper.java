/**
 * Created by tendaimupezeni for e-commerce-app
 * Date: 6/8/24
 * Time: 9:22 PM
 */

package com.denyaar.customerservice;

import org.springframework.stereotype.Service;

@Service

public class CustomerMapper {
    public Customer toCustomer(CustomerRequest request) {

        if(request == null)
            return null;

        return Customer.builder()
                .id(request.id())
                .firstName(request.firstName())
                .latsName(request.latsName())
                .email(request.email())
                .address(Address.builder()
                        .street(request.address().getStreet())
                        .houseNumber(request.address().getHouseNumber())
                        .zipCode(request.address().getZipCode())
                        .build())
                .build();
    }

    public CustomerResponse fromCustomer(Customer customer) {

            if(customer == null)
                return null;

            return new CustomerResponse(
                    customer.getId(),
                    customer.getFirstName(),
                    customer.getLatsName(),
                    customer.getEmail(),
                    Address.builder()
                            .street(customer.getAddress().getStreet())
                            .houseNumber(customer.getAddress().getHouseNumber())
                            .zipCode(customer.getAddress().getZipCode())
                            .build()
            );
    }
}
