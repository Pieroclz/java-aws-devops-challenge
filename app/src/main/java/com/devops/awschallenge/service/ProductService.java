
package com.devops.awschallenge.service;

import com.devops.awschallenge.model.Product;

import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicLong;

@Service
public class ProductService {

    private final ConcurrentHashMap<Long, Product> products =
            new ConcurrentHashMap<>();

    private final AtomicLong sequence = new AtomicLong(0);

    public synchronized Product create(Product product) {

        long id = sequence.incrementAndGet();

        Product newProduct = new Product(
                id,
                product.getName(),
                product.getPrice(),
                product.getStock()
        );

        products.put(id, newProduct);

        return copy(newProduct);
    }

    public List<Product> findAll() {

        List<Product> result = new ArrayList<>();

        products.values().forEach(product ->
                result.add(copy(product))
        );

        result.sort((a, b) -> Long.compare(a.getId(), b.getId()));

        return result;
    }

    public Product findById(Long id) {

        Product product = products.get(id);

        return product == null ? null : copy(product);
    }

    public synchronized Product update(Long id, Product product) {

        if (!products.containsKey(id)) {
            return null;
        }

        Product updated = new Product(
                id,
                product.getName(),
                product.getPrice(),
                product.getStock()
        );

        products.put(id, updated);

        return copy(updated);
    }

    public synchronized boolean delete(Long id) {
        return products.remove(id) != null;
    }

    private Product copy(Product product) {
        return new Product(
                product.getId(),
                product.getName(),
                product.getPrice(),
                product.getStock()
        );
    }
}
