package com.feastorder.servlet;

import com.feastorder.dao.MenuDAO;
import com.feastorder.model.MenuItem;
import com.feastorder.model.OrderItem;
import com.feastorder.model.User;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/** Manages the shopping cart, stored as a List<OrderItem> in the session. */
@WebServlet("/cart")
public class CartServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    public static final String CART_SESSION_KEY = "cart";

    private final MenuDAO menuDAO = new MenuDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/jsp/user/cart.jsp").forward(request, response);
    }

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

        List<OrderItem> cart = (List<OrderItem>) session.getAttribute(CART_SESSION_KEY);
        if (cart == null) {
            cart = new ArrayList<>();
            session.setAttribute(CART_SESSION_KEY, cart);
        }

        String action = request.getParameter("action");
        if (action == null) {
            action = "";
        }

        switch (action) {
            case "add" -> handleAdd(request, cart);
            case "remove" -> handleRemove(request, cart);
            case "update" -> handleUpdate(request, cart);
            case "clear" -> cart.clear();
            default -> request.setAttribute("error", "Unknown cart action.");
        }

        response.sendRedirect(request.getContextPath() + "/cart");
    }

    private void handleAdd(HttpServletRequest request, List<OrderItem> cart) throws ServletException {
        try {
            int itemId = Integer.parseInt(request.getParameter("itemId"));
            int quantity = parsePositiveInt(request.getParameter("quantity"), 1);
            String addOns = request.getParameter("addOns");

            MenuItem menuItem = menuDAO.getMenuItemById(itemId);
            if (menuItem == null) {
                return;
            }

            OrderItem orderItem = new OrderItem(menuItem.getItemId(), menuItem.getName(),
                    quantity, addOns, menuItem.getPrice());
            cart.add(orderItem);
        } catch (NumberFormatException e) {
            // ignore malformed itemId/quantity, nothing added
        } catch (SQLException e) {
            throw new ServletException("Database error adding to cart", e);
        }
    }

    private void handleRemove(HttpServletRequest request, List<OrderItem> cart) {
        int index = parsePositiveInt(request.getParameter("index"), -1);
        if (index >= 0 && index < cart.size()) {
            cart.remove(index);
        }
    }

    private void handleUpdate(HttpServletRequest request, List<OrderItem> cart) {
        int index = parsePositiveInt(request.getParameter("index"), -1);
        int quantity = parsePositiveInt(request.getParameter("quantity"), -1);
        if (index >= 0 && index < cart.size() && quantity > 0) {
            cart.get(index).setQuantity(quantity);
        }
    }

    private int parsePositiveInt(String value, int fallback) {
        try {
            return value == null ? fallback : Integer.parseInt(value.trim());
        } catch (NumberFormatException e) {
            return fallback;
        }
    }
}
