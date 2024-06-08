/**
 * Created by tendaimupezeni for e-commerce-app
 * Date: 6/8/24
 * Time: 9:15 PM
 */

package com.denyaar.customerservice;

import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

@Service
@AllArgsConstructor
public class CustomerService {
    private final CustomerRepository customerRepository;

    private final CustomerMapper customerMapper;

    public String createCustomer(CustomerRequest request) {
        var customer = customerRepository.save(customerMapper.toCustomer(request));
        return customer.getId();
    }


    public void updateCustomer(CustomerRequest request) {
        var customer = customerRepository.findById(request.id())
                .orElseThrow(() -> new RuntimeException("Customer not found"));
        customerRepository.save(mergeCustomer(customer, request));
    }

    private Customer mergeCustomer(Customer customer, CustomerRequest request) {

        return Customer.builder()
                .id(customer.getId())
                .firstName(Objects.nonNull(request.firstName()) ? request.firstName() : customer.getFirstName())
                .latsName(Objects.nonNull(request.latsName()) ? request.latsName() : customer.getLatsName())
                .email(Objects.nonNull(request.email()) ? request.email() : customer.getEmail())
                .address(Address.builder()
                        .street(Objects.nonNull(request.address()) && Objects.nonNull(request.address().getStreet()) ? request.address().getStreet() : customer.getAddress().getStreet())
                        .houseNumber(Objects.nonNull(request.address()) && Objects.nonNull(request.address().getHouseNumber()) ? request.address().getHouseNumber() : customer.getAddress().getHouseNumber())
                        .zipCode(Objects.nonNull(request.address()) && Objects.nonNull(request.address().getZipCode()) ? request.address().getZipCode() : customer.getAddress().getZipCode())
                        .build())
                .build();
    }

    public List<CustomerResponse> getCustomers() {

        return customerRepository.findAll().stream()
                .map(customerMapper::fromCustomer)
                .collect(Collectors.toList());
    }

    public Boolean customerExist(String customerId) {
        return customerRepository.existsById(customerId);
    }

    public CustomerResponse findById(String customerId) {
        return customerRepository.findById(customerId)
                .map(customerMapper::fromCustomer)
                .orElseThrow(() -> new RuntimeException("Customer not found"));
    }

    public void deleteCustomer(String customerId) {

        if(!customerRepository.existsById(customerId))
            throw new RuntimeException("Customer not found");

        customerRepository.deleteById(customerId);
    }
}
