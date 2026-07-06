package com.feastorder.servlet;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * SERVLET: MenuServlet
 * ------------------------------------------------------------
 * Loads menu items (all, or filtered by category) and forwards to menu.jsp.
 * URL mapping suggestion: /menu
 *
 * TODO for your team:
 *
 * doGet():
 *   1. Read optional "category" parameter:
 *        String categoryId = request.getParameter("categoryId");
 *   2. Call MenuDAO.getAllMenuItems() or getMenuItemsByCategory(categoryId)
 *   3. Also call MenuDAO.getAllCategories() so the JSP can render category
 *      filter buttons/tabs
 *   4. request.setAttribute("menuItems", items);
 *      request.setAttribute("categories", categories);
 *   5. RequestDispatcher rd = request.getRequestDispatcher("/WEB-INF/jsp/user/menu.jsp");
 *      rd.forward(request, response);
 *
 * Maps to rubric "1a Page Development" (Menu Page: categorized items,
 * ingredients, pricing, images, ratings).
 */
@WebServlet("/menu")
public class MenuServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // TODO: implement logic described above
    }
}
