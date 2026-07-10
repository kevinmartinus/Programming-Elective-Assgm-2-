<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>FeastOrder - Order Confirmation</title>

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="css/style.css">
</head>
<body class="bg-light">

    <header>
        <nav class="navbar navbar-expand-md navbar-dark bg-dark">
            <div class="container">
                <a href="index.html" class="navbar-brand fw-bold">
                    <i class="bi bi-shop"></i> FeastOrder
                </a>
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navMenu">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse" id="navMenu">
                    <ul class="navbar-nav ms-auto">
                        <li class="nav-item"><a class="nav-link" href="index.html">Home</a></li>
                        <li class="nav-item"><a class="nav-link" href="menu">Menu</a></li>
                        <li class="nav-item"><a class="nav-link" href="about.html">About</a></li>
                        <li class="nav-item"><a class="nav-link" href="faq.html">FAQ</a></li>
                        <li class="nav-item"><a class="nav-link" href="contact.html">Contact</a></li>
                    </ul>
                </div>
            </div>
        </nav>
    </header>

    <main class="container py-5">

        <%-- Guard clause: if someone navigates here directly without placing an order,
             "order" will never have been set by OrderServlet. Show a friendly message
             instead of a broken/empty page or a JSP null-pointer error. --%>
        <c:choose>
            <c:when test="${empty order}">
                <div class="row justify-content-center">
                    <div class="col-12 col-md-8 col-lg-6 text-center">
                        <div class="card border-0 shadow-sm p-4">
                            <i class="bi bi-exclamation-circle text-warning" style="font-size: 3rem;"></i>
                            <h2 class="mt-3">No Order Found</h2>
                            <p class="text-muted">
                                It looks like you haven't placed an order yet, or this page was reached directly.
                            </p>
                            <a href="menu" class="btn btn-primary mt-2">
                                <i class="bi bi-basket3"></i> Browse Menu
                            </a>
                        </div>
                    </div>
                </div>
            </c:when>

            <c:otherwise>
                <div class="row justify-content-center">
                    <div class="col-12 col-lg-8">

                        <!-- Success banner -->
                        <div class="text-center mb-4">
                            <i class="bi bi-check-circle-fill text-success" style="font-size: 4rem;"></i>
                            <h1 class="fw-bold mt-3">Order Confirmed!</h1>
                            <p class="text-muted">
                                Thank you for your order. Your order confirmation has been saved to your account.
                            </p>
                        </div>

                        <!-- Order summary card -->
                        <div class="card border-0 shadow-sm mb-4">
                            <div class="card-header bg-white py-3">
                                <div class="d-flex justify-content-between align-items-center flex-wrap">
                                    <div>
                                        <span class="text-muted">Order ID</span>
                                        <h5 class="mb-0">#${order.orderId}</h5>
                                    </div>
                                    <div class="text-md-end">
                                        <span class="text-muted d-block">Placed on</span>
                                        <fmt:formatDate value="${order.orderTime}" pattern="dd MMM yyyy, hh:mm:ss a" />
                                    </div>
                                    <div>
                                        <c:choose>
                                            <c:when test="${order.status == 'Confirmed'}">
                                                <span class="badge bg-success"><i class="bi bi-check-lg"></i> ${order.status}</span>
                                            </c:when>
                                            <c:when test="${order.status == 'Pending'}">
                                                <span class="badge bg-warning text-dark"><i class="bi bi-hourglass-split"></i> ${order.status}</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary">${order.status}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>

                            <div class="card-body p-0">
                                <div class="table-responsive">
                                    <table class="table align-middle mb-0">
                                        <thead class="table-light">
                                            <tr>
                                                <th>Item</th>
                                                <th>Add-ons</th>
                                                <th class="text-center">Qty</th>
                                                <th class="text-end">Subtotal</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="item" items="${order.items}">
                                                <tr>
                                                    <td class="fw-semibold">${item.itemName}</td>
                                                    <td class="text-muted small">
                                                        <c:choose>
                                                            <c:when test="${not empty item.addOns}">${item.addOns}</c:when>
                                                            <c:otherwise><span class="fst-italic">None</span></c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td class="text-center">${item.quantity}</td>
                                                    <td class="text-end">
                                                        RM <fmt:formatNumber value="${item.subtotal}" pattern="#,##0.00" />
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                        <tfoot>
                                            <tr class="table-light">
                                                <td colspan="3" class="text-end fw-bold">Total</td>
                                                <td class="text-end fw-bold fs-5">
                                                    RM <fmt:formatNumber value="${order.totalPrice}" pattern="#,##0.00" />
                                                </td>
                                            </tr>
                                        </tfoot>
                                    </table>
                                </div>
                            </div>
                        </div>

                        <!-- Action buttons -->
                        <div class="d-flex flex-column flex-sm-row justify-content-center gap-2">
                            <a href="menu" class="btn btn-primary">
                                <i class="bi bi-basket3"></i> Continue Browsing
                            </a>
                            <a href="orderHistory" class="btn btn-outline-secondary">
                                <i class="bi bi-clock-history"></i> View My Orders
                            </a>
                            <a href="index.html" class="btn btn-outline-secondary">
                                <i class="bi bi-house"></i> Back to Home
                            </a>
                        </div>

                    </div>
                </div>
            </c:otherwise>
        </c:choose>

    </main>

    <footer class="bg-dark text-white text-center py-4 mt-5">
        <div class="container">
            <p class="mb-0">&copy; 2026 FeastOrder. All rights reserved.</p>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="js/main.js"></script>
</body>
</html>