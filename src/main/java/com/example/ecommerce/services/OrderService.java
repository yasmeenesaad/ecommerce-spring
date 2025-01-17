package com.example.ecommerce.services;

import com.example.ecommerce.dtos.OrderRequestDTO;
import com.example.ecommerce.dtos.OrderViewDTO;
import com.example.ecommerce.dtos.SubProductDTO;
import com.example.ecommerce.enums.Status;
import com.example.ecommerce.exceptions.OrderProcessError;
import com.example.ecommerce.mappers.OrderMapperStruct;
import com.example.ecommerce.models.*;
import com.example.ecommerce.repositories.CartItemsRepository;
import com.example.ecommerce.repositories.CustomerRepository;
import com.example.ecommerce.repositories.OrderRepository;
import com.example.ecommerce.repositories.SubProductRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.*;
import java.util.stream.Collectors;

@Service
public class OrderService {
    private final OrderMapperStruct orderMapperStruct;
    private final OrderRepository orderRepository ;
    private final SubProductRepository subProductRepository;
    private final CustomerRepository customerRepository;
    private final CartItemsRepository cartRepository;

    @Autowired
    public OrderService(OrderRepository orderRepository, SubProductRepository subProductRepository, CustomerRepository customerRepository, OrderMapperStruct orderMapperStruct
            , CartItemsRepository cartRepository) {
        this.orderRepository = orderRepository;
        this.subProductRepository = subProductRepository;
        this.customerRepository = customerRepository;
        this.orderMapperStruct = orderMapperStruct;
        this.cartRepository = cartRepository;
    }
    private BigDecimal decreaseCustomerCreditLimit(Customer customer, CartItemsService cartService){
        return customer.getCreditLimit().subtract(cartService.getTotalPrice());
    }
    private List<SubProductDTO> convertCartServiceMapToList(CartItemsService cartService){
        return cartService.getItems().keySet().stream().collect(Collectors.toList());
    }
    public Order createOrder(OrderRequestDTO orderRequestDTO) {
        Customer customer = customerRepository.findById(orderRequestDTO.getCustomerId())
                .orElseThrow(() -> new RuntimeException("Customer not found"));

        Order order = new Order();
        order.setCustomer(customer);
        Set<OrderItem> orderItems = orderRequestDTO.getOrderItems().stream().map(itemDTO -> {
            SubProduct subProduct = subProductRepository.findById(itemDTO.getSubProductId())
                    .orElseThrow(() -> new RuntimeException("SubProduct not found"));
            OrderItem orderItem = new OrderItem();
            orderItem.setSubProduct(subProduct);
            orderItem.setOrder(order);
            orderItem.setQuantity(itemDTO.getQuantity());
            orderItem.setPrice(itemDTO.getPrice() != null ? itemDTO.getPrice() : BigDecimal.ZERO); // Default price if null

            return orderItem;
        }).collect(Collectors.toSet());
        order.setOrderItems(orderItems);

        // Save the order and return it
        return orderRepository.save(order);
    }
    private boolean hasStockErrors(List<SubProductDTO> subProductList, OrderProcessError orderProcessError) {
        for (SubProductDTO subProductDTO : subProductList) {
            SubProduct subProduct = subProductRepository.findById(subProductDTO.getId()).get();
            if (subProductDTO.getQuantity() > subProduct.getStock()) {
                orderProcessError.setSubProductDTO(subProductDTO);
                return true;
            }
        }
        return false;
    }
    private boolean isOrderValid(CartItemsService cartService, BigDecimal remainingCreditLimit) {
        return cartService != null && remainingCreditLimit.compareTo(BigDecimal.ZERO) > 0;
    }
    private Order createPendingOrder(Customer customer) {
        Order order = new Order();
        order.setCustomer(customer);
        order.setCreatedAt(new Date());
        order.setStatus(Status.PENDING);
        orderRepository.save(order);
        return order;
    }
    private Set<OrderItem> createOrderItems(List<SubProductDTO> subProductList, CartItemsService cartService, Order order, OrderProcessError orderProcessError) {
        Set<OrderItem> orderItems = new HashSet<>();

        for (SubProductDTO subProductDTO : subProductList) {
            SubProduct subProduct = subProductRepository.findById(subProductDTO.getId()).get();

            if (subProductDTO.getQuantity() > subProduct.getStock()) {
                orderProcessError.setSubProductDTO(subProductDTO);
                return orderItems;
            }

            OrderItem orderItem = new OrderItem();
            orderItem.setSubProduct(subProduct);
            orderItem.setOrder(order);
            orderItem.setQuantity(cartService.getQuantityOfSubProduct(subProductDTO));
            orderItem.setPrice(subProductDTO.getPrice());
            orderItems.add(orderItem);

            updateSubProductStock(subProduct, subProductDTO, cartService);
        }

        return orderItems;
    }
    private void updateSubProductStock(SubProduct subProduct, SubProductDTO subProductDTO, CartItemsService cartService) {
        int newStock = subProduct.getStock() - cartService.getQuantityOfSubProduct(subProductDTO);
        subProduct.setStock(newStock);
        subProductRepository.save(subProduct);
    }
    private void finalizeOrder(Order order, Set<OrderItem> orderItems, Customer customer, CartItemsService cartService) {
        order.getOrderItems().clear();
        order.getOrderItems().addAll(orderItems);

        BigDecimal totalPrice = cartService.getTotalPrice();
        customer.setCreditLimit(customer.getCreditLimit().subtract(totalPrice));

        clearCustomerShoppingCart(customer);
        customerRepository.save(customer);
    }
    private void clearCustomerShoppingCart(Customer customer) {
        List<CartItems> cartItems = cartRepository.findByCustomer_Id(customer.getId());
        if (!cartItems.isEmpty()) {
            customer.getShoppingCart().clear();
        }
    }
    public OrderProcessError createOrder(CartItemsService cartService, Customer customer) {
        BigDecimal remainingCustomerCreditLimit = decreaseCustomerCreditLimit(customer,cartService);
        List<SubProductDTO> subProductList = convertCartServiceMapToList(cartService);
        OrderProcessError orderProcessError = new OrderProcessError();
        if (hasStockErrors(subProductList, orderProcessError)) {
            return orderProcessError;
        }

        if (isOrderValid(cartService, remainingCustomerCreditLimit)) {
            Order order = createPendingOrder(customer);
            Set<OrderItem> orderItems = createOrderItems(subProductList, cartService, order, orderProcessError);

            if (orderProcessError.getSubProductDTO() != null) {
                return orderProcessError;
            }

            finalizeOrder(order, orderItems, customer, cartService);
            orderProcessError.setOrder(order);
            orderProcessError.setSubProductDTO(null);
        }
        return orderProcessError;
    }

    public List<OrderViewDTO> getAllOrdersOfSpecificCustomer(Integer customerId) {
        List<Order> orders = orderRepository.findOrdersByCustomerId(customerId);
        return orders.stream().map(orderMapperStruct::toDTO).collect(Collectors.toList());
    }
    public void updateOrderStatus(Integer id, Status status) {
        int result = orderRepository.updateOrderStatus(id, status.name());
    }

    public OrderViewDTO getOrderById(Integer orderId) {
        return orderMapperStruct.toDTO(orderRepository.findOrderById(orderId));
    }

    public Order saveOrder(Order order) {
        orderRepository.save(order);
        return order;
    }
}