/**
 * Created by tendaimupezeni for e-commerce-app
 * Date: 6/8/24
 * Time: 9:14 PM
 */

package com.denyaar.customerservice;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotNull;

public record CustomerRequest(
        @NotNull(message = "First name is required")
        String firstName,
        String id,
        @NotNull(message = "Last name is required")
        String lastName,
        @NotNull(message = "Email name is required")
        @Email(message = "Email is not valid")
        String email,
        Address address
) {
}
