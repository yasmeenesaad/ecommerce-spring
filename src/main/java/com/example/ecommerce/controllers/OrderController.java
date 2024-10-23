package com.example.ecommerce.controllers;

import com.example.ecommerce.enums.Status;
import com.example.ecommerce.services.OrderService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class OrderController {
    OrderService orderService;

    @Autowired
    public OrderController(OrderService orderService) {
        this.orderService = orderService;
    }
    @PostMapping("/{orderId}/status/{status}") // Status is now part of the URL
    public ResponseEntity<Void> updateOrderStatus(@PathVariable Integer orderId, @PathVariable String status) {
        try {
            Status orderStatus = Status.valueOf(status.toUpperCase());
            orderService.updateOrderStatus(orderId, orderStatus);
            return ResponseEntity.ok().build();
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
}