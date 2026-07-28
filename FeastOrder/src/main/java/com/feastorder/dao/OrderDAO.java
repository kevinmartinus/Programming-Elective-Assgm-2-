package com.feastorder.dao;

import com.feastorder.model.Order;
import com.feastorder.model.OrderItem;
import com.feastorder.model.User;
import com.feastorder.util.HibernateUtil;

import org.hibernate.Session;
import org.hibernate.Transaction;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class OrderDAO implements OrderRepository {

    // Inserts the order and every item row as a single transaction. Handles the "Place Order" action: turns a customer's cart into a permanent order record
    public int createOrder(Order order) throws SQLException {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();

            if (order.getStatus() == null) {
                order.setStatus("PENDING");
            }
            session.persist(order); // generates order.orderId

            for (OrderItem item : order.getItems()) {
                item.setOrderId(order.getOrderId());
                session.persist(item);
            }

            tx.commit();
            return order.getOrderId();
        } catch (RuntimeException e) {
            if (tx != null) {
                tx.rollback();
            }
            throw e;
        }
    }

    // Returns a customer's own order history. lets a logged-in user see only the orders they placed, not anyone else
    public List<Order> getOrdersByUser(int userId) throws SQLException {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            List<Order> orders = session
                    .createQuery("from Order where userId = :userId order by orderTime desc", Order.class)
                    .setParameter("userId", userId)
                    .list();
            attachItems(session, orders);
            return orders;
        }
    }

    // Returns every order in the system, for the admin order list.
    public List<Order> getAllOrders() throws SQLException {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            List<Order> orders = session
                    .createQuery("from Order order by orderTime desc", Order.class)
                    .list();
            attachItems(session, orders);
            attachCustomerInfo(session, orders);
            return orders;
        }
    }

    // Retrieves one order right after checkout, for the order confirmation page a customer sees after placing an order
    public Order getOrderById(int orderId) throws SQLException {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Order order = session.get(Order.class, orderId);
            if (order == null) {
                return null;
            }
            List<Order> single = List.of(order);
            attachItems(session, single);
            attachCustomerInfo(session, single);
            return order;
        }
    }

    // Lets an admin update an order's status (e.g. mark it "Delivered"), part of the Admin & DB Connectivity requirement for managing orders
    public boolean updateOrderStatus(int orderId, String status) throws SQLException {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            Order order = session.get(Order.class, orderId);
            if (order == null) {
                tx.rollback();
                return false;
            }
            order.setStatus(status);
            session.merge(order);
            tx.commit();
            return true;
        } catch (RuntimeException e) {
            if (tx != null) {
                tx.rollback();
            }
            throw e;
        }
    }

    // Ensures every order shown to a user includes its actual food items,not just the order header - needed so the order/cart/confirmation pages can list what was actually bought
    private void attachItems(Session session, List<Order> orders) {
        if (orders.isEmpty()) {
            return;
        }
        List<Integer> orderIds = orders.stream().map(Order::getOrderId).toList();
        List<OrderItem> items = session
                .createQuery("from OrderItem where orderId in :orderIds", OrderItem.class)
                .setParameter("orderIds", orderIds)
                .list();

        Map<Integer, Order> ordersById = new HashMap<>();
        for (Order order : orders) {
            order.getItems().clear();
            ordersById.put(order.getOrderId(), order);
        }
        for (OrderItem item : items) {
            if (item.getQuantity() > 0) {
                item.setUnitPrice(item.getSubtotal() / item.getQuantity());
            }
            Order order = ordersById.get(item.getOrderId());
            if (order != null) {
                order.getItems().add(item);
            }
        }
    }

    // Ensures the admin order list shows who placed each order, since admins need to see customer identity alongside every order
    private void attachCustomerInfo(Session session, List<Order> orders) {
        for (Order order : orders) {
            User user = session.get(User.class, order.getUserId());
            if (user != null) {
                order.setCustomerName(user.getUsername());
                order.setCustomerEmail(user.getEmail());
            }
        }
    }
}
