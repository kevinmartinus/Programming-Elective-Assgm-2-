package com.feastorder.servlet;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * SERVLET: AdminOrderServlet
 * ------------------------------------------------------------
 * Lets admin view all customer orders (user info, items, total, time).
 * URL mapping suggestion: /admin/orders
 *
 * TODO for your team:
 *   1. Same admin access-control check as AdminMenuServlet (copy that pattern)
 *   2. Call OrderDAO.getAllOrders()
 *   3. request.setAttribute("orders", orders);
 *   4. Forward to /WEB-INF/jsp/admin/viewOrders.jsp
 *
 * Maps to rubric "2b Admin System & Database Connectivity"
 * ("View customer orders: user info, items, total price, time").
 */
@WebServlet("/admin/orders")
public class AdminOrderServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // TODO: implement access check + load orders + forward, as described above
    }
}
