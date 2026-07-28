<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>FeastOrder - Cart / Checkout</title>

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="bg-light">

    <header>
        <nav class="navbar navbar-expand-md navbar-dark bg-dark">
            <div class="container">
                <a href="${pageContext.request.contextPath}/index.html" class="navbar-brand fw-bold">
                    <i class="bi bi-shop"></i> FeastOrder
                </a>
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navMenu">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse" id="navMenu">
                    <ul class="navbar-nav ms-auto align-items-md-center">
                        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/index.html">Home</a></li>
                        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/menu">Menu</a></li>
                        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/about.html">About</a></li>
                        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/faq.html">FAQ</a></li>
                        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/contact.html">Contact</a></li>

                        <c:choose>
                            <c:when test="${not empty sessionScope.user}">
                                <li class="nav-item">
                                    <a class="nav-link" href="${pageContext.request.contextPath}/logout">
                                        <i class="bi bi-person-circle"></i> ${sessionScope.user.username} (Logout)
                                    </a>
                                </li>
                            </c:when>
                            <c:otherwise>
                                <li class="nav-item">
                                    <a class="nav-link" href="${pageContext.request.contextPath}/login.jsp">
                                        <i class="bi bi-box-arrow-in-right"></i> Login
                                    </a>
                                </li>
                            </c:otherwise>
                        </c:choose>

                        <li class="nav-item">
                            <a class="nav-link active position-relative" href="${pageContext.request.contextPath}/cart">
                                <i class="bi bi-cart3-fill fs-5"></i>
                                <c:if test="${not empty sessionScope.cart && sessionScope.cart.size() > 0}">
                                    <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">
                                        ${sessionScope.cart.size()}
                                    </span>
                                </c:if>
                            </a>
                        </li>
                    </ul>
                </div>
            </div>
        </nav>
    </header>

    <section class="bg-dark text-white text-center py-4">
        <div class="container">
            <h1 class="fw-bold mb-0"><i class="bi bi-cart3"></i> Your Cart</h1>
        </div>
    </section>

    <main class="container py-5">

        <c:if test="${not empty error}">
            <div class="alert alert-danger">${error}</div>
        </c:if>

        <%-- Empty Cart State — sessionScope.cart is a plain List<OrderItem>, so
             .isEmpty() maps to EL's "empty" via the standard List convention. --%>
        <c:if test="${empty sessionScope.cart}">
            <div class="text-center py-5">
                <i class="bi bi-cart-x text-muted" style="font-size: 4rem;"></i>
                <h3 class="mt-3 text-muted">Your cart is empty</h3>
                <p class="text-muted">Looks like you haven't added anything yet.</p>
                <a href="${pageContext.request.contextPath}/menu" class="btn btn-primary mt-2">
                    <i class="bi bi-basket3"></i> Browse Menu
                </a>
            </div>
        </c:if>

        <c:if test="${not empty sessionScope.cart}">
            <div class="row g-4">

                <!-- Cart line items -->
                <div class="col-12 col-lg-8">
                    <div class="card border-0 shadow-sm">
                        <div class="card-body p-0">
                            <div class="table-responsive">
                                <table class="table align-middle mb-0">
                                    <thead class="table-light">
                                        <tr>
                                            <th>Item</th>
                                            <th>Add-ons</th>
                                            <th class="text-center" style="width: 160px;">Quantity</th>
                                            <th class="text-end">Subtotal</th>
                                            <th></th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <%-- varStatus.index gives the 0-based list position, which is exactly
                                             what CartServlet's update/remove actions expect as "index". --%>
                                        <c:forEach var="cartItem" items="${sessionScope.cart}" varStatus="loop">
                                            <tr>
                                                <td>
                                                    <div class="d-flex align-items-center gap-2">
                                                        <i class="bi bi-egg-fried fs-3 text-warning"></i>
                                                        <div>
                                                            <div class="fw-semibold">${cartItem.itemName}</div>
                                                            <div class="text-muted small">
                                                                RM <fmt:formatNumber value="${cartItem.unitPrice}" pattern="#,##0.00"/> each
                                                            </div>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td class="text-muted small">
                                                    <c:choose>
                                                        <c:when test="${not empty cartItem.addOns}">${cartItem.addOns}</c:when>
                                                        <c:otherwise><span class="fst-italic">None</span></c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <form action="${pageContext.request.contextPath}/cart" method="post"
                                                          class="d-flex align-items-center gap-1"
                                                          onsubmit="return validateCartQuantityForm(this)">
                                                        <input type="hidden" name="action" value="update">
                                                        <input type="hidden" name="index" value="${loop.index}">
                                                        <input type="number" name="quantity"
                                                               class="form-control form-control-sm item-quantity text-center"
                                                               data-item-id="${loop.index}"
                                                               value="${cartItem.quantity}" min="1" max="20" required>
                                                        <button type="submit" class="btn btn-sm btn-outline-secondary" title="Update Quantity">
                                                            <i class="bi bi-arrow-repeat"></i>
                                                        </button>
                                                    </form>
                                                    <div class="text-danger small mt-1" id="qty-error-${loop.index}"></div>
                                                </td>
                                                <td class="text-end fw-semibold">
                                                    RM <fmt:formatNumber value="${cartItem.subtotal}" pattern="#,##0.00"/>
                                                </td>
                                                <td>
                                                    <form action="${pageContext.request.contextPath}/cart" method="post">
                                                        <input type="hidden" name="action" value="remove">
                                                        <input type="hidden" name="index" value="${loop.index}">
                                                        <button type="submit" class="btn btn-sm btn-outline-danger" title="Remove item">
                                                            <i class="bi bi-trash"></i>
                                                        </button>
                                                    </form>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>

                    <a href="${pageContext.request.contextPath}/menu" class="btn btn-outline-primary mt-3">
                        <i class="bi bi-arrow-left"></i> Continue Browsing
                    </a>
                </div>

                <!-- Order summary & checkout form -->
                <div class="col-12 col-lg-4">
                    <div class="card border-0 shadow-sm">
                        <div class="card-body p-4">
                            <h5 class="mb-3">Order Summary</h5>

                            <%-- Aggregation via JSTL loop, since sessionScope.cart is a plain List
                                 with no built-in getSubtotal() to call. --%>
                            <c:set var="cartSubtotal" value="${0}"/>
                            <c:forEach var="lineItem" items="${sessionScope.cart}">
                                <c:set var="cartSubtotal" value="${cartSubtotal + lineItem.subtotal}"/>
                            </c:forEach>
                            <c:set var="tax" value="${cartSubtotal * 0.06}"/>
                            <c:set var="grandTotal" value="${cartSubtotal + tax}"/>

                            <div class="d-flex justify-content-between mb-2">
                                <span class="text-muted">Subtotal</span>
                                <span>RM <fmt:formatNumber value="${cartSubtotal}" pattern="#,##0.00"/></span>
                            </div>
                            <div class="d-flex justify-content-between mb-2">
                                <span class="text-muted">SST (6%)</span>
                                <span>RM <fmt:formatNumber value="${tax}" pattern="#,##0.00"/></span>
                            </div>
                            <hr>
                            <div class="d-flex justify-content-between mb-4">
                                <span class="fw-bold fs-5">Total</span>
                                <span class="fw-bold fs-5 text-primary">
                                    RM <fmt:formatNumber value="${grandTotal}" pattern="#,##0.00"/>
                                </span>
                            </div>

                            <c:choose>
                                <%--  Checkout requires a logged-in user, since the order must be tied
                                      to a userId. Cart (above) itself does not. --%>
                                <c:when test="${empty sessionScope.user}">
                                    <div class="alert alert-warning small mb-3">
                                        <i class="bi bi-exclamation-triangle"></i>
                                        Please log in to complete your order.
                                    </div>
                                    <a href="${pageContext.request.contextPath}/login.jsp" class="btn btn-primary w-100">
                                        <i class="bi bi-box-arrow-in-right"></i> Log In to Checkout
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <form action="${pageContext.request.contextPath}/placeOrder" method="post"
                                          id="checkoutForm" onsubmit="return validateOrderForm()" novalidate>

                                        <label class="form-label fw-semibold">Order Type</label>
                                        <div class="mb-2">
                                            <div class="form-check">
                                                <input class="form-check-input" type="radio" name="orderType" id="orderTypePickup" value="Pickup" checked>
                                                <label class="form-check-label" for="orderTypePickup">
                                                    <i class="bi bi-shop"></i> Pickup at Restaurant <span class="text-muted small">(pay at the counter)</span>
                                                </label>
                                            </div>
                                            <div class="form-check">
                                                <input class="form-check-input" type="radio" name="orderType" id="orderTypeDelivery" value="Delivery">
                                                <label class="form-check-label" for="orderTypeDelivery">
                                                    <i class="bi bi-truck"></i> Delivery
                                                </label>
                                            </div>
                                        </div>
                                        <p class="text-muted small mb-2" id="pickupNote">
                                            <i class="bi bi-info-circle"></i> Your order is sent straight to the kitchen. Just give your name at the counter and pay when you collect it.
                                        </p>
                                        <div class="text-danger small mb-2" id="orderTypeError"></div>

                                        <div class="mb-3 d-none" id="deliveryAddressGroup">
                                            <label for="deliveryAddress" class="form-label">Delivery Address</label>
                                            <textarea class="form-control" id="deliveryAddress" name="deliveryAddress" rows="2"
                                                      placeholder="Unit number, street, city, postcode"></textarea>
                                            <div class="text-danger small mt-1" id="deliveryAddressError"></div>
                                        </div>

                                        <div class="mb-3">
                                            <label for="orderNotes" class="form-label">Notes (optional)</label>
                                            <textarea class="form-control" id="orderNotes" name="notes" rows="2"
                                                      placeholder="e.g., no onions, please ring the doorbell twice"></textarea>
                                        </div>

                                        <button type="submit" class="btn btn-primary w-100">
                                            <i class="bi bi-bag-check"></i> Place Order
                                        </button>
                                    </form>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>

            </div>
        </c:if>

    </main>

    <footer class="bg-dark text-white text-center py-4 mt-5">
        <div class="container">
            <p class="mb-0">&copy; 2026 FeastOrder. All rights reserved.</p>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/main.js"></script>

</body>
</html>