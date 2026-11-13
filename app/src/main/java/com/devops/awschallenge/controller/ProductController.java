
package com.devops.awschallenge.controller;

import com.devops.awschallenge.model.Product;
import com.devops.awschallenge.service.ProductService;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/products")
public class ProductController {

    private final ProductService productService;

    public ProductController(ProductService productService) {
        this.productService = productService;
    }

    @GetMapping
    public ResponseEntity<List<Product>> getAll() {
        return ResponseEntity.ok(productService.findAll());
    }

    @GetMapping("/{id}")
    public ResponseEntity<Product> getById(@PathVariable Long id) {

        Product product = productService.findById(id);

        if (product == null) {
            return ResponseEntity.notFound().build();
        }

        return ResponseEntity.ok(product);
    }

    @PostMapping
    public ResponseEntity<?> create(@RequestBody Product product) {

        if (!isValid(product)) {
            return ResponseEntity.badRequest().body(
                    Map.of("error", "Nombre, precio y stock deben ser validos")
            );
        }

        Product created = productService.create(product);

        return ResponseEntity.status(HttpStatus.CREATED).body(created);
    }

    @PutMapping("/{id}")
    public ResponseEntity<?> update(
            @PathVariable Long id,
            @RequestBody Product product) {

        if (!isValid(product)) {
            return ResponseEntity.badRequest().body(
                    Map.of("error", "Nombre, precio y stock deben ser validos")
            );
        }

        Product updated = productService.update(id, product);

        if (updated == null) {
            return ResponseEntity.notFound().build();
        }

        return ResponseEntity.ok(updated);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {

        boolean deleted = productService.delete(id);

        if (!deleted) {
            return ResponseEntity.notFound().build();
        }

        return ResponseEntity.noContent().build();
    }

    private boolean isValid(Product product) {

        if (product == null) {
            return false;
        }

        if (product.getName() == null ||
                product.getName().isBlank()) {
            return false;
        }

        BigDecimal price = product.getPrice();
        Integer stock = product.getStock();

        return price != null
                && price.compareTo(BigDecimal.ZERO) >= 0
                && stock != null
                && stock >= 0;
    }
}
