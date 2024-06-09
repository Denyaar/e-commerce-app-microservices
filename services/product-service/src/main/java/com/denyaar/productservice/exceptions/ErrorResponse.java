/**
 * Created by tendaimupezeni for e-commerce-app
 * Date: 6/8/24
 * Time: 9:56 PM
 */

package com.denyaar.productservice.exceptions;

import java.util.Map;

public record ErrorResponse(
        Map<String, String> errors

) {
}
