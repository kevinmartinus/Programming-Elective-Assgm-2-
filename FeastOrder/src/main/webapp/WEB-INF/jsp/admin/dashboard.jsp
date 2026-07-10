<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Admin Dashboard - FeastOrder</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="bg-light">

    <%@ include file="adminNavbar.jsp" %>

    <div class="container py-5">
        <h2 class="mb-1">Welcome back, ${sessionScope.user.username}</h2>
        <p class="text-muted mb-4">Here's what's happening with FeastOrder right now.</p>

        <c:if test="${not empty statsError}">
            <div class="alert alert-warning">${statsError}</div>
        </c:if>

        <!-- Quick Statistics -->
        <div class="row g-4 mb-5">
            <div class="col-md-3 col-sm-6">
                <div class="card text-center shadow-sm border-0 h-100">
                    <div class="card-body">
                        <i class="bi bi-basket3 fs-1 text-warning"></i>
                        <h3 class="mt-2 mb-0">${empty totalMenuItems ? '—' : totalMenuItems}</h3>
                        <p class="text-muted mb-0">Menu Items</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3 col-sm-6">
                <div class="card text-center shadow-sm border-0 h-100">
                    <div class="card-body">
                        <i class="bi bi-receipt fs-1 text-success"></i>
                        <h3 class="mt-2 mb-0">${empty totalOrders ? '—' : totalOrders}</h3>
                        <p class="text-muted mb-0">Total Orders</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3 col-sm-6">
                <div class="card text-center shadow-sm border-0 h-100">
                    <div class="card-body">
                        <i class="bi bi-calendar-check fs-1 text-primary"></i>
                        <h3 class="mt-2 mb-0">${empty totalOrdersToday ? '—' : totalOrdersToday}</h3>
                        <p class="text-muted mb-0">Orders Today</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3 col-sm-6">
                <div class="card text-center shadow-sm border-0 h-100">
                    <div class="card-body">
                        <i class="bi bi-people fs-1 text-info"></i>
                        <h3 class="mt-2 mb-0">${empty totalUsers ? '—' : totalUsers}</h3>
                        <p class="text-muted mb-0">Registered Users</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Navigation Cards -->
        <div class="row g-4">
            <div class="col-md-6">
                <div class="card shadow-sm border-0 h-100">
                    <div class="card-body d-flex flex-column">
                        <i class="bi bi-egg-fried fs-1 text-warning mb-2"></i>
                        <h4>Manage Menu Items</h4>
                        <p class="text-muted flex-grow-1">
                            Add, edit, or remove menu items and categories. Changes appear
                            on the customer-facing menu immediately.
                        </p>
                        <a href="${pageContext.request.contextPath}/admin/menu" class="btn btn-warning">
                            Go to Menu Management <i class="bi bi-arrow-right"></i>
                        </a>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="card shadow-sm border-0 h-100">
                    <div class="card-body d-flex flex-column">
                        <i class="bi bi-clipboard-data fs-1 text-success mb-2"></i>
                        <h4>View Customer Orders</h4>
                        <p class="text-muted flex-grow-1">
                            See every order placed — customer info, items, totals, and status —
                            with the newest orders first.
                        </p>
                        <a href="${pageContext.request.contextPath}/admin/orders" class="btn btn-success">
                            Go to Orders <i class="bi bi-arrow-right"></i>
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
