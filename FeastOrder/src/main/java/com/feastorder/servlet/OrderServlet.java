package com.feastorder.servlet;

import com.feastorder.dao.OrderDAO;
import com.feastorder.model.Order;
import com.feastorder.model.OrderItem;
import com.feastorder.model.User;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/** Finalizes checkout: turns the session cart into a persisted order. */
@WebServlet("/placeOrder")
public class OrderServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    @SuppressWarnings("unchecked")
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        List<OrderItem> cart = (List<OrderItem>) session.getAttribute(CartServlet.CART_SESSION_KEY);
        if (cart == null || cart.isEmpty()) {
            request.setAttribute("error", "Your cart is empty.");
            request.getRequestDispatcher("/WEB-INF/jsp/user/cart.jsp").forward(request, response);
            return;
        }
        for (OrderItem item : cart) {
            if (item.getQuantity() <= 0) {
                request.setAttribute("error", "Quantities must be positive.");
                request.getRequestDispatcher("/WEB-INF/jsp/user/cart.jsp").forward(request, response);
                return;
            }
        }

        Order order = new Order();
        order.setUserId(user.getUserId());
        order.setStatus("Pending");
        order.setItems(cart);
        order.recalculateTotal();

        try {
            orderDAO.createOrder(order);
        } catch (SQLException e) {
            throw new ServletException("Database error placing order", e);
        }

        session.removeAttribute(CartServlet.CART_SESSION_KEY);

        request.setAttribute("order", order);
        request.getRequestDispatcher("/confirmation.jsp").forward(request, response);
    }
}
