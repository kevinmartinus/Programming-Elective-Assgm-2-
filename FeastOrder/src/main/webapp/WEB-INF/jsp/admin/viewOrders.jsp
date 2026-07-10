<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
    <style>
        .orders-page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 12px;
            margin-bottom: 24px;
        }
        .stat-cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
            gap: 16px;
            margin-bottom: 28px;
        }
        .stat-card {
            background: #fff;
            border: 1px solid #e2e2e2;
            border-radius: 10px;
            padding: 16px 20px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.06);
        }
        .stat-card .stat-label { font-size: 0.8rem; color: #777; text-transform: uppercase; letter-spacing: 0.03em; }
        .stat-card .stat-value { font-size: 1.6rem; font-weight: 700; color: #222; margin-top: 4px; }

        .filter-bar {
            display: flex;
            flex-wrap: wrap;
            gap: 12px;
            align-items: center;
            background: #fafafa;
            border: 1px solid #eee;
            border-radius: 8px;
            padding: 12px 16px;
            margin-bottom: 20px;
        }
        .filter-bar select {
            padding: 6px 10px;
            border-radius: 6px;
            border: 1px solid #ccc;
        }
        .filter-bar button, .filter-bar a.reset-link {
            padding: 6px 14px;
            border-radius: 6px;
            border: none;
            background: #d9534f;
            color: #fff;
            cursor: pointer;
            font-size: 0.9rem;
            text-decoration: none;
        }
        .filter-bar button { background: #2c7a4b; }

        table.orders-table {
            width: 100%;
            border-collapse: collapse;
            background: #fff;
            box-shadow: 0 1px 3px rgba(0,0,0,0.06);
        }
        table.orders-table th, table.orders-table td {
            padding: 12px 14px;
            border-bottom: 1px solid #eee;
            text-align: left;
            vertical-align: top;
        }
        table.orders-table th {
            background: #f5f5f5;
            font-size: 0.85rem;
            text-transform: uppercase;
            letter-spacing: 0.02em;
            color: #555;
        }
        tr.order-row { cursor: pointer; }
        tr.order-row:hover { background: #fafcf9; }

        .customer-email { font-size: 0.82rem; color: #888; }

        .status-badge {
            display: inline-block;
            padding: 4px 10px;
            border-radius: 999px;
            font-size: 0.78rem;
            font-weight: 600;
            text-transform: capitalize;
        }
        .status-PENDING          { background: #fff3cd; color: #8a6d00; }
        .status-PREPARING        { background: #d9edf7; color: #1b6a91; }
        .status-OUT_FOR_DELIVERY { background: #e2d9f7; color: #5b2d91; }
        .status-DELIVERED        { background: #d4edda; color: #1e7e34; }
        .status-CANCELLED        { background: #f8d7da; color: #a12a2a; }

        .items-summary { font-size: 0.88rem; color: #444; }
        .expand-toggle { font-size: 0.78rem; color: #2c7a4b; margin-left: 6px; }

        tr.detail-row { display: none; background: #fbfbfb; }
        tr.detail-row.open { display: table-row; }
        .detail-inner { padding: 10px 14px 16px 34px; }
        table.item-breakdown { width: 100%; border-collapse: collapse; margin-top: 6px; }
        table.item-breakdown th, table.item-breakdown td {
            padding: 6px 10px;
            font-size: 0.86rem;
            border-bottom: 1px dashed #ddd;
        }
        table.item-breakdown th { background: transparent; color: #999; font-weight: 600; }

        .status-update-form { display: flex; gap: 6px; align-items: center; }
        .status-update-form select { padding: 4px 6px; border-radius: 5px; border: 1px solid #ccc; font-size: 0.82rem; }
        .status-update-form button {
            padding: 4px 10px;
            border: none;
            border-radius: 5px;
            background: #333;
            color: #fff;
            font-size: 0.8rem;
            cursor: pointer;
        }

        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #888;
            background: #fff;
            border-radius: 8px;
            border: 1px dashed #ddd;
        }
    </style>
</head>
<body>

    <%@ include file="adminNavbar.jsp" %>

    <div class="admin-container">

        <div class="orders-page-header">
            <h1>Customer Orders</h1>
        </div>

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