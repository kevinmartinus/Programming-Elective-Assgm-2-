package com.feastorder.servlet;

import com.feastorder.dao.MenuDAO;
import com.feastorder.model.Category;
import com.feastorder.model.MenuItem;
import com.feastorder.model.User;

import java.io.IOException;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/** Admin CRUD for menu items and categories. */
@WebServlet("/admin/menu")
public class AdminMenuServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final MenuDAO menuDAO = new MenuDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            request.setAttribute("menuItems", menuDAO.getAllMenuItems());
            request.setAttribute("categories", menuDAO.getAllCategories());
        } catch (SQLException e) {
            throw new ServletException("Database error loading menu management data", e);
        }

        request.getRequestDispatcher("/WEB-INF/jsp/admin/manageMenu.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            action = "";
        }

        try {
            switch (action) {
                case "add" -> menuDAO.addMenuItem(readMenuItem(request));
                case "update" -> menuDAO.updateMenuItem(readMenuItem(request));
                case "delete" -> menuDAO.deleteMenuItem(parseInt(request.getParameter("itemId")));
                case "addCategory" -> {
                    Category category = new Category();
                    category.setCategoryName(request.getParameter("categoryName"));
                    category.setDescription(request.getParameter("description"));
                    menuDAO.addCategory(category);
                }
                case "deleteCategory" -> menuDAO.deleteCategory(parseInt(request.getParameter("categoryId")));
                default -> { /* unknown action, ignore */ }
            }
        } catch (SQLException e) {
            throw new ServletException("Database error updating menu", e);
        }

        // Post-Redirect-Get: avoid resubmitting the form on refresh
        response.sendRedirect(request.getContextPath() + "/admin/menu");
    }

    private MenuItem readMenuItem(HttpServletRequest request) {
        MenuItem item = new MenuItem();
        String itemId = request.getParameter("itemId");
        if (itemId != null && !itemId.isBlank()) {
            item.setItemId(parseInt(itemId));
        }
        item.setCategoryId(parseInt(request.getParameter("categoryId")));
        item.setName(request.getParameter("name"));
        item.setDescription(request.getParameter("description"));
        item.setNutritionalInfo(request.getParameter("nutritionalInfo"));
        item.setPrice(parseDouble(request.getParameter("price")));
        item.setImageUrl(request.getParameter("imageUrl"));
        item.setRating(parseDouble(request.getParameter("rating")));
        item.setAvailable("on".equalsIgnoreCase(request.getParameter("available"))
                || "true".equalsIgnoreCase(request.getParameter("available")));
        return item;
    }

    private int parseInt(String value) {
        try {
            return Integer.parseInt(value.trim());
        } catch (NumberFormatException | NullPointerException e) {
            return 0;
        }
    }

    private double parseDouble(String value) {
        try {
            return Double.parseDouble(value.trim());
        } catch (NumberFormatException | NullPointerException e) {
            return 0.0;
        }
    }

    private boolean isAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        return user != null && user.isAdmin();
    }
}
