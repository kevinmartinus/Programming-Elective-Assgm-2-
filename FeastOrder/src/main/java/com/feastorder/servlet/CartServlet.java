package com.feastorder.servlet;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * SERVLET: CartServlet
 * ------------------------------------------------------------
 * Manages the shopping cart, stored in the user's HttpSession
 * (e.g. as a List<OrderItem> or Map<Integer itemId, OrderItem>).
 * URL mapping suggestion: /cart
 *
 * TODO for your team:
 *
 * doPost() — handle an "action" parameter to keep one servlet multi-purpose:
 *   String action = request.getParameter("action"); // "add" | "remove" | "update" | "clear"
 *
 *   case "add":
 *     - Check user is logged in (session.getAttribute("user") != null)
 *       If not, redirect to /login (access restriction, per rubric 2a)
 *     - Read itemId, quantity, addOns from request
 *     - Look up the MenuItem via MenuDAO to get name/price
 *     - Build an OrderItem, add it to the cart list in session
 *
 *   case "remove":
 *     - Remove the specified item from the cart list
 *
 *   case "update":
 *     - Change quantity for an existing cart line
 *
 *   case "clear":
 *     - Empty the cart list
 *
 * doGet():
 *   - Forward to cart.jsp / checkout.jsp to display current cart contents
 *
 * Maps to rubric "2c Dynamic Order Processing" (select items, add to cart)
 * and "Access restriction for ordering" (rubric 2a).
 */
@WebServlet("/cart")
public class CartServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // TODO: forward to cart/checkout JSP
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // TODO: implement add/remove/update/clear logic described above
    }
}
