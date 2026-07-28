package com.feastorder.servlet;

import com.feastorder.dao.MenuDAO;
import com.feastorder.dao.OrderDAO;
import com.feastorder.dao.UserDAO;
import com.feastorder.model.Order;
import com.feastorder.model.User;

import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

// Landing page after admin login: quick stats plus links to menu management and order viewing
@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final MenuDAO menuDAO = new MenuDAO();
    private final OrderDAO orderDAO = new OrderDAO();
    private final UserDAO userDAO = new UserDAO();

    // Shows the admin dashboard with quick stats, if the current session belongs to an admin
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        if (user == null || !user.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            List<Order> orders = orderDAO.getAllOrders();
            LocalDate today = LocalDate.now();
            long ordersToday = orders.stream()
                    .filter(o -> o.getOrderTime() != null
                            && o.getOrderTime().toLocalDateTime().toLocalDate().equals(today))
                    .count();

            request.setAttribute("totalMenuItems", menuDAO.getAllMenuItems().size());
            request.setAttribute("totalOrders", orders.size());
            request.setAttribute("totalOrdersToday", ordersToday);
            request.setAttribute("totalUsers", userDAO.countUsers());
        } catch (SQLException e) {
            request.setAttribute("statsError", "Could not load dashboard stats.");
        }

        request.getRequestDispatcher("/WEB-INF/jsp/admin/dashboard.jsp").forward(request, response);
    }
}
