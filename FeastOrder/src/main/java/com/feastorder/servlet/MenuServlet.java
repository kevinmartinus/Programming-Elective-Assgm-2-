package com.feastorder.servlet;

import com.feastorder.dao.MenuDAO;
import com.feastorder.model.Category;
import com.feastorder.model.MenuItem;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/** Loads menu items (all, or filtered by category) and forwards to menu.jsp. */
@WebServlet("/menu")
public class MenuServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final MenuDAO menuDAO = new MenuDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String categoryIdParam = request.getParameter("categoryId");

        try {
            List<MenuItem> items;
            if (categoryIdParam != null && !categoryIdParam.isBlank()) {
                int categoryId = Integer.parseInt(categoryIdParam);
                items = menuDAO.getMenuItemsByCategory(categoryId);
            } else {
                items = menuDAO.getAllMenuItems();
            }
            List<Category> categories = menuDAO.getAllCategories();

            request.setAttribute("menuItems", items);
            request.setAttribute("categories", categories);
            request.setAttribute("selectedCategoryId", categoryIdParam);
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid category.");
        } catch (SQLException e) {
            throw new ServletException("Database error loading menu", e);
        }

        request.getRequestDispatcher("/WEB-INF/jsp/user/menu.jsp").forward(request, response);
    }
}
