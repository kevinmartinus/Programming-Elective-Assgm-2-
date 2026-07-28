package com.feastorder.servlet;

import com.feastorder.dao.OrderDAO;
import com.feastorder.model.Order;
import com.feastorder.model.User;

import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

// Lets an admin view all customer orders (user info, items, total, time)
@WebServlet("/admin/orders")
public class AdminOrderServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final OrderDAO orderDAO = new OrderDAO();

    // Loads every order, computes stats, and applies the status filter/sort
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String statusFilter = request.getParameter("status");
        if (statusFilter == null || statusFilter.isBlank()) {
            statusFilter = "ALL";
        }
        String sortBy = request.getParameter("sort");
        if (sortBy == null || sortBy.isBlank()) {
            sortBy = "newest";
        }

        try {
            List<Order> allOrders = orderDAO.getAllOrders();

            request.setAttribute("totalOrders", allOrders.size());
            request.setAttribute("todayOrders", countToday(allOrders));
            request.setAttribute("pendingOrders", countByStatus(allOrders, "PENDING"));
            request.setAttribute("totalRevenue", sumRevenue(allOrders));

            List<Order> visibleOrders = filterByStatus(allOrders, statusFilter);
            sortOrders(visibleOrders, sortBy);

            request.setAttribute("orders", visibleOrders);
            request.setAttribute("statusFilter", statusFilter);
            request.setAttribute("sortBy", sortBy);
        } catch (SQLException e) {
            throw new ServletException("Database error loading orders", e);
        }

        request.getRequestDispatcher("/WEB-INF/jsp/admin/viewOrders.jsp").forward(request, response);
    }

    // Updates one order status, then redirects back preserving the current filter/sort.
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        if ("updateStatus".equals(request.getParameter("action"))) {
            try {
                int orderId = Integer.parseInt(request.getParameter("orderId"));
                orderDAO.updateOrderStatus(orderId, request.getParameter("status"));
            } catch (NumberFormatException e) {
                // ignore malformed orderId, nothing updated
            } catch (SQLException e) {
                throw new ServletException("Database error updating order status", e);
            }
        }

        String statusFilter = request.getParameter("currentStatusFilter");
        String sortBy = request.getParameter("currentSortBy");
        response.sendRedirect(request.getContextPath() + "/admin/orders?status="
                + (statusFilter != null ? statusFilter : "ALL")
                + "&sort=" + (sortBy != null ? sortBy : "newest"));
    }

    // Keeps only orders matching the given status, or all of them if "ALL"
    private List<Order> filterByStatus(List<Order> orders, String statusFilter) {
        if ("ALL".equals(statusFilter)) {
            return new ArrayList<>(orders);
        }
        return orders.stream()
                .filter(o -> statusFilter.equals(o.getStatus()))
                .collect(Collectors.toList());
    }

    // Sorts the given list in place per the "sort" dropdown's selected option.
    private void sortOrders(List<Order> orders, String sortBy) {
        Comparator<Order> comparator = switch (sortBy) {
            case "oldest" -> Comparator.comparing(Order::getOrderTime);
            case "highest_total" -> Comparator.comparingDouble(Order::getTotalPrice).reversed();
            case "lowest_total" -> Comparator.comparingDouble(Order::getTotalPrice);
            default -> Comparator.comparing(Order::getOrderTime).reversed();
        };
        orders.sort(comparator);
    }

    // Counts orders placed today, for the dashboard-style stat card.
    private long countToday(List<Order> orders) {
        LocalDate today = LocalDate.now();
        return orders.stream()
                .filter(o -> o.getOrderTime() != null
                        && o.getOrderTime().toLocalDateTime().toLocalDate().equals(today))
                .count();
    }

    private long countByStatus(List<Order> orders, String status) {
        return orders.stream().filter(o -> status.equals(o.getStatus())).count();
    }

    private double sumRevenue(List<Order> orders) {
        return orders.stream().mapToDouble(Order::getTotalPrice).sum();
    }

    // Checks whether the current session belongs to a logged-in admin.
    private boolean isAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        return user != null && user.isAdmin();
    }
}
