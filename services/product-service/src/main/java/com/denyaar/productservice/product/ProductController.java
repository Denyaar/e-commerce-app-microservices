/**
 * Created by tendaimupezeni for e-commerce-app
 * Date: 6/8/24
 * Time: 11:05 PM
 */

package com.denyaar.productservice.product;

import jakarta.validation.Valid;
import lombok.AllArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@AllArgsConstructor
@RequestMapping("/api/v1/products")
public class ProductController {

    private final  ProductService productService;


    @PostMapping
    public ResponseEntity<Integer> createProduct(@RequestBody @Valid ProductRequest product) {
        return ResponseEntity.ok(productService.createProduct(product));
    }

    @PostMapping("/purchase")
    public ResponseEntity<List<ProductPurchaseResponse>> purchaseProduct(@RequestBody @Valid List<ProductPurchaseRequest> products) {
        return ResponseEntity.ok(productService.purchaseProduct(products));
    }

    @GetMapping("/{product-id}")
    public ResponseEntity<ProductResponse> findById(@PathVariable("product-id") Integer productId) {
        return ResponseEntity.ok(productService.findById(productId));
    }

    @GetMapping
    public ResponseEntity<List<ProductResponse>> findAll() {
        return ResponseEntity.ok(productService.findAll());
    }

}
