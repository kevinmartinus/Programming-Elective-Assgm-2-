package com.feastorder.model;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

/**
 * Represents a row in the `orders` table, plus the list of items in that
 * order (which live in the `order_items` join table in the DB).
 */
public class Order {

    private int orderId;
    private int userId;
    private String username;     // denormalized, for admin order list
    private String email;        // denormalized, for admin order list
    private double totalPrice;
    private String status;
    private Timestamp orderTime;
    private List<OrderItem> items = new ArrayList<>();

    public Order() {
    }

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public double getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(double totalPrice) {
        this.totalPrice = totalPrice;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getOrderTime() {
        return orderTime;
    }

    public void setOrderTime(Timestamp orderTime) {
        this.orderTime = orderTime;
    }

    public List<OrderItem> getItems() {
        return items;
    }

    public void setItems(List<OrderItem> items) {
        this.items = items;
    }

    public void recalculateTotal() {
        this.totalPrice = items.stream().mapToDouble(OrderItem::getSubtotal).sum();
    }
}
