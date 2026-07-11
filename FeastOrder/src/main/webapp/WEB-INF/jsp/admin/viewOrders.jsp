<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<%-- Defense-in-depth: re-check admin session even though AdminOrderServlet
     already gated this request. If someone hits this JSP directly (bypassing
     the servlet) or the session expires mid-browse, bounce them out. --%>
<c:if test="${empty sessionScope.user || sessionScope.user.admin != true}">
    <c:redirect url="/login.jsp?error=unauthorized" />
</c:if>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Orders — FeastOrder Admin</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .admin-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 2.5rem 1.5rem;
        }
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
        .admin-hero h1 { color: #fff; margin: 0 0 0.5rem; font-size: 2rem; }
        .admin-hero .hero-divider {
            width: 140px;
            height: 20px;
            margin: 0.75rem auto 0;
            background-image: var(--ornament-divider);
            background-repeat: no-repeat;
            background-position: center;
            background-size: contain;
            filter: brightness(1.4);
        }
        .stat-cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
            gap: 16px;
            margin-bottom: 28px;
        }
        .stat-card {
            background: var(--color-bg-surface);
            border: 1px solid var(--color-border);
            border-radius: var(--radius-md);
            padding: 16px 20px;
            box-shadow: var(--shadow-sm);
            transition: var(--transition);
        }
        .stat-card:hover { box-shadow: var(--shadow-md); transform: translateY(-2px); }
        .stat-card .stat-label { font-size: 0.8rem; color: var(--color-text-muted); text-transform: uppercase; letter-spacing: 0.06em; }
        .stat-card .stat-value {
            font-family: var(--font-heading);
            font-size: 1.6rem;
            font-weight: 700;
            color: var(--c-gold-dark);
            margin-top: 4px;
        }

        .filter-bar {
            display: flex;
            flex-wrap: wrap;
            gap: 12px;
            align-items: center;
            background: var(--color-bg-surface-alt);
            border: 1px solid var(--color-border);
            border-radius: var(--radius-sm);
            padding: 12px 16px;
            margin-bottom: 20px;
        }
        .filter-bar select {
            padding: 6px 10px;
            border-radius: var(--radius-sm);
            border: 1px solid var(--color-border);
            background: var(--color-bg-surface);
            color: var(--color-text-body);
        }
        .filter-bar button, .filter-bar a.reset-link {
            padding: 6px 16px;
            border-radius: 999px;
            border: none;
            cursor: pointer;
            font-size: 0.9rem;
            font-weight: 600;
            text-decoration: none;
            transition: var(--transition);
        }
        .filter-bar button {
            background: linear-gradient(135deg, var(--c-gold) 0%, var(--c-gold-dark) 100%);
            color: var(--c-ink);
            box-shadow: var(--shadow-gold);
        }
        .filter-bar button:hover { filter: brightness(1.06); }
        .filter-bar a.reset-link {
            background: transparent;
            color: var(--c-rust);
            border: 1px solid rgba(133,67,30,0.4);
        }
        .filter-bar a.reset-link:hover { background: var(--color-danger-bg); }

        table.orders-table {
            width: 100%;
            border-collapse: collapse;
            background: var(--color-bg-surface);
            border-radius: var(--radius-md);
            overflow: hidden;
            box-shadow: var(--shadow-sm);
        }
        table.orders-table th, table.orders-table td {
            padding: 12px 14px;
            border-bottom: 1px solid var(--color-border);
            text-align: left;
            vertical-align: top;
        }
        table.orders-table th {
            background: var(--color-bg-surface-alt);
            font-size: 0.78rem;
            text-transform: uppercase;
            letter-spacing: 0.06em;
            color: var(--color-heading);
            font-family: var(--font-body);
            font-weight: 700;
        }
        tr.order-row { cursor: pointer; transition: var(--transition); }
        tr.order-row:hover { background: var(--color-bg-surface-alt); }

        .customer-email { font-size: 0.82rem; color: var(--color-text-muted); }

        .status-badge {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 999px;
            font-size: 0.75rem;
            font-weight: 700;
            text-transform: capitalize;
            letter-spacing: 0.02em;
        }
        .status-PENDING          { background: rgba(211,152,88,0.2);  color: var(--c-gold-dark); }
        .status-PREPARING        { background: rgba(128,153,118,0.2); color: var(--c-sage-dark); }
        .status-OUT_FOR_DELIVERY { background: rgba(40,65,57,0.15);   color: var(--c-forest-dark); }
        .status-DELIVERED        { background: rgba(128,153,118,0.3); color: var(--c-sage-dark); }
        .status-CANCELLED        { background: rgba(133,67,30,0.18); color: var(--c-rust); }

        .items-summary { font-size: 0.88rem; color: var(--color-text-body); }
        .expand-toggle { font-size: 0.78rem; color: var(--c-gold-dark); margin-left: 6px; font-weight: 600; }

        tr.detail-row { display: none; background: var(--color-bg-surface-alt); }
        tr.detail-row.open { display: table-row; }
        .detail-inner { padding: 10px 14px 16px 34px; }
        table.item-breakdown { width: 100%; border-collapse: collapse; margin-top: 6px; }
        table.item-breakdown th, table.item-breakdown td {
            padding: 6px 10px;
            font-size: 0.86rem;
            border-bottom: 1px dashed var(--color-border);
        }
        table.item-breakdown th { background: transparent; color: var(--color-text-muted); font-weight: 600; }

        .status-update-form { display: flex; gap: 6px; align-items: center; }
        .status-update-form select {
            padding: 4px 8px;
            border-radius: var(--radius-sm);
            border: 1px solid var(--color-border);
            font-size: 0.82rem;
        }
        .status-update-form button {
            padding: 4px 12px;
            border: none;
            border-radius: 999px;
            background: var(--c-ink);
            color: #fff;
            font-size: 0.8rem;
            font-weight: 600;
            cursor: pointer;
            transition: var(--transition);
        }
        .status-update-form button:hover { background: var(--c-forest-dark); }

        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: var(--color-text-muted);
            background: var(--color-bg-surface);
            border-radius: var(--radius-md);
            border: 1px dashed var(--color-border);
        }
    </style>
