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

    <style>
        .admin-hero {
            text-align: center;
            padding: 2.5rem 1rem;
        }
        .admin-hero .eyebrow {
            display: inline-block;
            font-family: var(--font-body);
            letter-spacing: 0.18em;
            text-transform: uppercase;
            font-size: 0.78rem;
            font-weight: 600;
            color: var(--c-gold-light);
            margin-bottom: 0.4rem;
        }
        .admin-hero h2 {
            color: #fff;
            margin: 0 0 0.5rem;
        }
        .admin-hero p { color: var(--c-champagne-soft); opacity: 0.85; margin: 0; }
        .admin-hero .hero-divider {
            width: 140px;
            height: 20px;
            margin: 0.75rem auto 0.5rem;
            background-image: var(--ornament-divider);
            background-repeat: no-repeat;
            background-position: center;
            background-size: contain;
            filter: brightness(1.4);
        }

        .stat-card, .admin-nav-card {
            transition: var(--transition);
        }
        .stat-card:hover {
            transform: translateY(-4px);
            box-shadow: var(--shadow-md) !important;
            border: 1px solid var(--c-gold);
        }
        .stat-icon-circle {
            width: 56px;
            height: 56px;
            border-radius: 50%;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            background: var(--color-bg-surface-alt);
            border: 1px solid var(--color-border);
            margin: 0 auto 0.75rem;
            font-size: 1.4rem;
            transition: var(--transition);
        }
        .stat-card:hover .stat-icon-circle {
            background: var(--c-gold);
            border-color: var(--c-gold);
        }
        .stat-value-lux {
            font-family: var(--font-heading);
            font-size: 2rem;
            font-weight: 700;
            color: var(--color-heading);
        }
        .admin-nav-card {
            border-top: 3px solid var(--c-gold);
        }
        .admin-nav-card:hover {
            transform: translateY(-4px);
            box-shadow: var(--shadow-lg) !important;
        }
        .admin-nav-card .nav-card-icon {
            width: 64px;
            height: 64px;
            border-radius: 50%;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg, var(--c-gold) 0%, var(--c-gold-dark) 100%);
            color: var(--c-ink);
            font-size: 1.6rem;
            box-shadow: var(--shadow-gold);
            margin-bottom: 1rem;
        }
    </style>
</head>
<body class="bg-light">

    <%@ include file="adminNavBar.jsp" %>

    <section class="bg-dark admin-hero">
        <span class="eyebrow">Admin Panel</span>
        <h2>Welcome back, ${sessionScope.user.username}</h2>
        <div class="hero-divider"></div>
        <p>Here's what's happening with FeastOrder right now.</p>
    </section>

    <div class="container py-5">

        <c:if test="${not empty statsError}">
            <div class="alert alert-warning">${statsError}</div>
        </c:if>

        <!-- Quick Statistics -->
        <div class="row g-4 mb-5">
            <div class="col-md-3 col-sm-6">
                <div class="card text-center shadow-sm border-0 h-100 stat-card">
                    <div class="card-body">
                        <div class="stat-icon-circle"><i class="bi bi-basket3 text-warning"></i></div>
                        <div class="stat-value-lux">${empty totalMenuItems ? '—' : totalMenuItems}</div>
                        <p class="text-muted mb-0">Menu Items</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3 col-sm-6">
                <div class="card text-center shadow-sm border-0 h-100 stat-card">
                    <div class="card-body">
                        <div class="stat-icon-circle"><i class="bi bi-receipt text-success"></i></div>
                        <div class="stat-value-lux">${empty totalOrders ? '—' : totalOrders}</div>
                        <p class="text-muted mb-0">Total Orders</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3 col-sm-6">
                <div class="card text-center shadow-sm border-0 h-100 stat-card">
                    <div class="card-body">
                        <div class="stat-icon-circle"><i class="bi bi-calendar-check text-primary"></i></div>
                        <div class="stat-value-lux">${empty totalOrdersToday ? '—' : totalOrdersToday}</div>
                        <p class="text-muted mb-0">Orders Today</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3 col-sm-6">
                <div class="card text-center shadow-sm border-0 h-100 stat-card">
                    <div class="card-body">
                        <div class="stat-icon-circle"><i class="bi bi-people text-info"></i></div>
                        <div class="stat-value-lux">${empty totalUsers ? '—' : totalUsers}</div>
                        <p class="text-muted mb-0">Registered Users</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Navigation Cards -->
        <div class="row g-4">
            <div class="col-md-6">
                <div class="card admin-nav-card shadow-sm border-0 h-100">
                    <div class="card-body d-flex flex-column">
                        <div class="nav-card-icon"><i class="bi bi-egg-fried"></i></div>
                        <h4>Manage Menu Items</h4>
                        <p class="text-muted flex-grow-1">
                            Add, edit, or remove menu items and categories. Changes appear
                            on the customer-facing menu immediately.
                        </p>
                        <a href="${pageContext.request.contextPath}/admin/menu" class="btn btn-warning rounded-pill">
                            Go to Menu Management <i class="bi bi-arrow-right"></i>
                        </a>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="card admin-nav-card shadow-sm border-0 h-100">
                    <div class="card-body d-flex flex-column">
                        <div class="nav-card-icon"><i class="bi bi-clipboard-data"></i></div>
                        <h4>View Customer Orders</h4>
                        <p class="text-muted flex-grow-1">
                            See every order placed — customer info, items, totals, and status —
                            with the newest orders first.
                        </p>
                        <a href="${pageContext.request.contextPath}/admin/orders" class="btn btn-success rounded-pill">
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
