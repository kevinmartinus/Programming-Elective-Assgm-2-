package com.feastorder.dao;

import com.feastorder.model.Order;
import com.feastorder.model.OrderItem;
import com.feastorder.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/** All SQL related to the `orders` and `order_items` tables. */
public class OrderDAO {

    /** Inserts the order and its items in one transaction; returns the generated order id. */
    public int createOrder(Order order) throws SQLException {
        String orderSql = "INSERT INTO orders (user_id, total_price, status) VALUES (?, ?, ?)";
        String itemSql = "INSERT INTO order_items (order_id, item_id, item_name, quantity, add_ons, subtotal) " +
                "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                int orderId;
                try (PreparedStatement ps = conn.prepareStatement(orderSql, Statement.RETURN_GENERATED_KEYS)) {
                    ps.setInt(1, order.getUserId());
                    ps.setDouble(2, order.getTotalPrice());
                    ps.setString(3, order.getStatus() != null ? order.getStatus() : "Pending");
                    ps.executeUpdate();
                    try (ResultSet keys = ps.getGeneratedKeys()) {
                        if (!keys.next()) {
                            throw new SQLException("Failed to obtain generated order id");
                        }
                        orderId = keys.getInt(1);
                    }
                }

                try (PreparedStatement ps = conn.prepareStatement(itemSql)) {
                    for (OrderItem item : order.getItems()) {
                        ps.setInt(1, orderId);
                        ps.setInt(2, item.getMenuItemId());
                        ps.setString(3, item.getItemName());
                        ps.setInt(4, item.getQuantity());
                        ps.setString(5, item.getAddOns());
                        ps.setDouble(6, item.getSubtotal());
                        ps.addBatch();
                    }
                    ps.executeBatch();
                }

                conn.commit();
                order.setOrderId(orderId);
                return orderId;
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            } finally {
                conn.setAutoCommit(true);
            }
        }
    }

    public List<Order> getOrdersByUser(int userId) throws SQLException {
        String sql = "SELECT * FROM orders WHERE user_id = ? ORDER BY order_time DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                return mapOrders(conn, rs);
            }
        }
    }

    public List<Order> getAllOrders() throws SQLException {
        String sql = "SELECT o.*, u.username, u.email FROM orders o " +
                "JOIN users u ON o.user_id = u.user_id ORDER BY o.order_time DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return mapOrders(conn, rs);
        }
    }

    public Order getOrderById(int orderId) throws SQLException {
        String sql = "SELECT o.*, u.username, u.email FROM orders o " +
                "JOIN users u ON o.user_id = u.user_id WHERE o.order_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                List<Order> orders = mapOrders(conn, rs);
                return orders.isEmpty() ? null : orders.get(0);
            }
        }
    }

    private List<Order> mapOrders(Connection conn, ResultSet rs) throws SQLException {
        boolean hasUserColumns = hasColumn(rs, "username");

        Map<Integer, Order> ordersById = new LinkedHashMap<>();
        while (rs.next()) {
            Order order = new Order();
            order.setOrderId(rs.getInt("order_id"));
            order.setUserId(rs.getInt("user_id"));
            order.setTotalPrice(rs.getDouble("total_price"));
            order.setStatus(rs.getString("status"));
            order.setOrderTime(rs.getTimestamp("order_time"));
            if (hasUserColumns) {
                order.setUsername(rs.getString("username"));
                order.setEmail(rs.getString("email"));
            }
            ordersById.put(order.getOrderId(), order);
        }

        if (ordersById.isEmpty()) {
            return new ArrayList<>();
        }

        String placeholders = String.join(",", ordersById.keySet().stream().map(String::valueOf).toList());
        String itemSql = "SELECT * FROM order_items WHERE order_id IN (" + placeholders + ")";
        try (PreparedStatement ps = conn.prepareStatement(itemSql);
             ResultSet itemRs = ps.executeQuery()) {
            while (itemRs.next()) {
                OrderItem item = new OrderItem();
                item.setOrderItemId(itemRs.getInt("order_item_id"));
                item.setOrderId(itemRs.getInt("order_id"));
                item.setMenuItemId(itemRs.getInt("item_id"));
                item.setItemName(itemRs.getString("item_name"));
                item.setQuantity(itemRs.getInt("quantity"));
                item.setAddOns(itemRs.getString("add_ons"));
                item.setSubtotal(itemRs.getDouble("subtotal"));

                Order order = ordersById.get(item.getOrderId());
                if (order != null) {
                    order.getItems().add(item);
                }
            }
        }

        return new ArrayList<>(ordersById.values());
    }

    private boolean hasColumn(ResultSet rs, String columnName) throws SQLException {
        var metaData = rs.getMetaData();
        for (int i = 1; i <= metaData.getColumnCount(); i++) {
            if (metaData.getColumnLabel(i).equalsIgnoreCase(columnName)) {
                return true;
            }
        }
        return false;
    }
}
