/**
 * Created by tendaimupezeni for e-commerce-app
 * Date: 6/8/24
 * Time: 9:41 PM
 */

package com.denyaar.customerservice;

public record CustomerResponse(
        String id,
        String firstName,
        String latsName,
        String email,
        Address address
) {

}
