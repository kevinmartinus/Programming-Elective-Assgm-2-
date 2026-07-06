<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>FeastOrder - Cart / Checkout</title>
    <link rel="stylesheet" href="../../../css/style.css">
</head>
<body>

    <!--
        CART / CHECKOUT PAGE — TODO for your team:

        1. List cart items pulled from session (set by CartServlet):
           - name, quantity (editable — posts to /cart action=update),
             add-ons, subtotal
           - "Remove" button per line (posts to /cart action=remove)

        2. Order summary
           - Subtotal, any delivery fee/tax if you want, Total

        3. Checkout form
           - Delivery details / notes if relevant to your design
           - "Place Order" button -> posts to /placeOrder (OrderServlet)

        4. Client-side JS validation before submit (rubric 2c requires this):
           - cart not empty
           - quantities are valid positive numbers

        5. If cart is empty, show a friendly "Your cart is empty" message
           with a link back to /menu
    -->

    <h1>Your Cart</h1>
    <!-- cart contents + checkout form go here -->

</body>
</html>
