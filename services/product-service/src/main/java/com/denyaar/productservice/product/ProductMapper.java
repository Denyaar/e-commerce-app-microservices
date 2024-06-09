/**
 * Created by tendaimupezeni for e-commerce-app
 * Date: 6/9/24
 * Time: 12:35 PM
 */

package com.denyaar.productservice.product;

import com.denyaar.productservice.category.Category;
import org.springframework.stereotype.Service;

@Service
public class ProductMapper {
    public Product toProduct(ProductRequest product) {
        return Product.builder()
                .id(product.id())
                .name(product.name())
                .price(product.price())
                .availableQuantity(product.availableQuantity())
                .description(product.description())
                .category(Category.builder()
                        .id(product.categoryId())
                        .build()
                )
                .build();
    }

    public ProductResponse toProductResponse(Product product) {
        return  new ProductResponse(
                product.getId(),
                product.getName(),
                product.getDescription(),
                product.getPrice(),
                product.getAvailableQuantity(),
                product.getCategory().getId(),
                product.getCategory().getName(),
                product.getCategory().getDescription());
    }

    public ProductPurchaseResponse toProductPurchaseResponse(Product product, double quantity) {
        return new ProductPurchaseResponse(
                product.getId(),
                product.getName(),
                product.getDescription(),
                product.getPrice(),
                quantity
        );
    }
}
