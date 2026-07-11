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

/**
 * Loads menu items (all, filtered by category, or a single item for the
 * detail view) and forwards to menu.jsp.
 *
 * URL contract expected by menu.jsp:
 *   /menu                     -> full grid, all items
 *   /menu?categoryId=2        -> full grid, filtered to one category
 *   /menu?itemId=9            -> single-item detail view (request attr "item")
 */
@WebServlet("/menu")
public class MenuServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final MenuDAO menuDAO = new MenuDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String itemIdParam = request.getParameter("itemId");
        String categoryIdParam = request.getParameter("categoryId");

        try {
            // itemId takes priority — it's what "View Details" links send,
            // and menu.jsp only shows the detail view when "item" is set.
            if (itemIdParam != null && !itemIdParam.isBlank()) {
                int itemId = Integer.parseInt(itemIdParam);
                MenuItem item = menuDAO.getMenuItemById(itemId);

                if (item == null) {
                    request.setAttribute("error", "That menu item couldn't be found.");
                } else {
                    request.setAttribute("item", item);
                }

                // Still needed so the category filter tabs render correctly
                // if the person navigates back to the grid from here.
                request.setAttribute("categories", menuDAO.getAllCategories());

            } else {
                List<MenuItem> items;
                if (categoryIdParam != null && !categoryIdParam.isBlank()) {
                    int categoryId = Integer.parseInt(categoryIdParam);
                    items = menuDAO.getMenuItemsByCategory(categoryId);
                } else {
                    items = menuDAO.getAllMenuItems();
                }

                request.setAttribute("menuItems", items);
                request.setAttribute("categories", menuDAO.getAllCategories());
                request.setAttribute("selectedCategoryId", categoryIdParam);
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid item or category.");
            // Fall back to the full grid so the page isn't left empty.
            try {
                request.setAttribute("menuItems", menuDAO.getAllMenuItems());
                request.setAttribute("categories", menuDAO.getAllCategories());
            } catch (SQLException inner) {
                throw new ServletException("Database error loading menu", inner);
            }
        } catch (SQLException e) {
            throw new ServletException("Database error loading menu", e);
        }

        request.getRequestDispatcher("/WEB-INF/jsp/user/menu.jsp").forward(request, response);
    }
}