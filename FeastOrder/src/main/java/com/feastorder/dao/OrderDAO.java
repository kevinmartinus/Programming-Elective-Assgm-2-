package com.feastorder.dao;

import com.feastorder.model.Order;

/**
 * DAO: OrderDAO
 * ------------------------------------------------------------
 * All SQL related to `orders` and `order_items` tables.
 *
 * TODO for your team, implement:
 *
 * 1. int createOrder(Order order)
 *    - INSERT INTO orders (...) VALUES (...)
 *    - Then loop through order.getItems() and INSERT each into order_items
 *    - Wrap both inserts in a transaction (conn.setAutoCommit(false)) so
 *      you never save a half-completed order
 *    - Return the generated order ID (useful for the confirmation page)
 *
 * 2. List<Order> getOrdersByUser(int userId)
 *    - For a customer's own order history
 *
 * 3. List<Order> getAllOrders()
 *    - For the Admin Dashboard "view customer orders" feature
 *    - Should include user info, items, total price, and time (per rubric)
 *
 * 4. Order getOrderById(int orderId)
 *    - Used to build the order confirmation page
 *
 * Maps to rubric "2c Dynamic Order Processing" and part of "2b Admin System".
 */
public class OrderDAO {

    // TODO: implement methods described above

}
