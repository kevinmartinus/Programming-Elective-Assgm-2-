package com.feastorder.servlet;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * SERVLET: AdminMenuServlet
 * ------------------------------------------------------------
 * Admin CRUD for menu items and categories.
 * URL mapping suggestion: /admin/menu
 *
 * TODO for your team:
 *
 * ACCESS CONTROL (do this FIRST in both doGet/doPost):
 *   HttpSession session = request.getSession(false);
 *   User user = (session != null) ? (User) session.getAttribute("user") : null;
 *   if (user == null || !"admin".equals(user.getRole())) {
 *       response.sendRedirect("login.jsp");
 *       return;
 *   }
 *
 * doGet():
 *   - Load all menu items + categories via MenuDAO
 *   - Forward to /WEB-INF/jsp/admin/manageMenu.jsp
 *
 * doPost() — use an "action" parameter like CartServlet:
 *   case "add":    MenuDAO.addMenuItem(...)
 *   case "update": MenuDAO.updateMenuItem(...)
 *   case "delete": MenuDAO.deleteMenuItem(...)
 *   case "addCategory":    MenuDAO.addCategory(...)
 *   case "deleteCategory": MenuDAO.deleteCategory(...)
 *   - After each action, redirect back to /admin/menu (Post-Redirect-Get
 *     pattern, avoids duplicate form resubmission)
 *
 * Maps to rubric "2b Admin System & Database Connectivity".
 */
@WebServlet("/admin/menu")
public class AdminMenuServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // TODO: implement access check + load + forward, as described above
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // TODO: implement access check + CRUD actions, as described above
    }
}
