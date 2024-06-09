/**
 * Created by tendaimupezeni for e-commerce-app
 * Date: 6/8/24
 * Time: 11:05 PM
 */

package com.denyaar.productservice.product;

import com.denyaar.productservice.exceptions.ProductNotFoundException;
import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ProductService {

    private final ProductRepository productRepository;
    private final ProductMapper mapper;

    public Integer createProduct(ProductRequest product) {
        var prod = mapper.toProduct(product);
        return productRepository.save(prod).getId();
    }

    public List<ProductPurchaseResponse> purchaseProduct(List<ProductPurchaseRequest> products) {
        var productIds = products.stream()
                .map(ProductPurchaseRequest::productId)
                .toList();

        var productsToPurchase = productRepository.findAllById(productIds);

        if(productsToPurchase.size() != products.size()) {
            throw new ProductNotFoundException("Some Products not found");
        }

        var storesRequest =  products.stream()
                .sorted(Comparator.comparing(ProductPurchaseRequest::productId))
                .toList();

        var purchasedProducts  =  new ArrayList<ProductPurchaseResponse>();

        for (int i = 0; i < productsToPurchase.size(); i++) {
            var product = productsToPurchase.get(i);
            var request = storesRequest.get(i);

            if(product.getAvailableQuantity() < request.quantity()) {
                throw new ProductNotFoundException("Product Quantity not enough");
            }

            product.setAvailableQuantity(product.getAvailableQuantity() - request.quantity());
            productRepository.save(product);

            purchasedProducts.add(mapper.toProductPurchaseResponse(product, request.quantity()));
        }
        return purchasedProducts;
    }

    public ProductResponse findById(Integer productId) {
        return productRepository.findById(productId)
                .map(mapper::toProductResponse)
                .orElseThrow(() -> new EntityNotFoundException("Product not found"));
    }

    public List<ProductResponse> findAll() {
        return productRepository.findAll().stream()
                .map(mapper::toProductResponse)
                .collect(Collectors.toList());
    }
}
