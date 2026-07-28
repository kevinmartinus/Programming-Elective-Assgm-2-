package com.feastorder.dao;

import com.feastorder.model.Order;

import java.sql.SQLException;
import java.util.List;

// Contract for anything that can create/read orders and their items
public interface OrderRepository {

    public int createOrder(Order order) throws SQLException;

    public List<Order> getOrdersByUser(int userId) throws SQLException;

    public List<Order> getAllOrders() throws SQLException;

    public Order getOrderById(int orderId) throws SQLException;

    public boolean updateOrderStatus(int orderId, String status) throws SQLException;
}
