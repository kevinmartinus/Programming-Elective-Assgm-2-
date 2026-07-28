<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:if test="${empty sessionScope.user || sessionScope.user.admin != true}">
    <c:redirect url="/login.jsp?error=unauthorized" />
</c:if>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Users — FeastOrder Admin</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .admin-container { max-width: 1200px; margin: 0 auto; padding: 2.5rem 1.5rem; }
        .admin-hero { text-align: center; padding: 2.5rem 1rem; }
        .admin-hero .eyebrow {
            display: inline-block; font-family: var(--font-body);
            letter-spacing: 0.18em; text-transform: uppercase;
            font-size: 0.78rem; font-weight: 600; color: var(--c-gold-light);
            margin-bottom: 0.4rem;
        }
        .admin-hero h1 { color: #fff; margin: 0 0 0.5rem; font-size: 2rem; }
        .role-badge-admin { background: var(--c-gold, #b8860b); color: #111; }
        .role-badge-customer { background: #6c757d; color: #fff; }
    </style>
</head>
<body>
    <jsp:include page="adminNavBar.jsp" />

    <div class="admin-hero" style="background:#111A19;">
        <span class="eyebrow">Admin Panel</span>
        <h1><i class="bi bi-people"></i> Manage Users</h1>
    </div>

    <div class="admin-container">
        <div class="card shadow-sm">
            <div class="card-body">
                <h5 class="mb-3">Registered Users (${totalUsers})</h5>
                <div class="table-responsive">
                    <table class="table align-middle">
                        <thead>
                            <tr>
                                <th>Username</th>
                                <th>Full Name</th>
                                <th>Email</th>
                                <th>Phone</th>
                                <th>Role</th>
                                <th>Registered On</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="u" items="${users}">
                                <tr>
                                    <td>${u.username}</td>
                                    <td>${u.fullName}</td>
                                    <td>${u.email}</td>
                                    <td>${u.phoneNumber}</td>
                                    <td>
                                        <span class="badge rounded-pill ${u.admin ? 'role-badge-admin' : 'role-badge-customer'}">
                                            ${u.role}
                                        </span>
                                    </td>
                                    <td><fmt:formatDate value="${u.createdAt}" pattern="MMM d, yyyy h:mm a"/></td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty users}">
                                <tr><td colspan="6" class="text-center text-muted">No users registered yet.</td></tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</body>
</html>