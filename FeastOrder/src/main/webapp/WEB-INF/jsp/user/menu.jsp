<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.feastorder.model.MenuItem" %>
<%@ page import="com.feastorder.model.Category" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>FeastOrder - Menu</title>
    
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
                        <li class="nav-item"><a class="nav-link active" href="${pageContext.request.contextPath}/menu">Menu</a></li>
                        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/about.html">About</a></li>
                        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/faq.html">FAQ</a></li>
                        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/contact.html">Contact</a></li>

                        <c:choose>
                            <c:when test="${not empty sessionScope.user}">
                                <c:if test="${sessionScope.user.admin}">
                                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard"><i class="bi bi-speedometer2"></i> Admin</a></li>
                                </c:if>
                                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/logout"><i class="bi bi-box-arrow-right"></i> Logout</a></li>
                            </c:when>
                            <c:otherwise>
                                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/login.jsp"><i class="bi bi-box-arrow-in-right"></i> Login</a></li>
                            </c:otherwise>
                        </c:choose>

                        <li class="nav-item">
                            <a class="nav-link position-relative" href="${pageContext.request.contextPath}/cart">
                                <i class="bi bi-cart3 fs-5"></i>
                            </a>
                        </li>
                    </ul>
                </div>
            </div>
        </nav>
    </header>

    <section class="bg-dark text-white text-center py-4">
        <div class="container">
            <h1 class="fw-bold mb-0"><i class="bi bi-basket3"></i> Our Menu</h1>
        </div>
    </section>

    <main class="container py-5">

        <c:if test="${not empty error}">
            <div class="alert alert-danger">${error}</div>
        </c:if>

        <%-- ===================================================================
             Single-item detail view.
             Rendered when the /menu servlet received an itemId param, looked
             the item up, and set request attribute "item" (a single MenuItem)
             before forwarding here — instead of "menuItems" (the full list).
             Linked to from each card below via ?itemId=... and from
             index.html's featured items.
        =================================================================== --%>
        <c:if test="${not empty item}">
            <a href="${pageContext.request.contextPath}/menu" class="btn btn-outline-primary btn-sm mb-4">
                <i class="bi bi-arrow-left"></i> Back to Menu
            </a>

            <div class="row g-4 justify-content-center">
                <div class="col-12 col-lg-5">
                    <img src="${not empty item.imageUrl ? item.imageUrl : 'https://placehold.co/600x450/e8d9c5/6b3f1d?text=No+Image'}"
                         class="img-fluid rounded shadow-sm w-100" alt="${item.name}"
                         style="max-height: 420px; object-fit: cover;"
                         onerror="this.onerror=null;this.src='https://placehold.co/600x450/e8d9c5/6b3f1d?text=No+Image';">
                </div>

                <div class="col-12 col-lg-6">
                    <div class="d-flex justify-content-between align-items-start mb-2">
                        <h1 class="fw-bold mb-0">${item.name}</h1>
                        <span class="badge bg-light text-dark border">${item.categoryName}</span>
                    </div>

                    <div class="text-warning mb-3">
                        <i class="bi bi-star-fill"></i>
                        <fmt:formatNumber value="${item.rating}" pattern="0.0"/> / 5
                    </div>

                    <p class="text-muted">${item.description}</p>

                    <c:if test="${not empty item.nutritionalInfo}">
                        <p class="text-muted small">
                            <i class="bi bi-info-circle"></i> ${item.nutritionalInfo}
                        </p>
                    </c:if>

                    <div class="fw-bold text-primary fs-3 mb-4">
                        RM <fmt:formatNumber value="${item.price}" pattern="#,##0.00"/>
                    </div>

                    <c:choose>
                        <c:when test="${!item.available}">
                            <button class="btn btn-secondary btn-lg" disabled>
                                <i class="bi bi-x-circle"></i> Currently Unavailable
                            </button>
                        </c:when>
                        <c:otherwise>
                            <form action="${pageContext.request.contextPath}/cart" method="post"
                                  class="add-to-cart-form"
                                  onsubmit="return prepareAddToCart(this)">
                                <input type="hidden" name="action" value="add">
                                <input type="hidden" name="itemId" value="${item.itemId}">
                                <input type="hidden" name="addOns" class="addons-hidden-input">

                                <div class="mb-3">
                                    <label class="form-label fw-semibold mb-1">Add-ons</label>
                                    <div class="d-flex flex-wrap gap-3">
                                        <div class="form-check form-check-sm">
                                            <input class="form-check-input addon-checkbox" type="checkbox" value="Extra Cheese" id="detail-cheese-${item.itemId}">
                                            <label class="form-check-label" for="detail-cheese-${item.itemId}">Extra Cheese</label>
                                        </div>
                                        <div class="form-check form-check-sm">
                                            <input class="form-check-input addon-checkbox" type="checkbox" value="Extra Rice" id="detail-rice-${item.itemId}">
                                            <label class="form-check-label" for="detail-rice-${item.itemId}">Extra Rice</label>
                                        </div>
                                        <div class="form-check form-check-sm">
                                            <input class="form-check-input addon-checkbox" type="checkbox" value="Add Drink" id="detail-drink-${item.itemId}">
                                            <label class="form-check-label" for="detail-drink-${item.itemId}">Add Drink</label>
                                        </div>
                                    </div>
                                </div>

                                <div class="d-flex gap-2">
                                    <input type="number" name="quantity" class="form-control item-quantity"
                                           value="1" min="1" max="20" style="width: 90px;" required>
                                    <button type="submit" class="btn btn-primary btn-lg flex-grow-1">
                                        <i class="bi bi-cart-plus"></i> Add to Cart
                                    </button>
                                </div>
                                <div class="text-danger small mt-1 qty-feedback"></div>
                            </form>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </c:if>

        <%-- ==== Full menu grid (default view — hidden while a single item is shown) ==== --%>
        <c:if test="${empty item}">

        <!-- Category filter tabs -->
        <div class="d-flex flex-wrap gap-2 justify-content-center mb-5">
            <a href="${pageContext.request.contextPath}/menu"
               class="btn ${empty selectedCategoryId ? 'btn-primary' : 'btn-outline-primary'}">
                All Items
            </a>
            <c:forEach var="cat" items="${categories}">
                <a href="${pageContext.request.contextPath}/menu?categoryId=${cat.categoryId}"
                   class="btn ${selectedCategoryId == cat.categoryId ? 'btn-primary' : 'btn-outline-primary'}">
                    ${cat.categoryName}
                </a>
            </c:forEach>
        </div>

        <c:choose>
            <c:when test="${empty menuItems}">
                <div class="text-center py-5">
                    <i class="bi bi-emoji-frown text-muted" style="font-size:3rem;"></i>
                    <h4 class="mt-3 text-muted">No items found in this category.</h4>
                </div>
            </c:when>
            <c:otherwise>
                <div class="row g-4">
                    <c:forEach var="item" items="${menuItems}">
                        <div class="col-12 col-sm-6 col-lg-4">
                            <div class="card h-100 border-0 shadow-sm">
                                <a href="${pageContext.request.contextPath}/menu?itemId=${item.itemId}">
                                    <img src="${not empty item.imageUrl ? item.imageUrl : 'https://placehold.co/400x280/e8d9c5/6b3f1d?text=No+Image'}"
                                         class="card-img-top" alt="${item.name}"
                                         style="height: 200px; object-fit: cover;"
                                         onerror="this.onerror=null;this.src='https://placehold.co/400x280/e8d9c5/6b3f1d?text=No+Image';">
                                </a>

                                <div class="card-body d-flex flex-column">
                                    <div class="d-flex justify-content-between align-items-start mb-1">
                                        <h5 class="card-title mb-0">
                                            <a href="${pageContext.request.contextPath}/menu?itemId=${item.itemId}" class="text-decoration-none text-reset">
                                                ${item.name}
                                            </a>
                                        </h5>
                                        <span class="badge bg-light text-dark border">${item.categoryName}</span>
                                    </div>

                                    <div class="text-warning small mb-2">
                                        <i class="bi bi-star-fill"></i>
                                        <fmt:formatNumber value="${item.rating}" pattern="0.0"/> / 5
                                    </div>

                                    <p class="text-muted small mb-2">${item.description}</p>

                                    <c:if test="${not empty item.nutritionalInfo}">
                                        <p class="text-muted small mb-2">
                                            <i class="bi bi-info-circle"></i> ${item.nutritionalInfo}
                                        </p>
                                    </c:if>

                                    <div class="d-flex justify-content-between align-items-center mb-3">
                                        <div class="fw-bold text-primary fs-5">
                                            RM <fmt:formatNumber value="${item.price}" pattern="#,##0.00"/>
                                        </div>
                                        <a href="${pageContext.request.contextPath}/menu?itemId=${item.itemId}" class="small">
                                            View Details <i class="bi bi-arrow-right"></i>
                                        </a>
                                    </div>

                                    <c:choose>
                                        <c:when test="${!item.available}">
                                            <button class="btn btn-secondary mt-auto" disabled>
                                                <i class="bi bi-x-circle"></i> Currently Unavailable
                                            </button>
                                        </c:when>
                                        <c:otherwise>
                                            <form action="${pageContext.request.contextPath}/cart" method="post"
                                                  class="mt-auto add-to-cart-form"
                                                  onsubmit="return prepareAddToCart(this)">
                                                <input type="hidden" name="action" value="add">
                                                <input type="hidden" name="itemId" value="${item.itemId}">
                                                <input type="hidden" name="addOns" class="addons-hidden-input">

                                                <div class="mb-2">
                                                    <label class="form-label small fw-semibold mb-1">Add-ons</label>
                                                    <div class="d-flex flex-wrap gap-3">
                                                        <div class="form-check form-check-sm">
                                                            <input class="form-check-input addon-checkbox" type="checkbox" value="Extra Cheese" id="cheese-${item.itemId}">
                                                            <label class="form-check-label small" for="cheese-${item.itemId}">Extra Cheese</label>
                                                        </div>
                                                        <div class="form-check form-check-sm">
                                                            <input class="form-check-input addon-checkbox" type="checkbox" value="Extra Rice" id="rice-${item.itemId}">
                                                            <label class="form-check-label small" for="rice-${item.itemId}">Extra Rice</label>
                                                        </div>
                                                        <div class="form-check form-check-sm">
                                                            <input class="form-check-input addon-checkbox" type="checkbox" value="Add Drink" id="drink-${item.itemId}">
                                                            <label class="form-check-label small" for="drink-${item.itemId}">Add Drink</label>
                                                        </div>
                                                    </div>
                                                </div>

                                                <div class="d-flex gap-2">
                                                    <input type="number" name="quantity" class="form-control item-quantity"
                                                           value="1" min="1" max="20" style="width: 80px;" required>
                                                    <button type="submit" class="btn btn-primary flex-grow-1">
                                                        <i class="bi bi-cart-plus"></i> Add to Cart
                                                    </button>
                                                </div>
                                                <div class="text-danger small mt-1 qty-feedback"></div>
                                            </form>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>

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