</head>
<body class="bg-light">

    <%@ include file="adminNavBar.jsp" %>

    <section class="bg-dark admin-hero">
        <span class="eyebrow">Admin Panel</span>
        <h1>Customer Orders</h1>
        <div class="hero-divider"></div>
    </section>

    <div class="admin-container">

        <%-- Quick stats — same visual language as dashboard.jsp's stat cards --%>
        <div class="stat-cards">
            <div class="stat-card">
                <div class="stat-label">Total Orders</div>
                <div class="stat-value">${totalOrders}</div>
            </div>
            <div class="stat-card">
                <div class="stat-label">Today's Orders</div>
                <div class="stat-value">${todayOrders}</div>
            </div>
            <div class="stat-card">
                <div class="stat-label">Pending</div>
                <div class="stat-value">${pendingOrders}</div>
            </div>
            <div class="stat-card">
                <div class="stat-label">Total Revenue</div>
                <div class="stat-value">
                    <fmt:formatNumber value="${totalRevenue}" type="currency" currencySymbol="$"/>
                </div>
            </div>
        </div>

        <%-- Filter / sort bar — GETs back to AdminOrderServlet, which re-queries via OrderDAO --%>
        <form class="filter-bar" method="get" action="${pageContext.request.contextPath}/admin/orders">
            <label for="status">Status:</label>
            <select name="status" id="status">
                <option value="ALL"               ${statusFilter == 'ALL' ? 'selected' : ''}>All</option>
                <option value="PENDING"           ${statusFilter == 'PENDING' ? 'selected' : ''}>Pending</option>
                <option value="PREPARING"         ${statusFilter == 'PREPARING' ? 'selected' : ''}>Preparing</option>
                <option value="OUT_FOR_DELIVERY"  ${statusFilter == 'OUT_FOR_DELIVERY' ? 'selected' : ''}>Out for Delivery</option>
                <option value="DELIVERED"         ${statusFilter == 'DELIVERED' ? 'selected' : ''}>Delivered</option>
                <option value="CANCELLED"         ${statusFilter == 'CANCELLED' ? 'selected' : ''}>Cancelled</option>
            </select>

            <label for="sort">Sort by:</label>
            <select name="sort" id="sort">
                <option value="newest"        ${sortBy == 'newest' ? 'selected' : ''}>Newest first</option>
                <option value="oldest"        ${sortBy == 'oldest' ? 'selected' : ''}>Oldest first</option>
                <option value="highest_total" ${sortBy == 'highest_total' ? 'selected' : ''}>Highest total</option>
                <option value="lowest_total"  ${sortBy == 'lowest_total' ? 'selected' : ''}>Lowest total</option>
            </select>

            <button type="submit">Apply</button>
            <a class="reset-link" href="${pageContext.request.contextPath}/admin/orders">Reset</a>
        </form>

        <c:choose>
            <c:when test="${empty orders}">
                <div class="empty-state">
                    No orders match the current filter.
                </div>
            </c:when>
            <c:otherwise>
                <table class="orders-table">
                    <thead>
                        <tr>
                            <th>Order ID</th>
                            <th>Customer</th>
                            <th>Items</th>
                            <th>Total</th>
                            <th>Order Time</th>
                            <th>Status</th>
                            <th>Update Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="order" items="${orders}" varStatus="loop">
                            <tr class="order-row" onclick="toggleDetail(${order.orderId})" onkeydown="toggleDetail(${order.orderId})" tabindex="0">
                                <td>#${order.orderId}</td>
                                <td>
                                    ${order.customerName}<br>
                                    <span class="customer-email">${order.customerEmail}</span>
                                </td>
                                <td class="items-summary">
                                    <c:choose>
                                        <c:when test="${empty order.items}">
                                            <em>No items recorded</em>
                                        </c:when>
                                        <c:otherwise>
                                            ${order.items[0].itemName} x${order.items[0].quantity}
                                            <c:if test="${fn:length(order.items) > 1}">
                                                + ${fn:length(order.items) - 1} more
                                            </c:if>
                                            <span class="expand-toggle">▾ details</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td><fmt:formatNumber value="${order.totalPrice}" type="currency" currencySymbol="$"/></td>
                                <td><fmt:formatDate value="${order.orderTime}" pattern="MMM d, yyyy h:mm a"/></td>
                                <td>
                                    <span class="status-badge status-${order.status}">
                                        ${fn:replace(order.status, '_', ' ')}
                                    </span>
                                </td>
                                <td onclick="event.stopPropagation();">
                                    <form class="status-update-form" method="post"
                                        action="${pageContext.request.contextPath}/admin/orders">
                                        <input type="hidden" name="action" value="updateStatus">
                                        <input type="hidden" name="orderId" value="${order.orderId}">
                                        <input type="hidden" name="currentStatusFilter" value="${statusFilter}">
                                        <input type="hidden" name="currentSortBy" value="${sortBy}">
                                        <select name="status">
                                            <option value="PENDING"          ${order.status == 'PENDING' ? 'selected' : ''}>Pending</option>
                                            <option value="PREPARING"        ${order.status == 'PREPARING' ? 'selected' : ''}>Preparing</option>
                                            <option value="OUT_FOR_DELIVERY" ${order.status == 'OUT_FOR_DELIVERY' ? 'selected' : ''}>Out for Delivery</option>
                                            <option value="DELIVERED"        ${order.status == 'DELIVERED' ? 'selected' : ''}>Delivered</option>
                                            <option value="CANCELLED"        ${order.status == 'CANCELLED' ? 'selected' : ''}>Cancelled</option>
                                        </select>
                                        <button type="submit">Save</button>
                                    </form>
                                </td>
                            </tr>

                            <%-- Expandable detail row: full item breakdown for this order --%>
                            <tr class="detail-row" id="detail-${order.orderId}">
                                <td colspan="7">
                                    <div class="detail-inner">
                                        <c:choose>
                                            <c:when test="${empty order.items}">
                                                <em>No item breakdown available for this order.</em>
                                            </c:when>
                                            <c:otherwise>
                                                <table class="item-breakdown">
                                                    <thead>
                                                        <tr>
                                                            <th>Item</th>
                                                            <th>Qty</th>
                                                            <th>Unit Price</th>
                                                            <th>Subtotal</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <c:forEach var="item" items="${order.items}">
                                                            <tr>
                                                                <td>${item.itemName}</td>
                                                                <td>${item.quantity}</td>
                                                                <td><fmt:formatNumber value="${item.unitPrice}" type="currency" currencySymbol="$"/></td>
                                                                <td><fmt:formatNumber value="${item.subtotal}" type="currency" currencySymbol="$"/></td>
                                                            </tr>
                                                        </c:forEach>
                                                    </tbody>
                                                </table>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:otherwise>
        </c:choose>

    </div>

    <script>
        // Toggle the hidden detail row under a given order row.
        function toggleDetail(orderId) {
            var row = document.getElementById('detail-' + orderId);
            if (row) {
                row.classList.toggle('open');
            }
        }
    </script>

</body>
</html>