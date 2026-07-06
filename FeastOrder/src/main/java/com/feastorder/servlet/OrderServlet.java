package com.feastorder.servlet;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * SERVLET: OrderServlet
 * ------------------------------------------------------------
 * Finalizes checkout: takes the session cart, saves it as a real order
 * in the DB, then shows confirmation.
 * URL mapping suggestion: /placeOrder
 *
 * TODO for your team:
 *
 * doPost():
 *   1. Confirm user is logged in (session check) — else redirect to /login
 *   2. Retrieve cart list from session
 *   3. SERVER-SIDE validation:
 *      - cart isn't empty
 *      - quantities are positive integers
 *      (Client-side JS validation should ALSO exist on the checkout form,
 *       per rubric 2c "Validate inputs using JavaScript" — but don't rely
 *       on JS alone since it can be bypassed)
 *   4. Build an Order object: userId, totalPrice (sum of cart), status, items
 *   5. Call OrderDAO.createOrder(order) -> returns generated orderId
 *   6. Clear the cart from session
 *   7. request.setAttribute("order", order);  // or just orderId
 *      redirect/forward to confirmation.jsp showing order details
 *
 * Maps to rubric "2c Dynamic Order Processing" (submit order, store in DB,
 * display confirmation).
 */
@WebServlet("/placeOrder")
public class OrderServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // TODO: implement checkout/order-creation logic described above
    }
}
