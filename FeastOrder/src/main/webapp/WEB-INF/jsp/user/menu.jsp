<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.feastorder.model.MenuItem" %>
<%@ page import="com.feastorder.model.Category" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>FeastOrder - Menu</title>
    
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

    <style>
        /* ==== Per-card cart controls (quantity stepper / remove, shown only if already in cart) ==== */
        .dish-cart-controls {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 0.5rem;
            margin-top: 0.5rem;
            margin-bottom: 0.25rem;
        }
        .dish-cart-controls form { margin: 0; }

        .qty-stepper {
            display: inline-flex;
            align-items: center;
            border: 1px solid var(--color-border);
            border-radius: 999px;
            overflow: hidden;
            background: var(--c-ink);
        }
        .qty-stepper-sm button {
            width: 32px;
            height: 32px;
            border: none;
            background: transparent;
            color: var(--c-gold-light);
            font-size: 0.95rem;
            line-height: 1;
        }
        .qty-stepper-sm button:hover { background: rgba(211,152,88,0.22); }
        .qty-stepper-value {
            display: inline-block;
            min-width: 24px;
            text-align: center;
            color: #fff;
            font-weight: 700;
            font-family: var(--font-heading);
            font-size: 0.9rem;
        }

        .dish-remove-btn {
            border: 1px solid rgba(133,67,30,0.4);
            background: transparent;
            color: var(--c-rust);
            border-radius: 999px;
            padding: 0.3rem 0.75rem;
            font-size: 0.75rem;
            font-weight: 600;
            white-space: nowrap;
        }
        .dish-remove-btn:hover { background: rgba(133,67,30,0.12); }

        /* ==== Floating page-level "go to cart" button ==== */
        .floating-cart-btn {
            position: fixed;
            right: 24px;
            bottom: 24px;
            z-index: 1030;
            width: 58px;
            height: 58px;
            border-radius: 50%;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg, var(--c-gold) 0%, var(--c-gold-dark) 100%);
            color: var(--c-ink);
            font-size: 1.4rem;
            box-shadow: var(--shadow-gold), var(--shadow-lg);
            transition: var(--transition);
        }
        .floating-cart-btn:hover { color: var(--c-ink); filter: brightness(1.07); transform: translateY(-2px); }
        .floating-cart-badge {
            position: absolute;
            top: -4px;
            right: -4px;
            min-width: 22px;
            height: 22px;
            padding: 0 5px;
            border-radius: 999px;
            background: var(--c-rust);
            color: #fff;
            font-size: 0.72rem;
            font-weight: 700;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-family: var(--font-body);
        }
        
        /* ==== Menu grid — category divisions + dish tiles ==== */
        .menu-section-header {
            text-align: center;
            margin: 3.5rem 0 2rem;
        }
        .menu-section-header:first-of-type { margin-top: 0; }
        .menu-section-header .section-eyebrow {
            display: inline-block;
            font-family: var(--font-body);
            letter-spacing: 0.18em;
            text-transform: uppercase;
            font-size: 0.78rem;
            font-weight: 600;
            color: var(--color-accent-dark);
        }
        .menu-section-header h2 { margin: 0.2rem 0 0.5rem; }
        .menu-section-header .section-divider {
            width: 130px;
            height: 18px;
            margin: 0 auto;
            background-image: var(--ornament-divider);
            background-repeat: no-repeat;
            background-position: center;
            background-size: contain;
        }

        .menu-jump-nav {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            gap: 0.5rem 1.5rem;
            margin-bottom: 2rem;
            font-family: var(--font-body);
        }
        .menu-jump-nav a {
            font-size: 0.85rem;
            letter-spacing: 0.06em;
            text-transform: uppercase;
            font-weight: 600;
            text-decoration: none;
            color: var(--color-heading);
        }
        .menu-jump-nav a:hover { color: var(--c-gold-dark); }

        .dish-card {
            background: var(--color-bg-surface);
            border-radius: var(--radius-md);
            overflow: hidden;
            border: 1px solid var(--color-border);
            transition: var(--transition);
            height: 100%;
            display: flex;
            flex-direction: column;
        }
        .dish-card:hover {
            transform: translateY(-6px);
            box-shadow: var(--shadow-lg);
            border-color: var(--c-gold);
        }
        .dish-photo {
            position: relative;
            height: 200px;
            background-size: cover;
            background-position: center;
        }
        .dish-photo::after {
            content: "";
            position: absolute;
            inset: 0;
            background: linear-gradient(180deg, rgba(17,26,25,0) 55%, rgba(17,26,25,0.55) 100%);
            pointer-events: none;
        }
        .dish-badge {
            position: absolute;
            top: 12px;
            z-index: 2;
            padding: 0.3rem 0.7rem;
            border-radius: 999px;
            font-size: 0.72rem;
            font-weight: 700;
            backdrop-filter: blur(3px);
        }
        .dish-badge-available { left: 12px; background: rgba(128,153,118,0.85); color: #fff; }
        .dish-badge-unavailable { left: 12px; background: rgba(133,67,30,0.85); color: #fff; }
        .dish-badge-price { right: 12px; background: rgba(17,26,25,0.75); color: var(--c-gold-light); font-family: var(--font-heading); }

        .dish-info { padding: 1.15rem 1.25rem 1.35rem; display: flex; flex-direction: column; flex-grow: 1; }
        .dish-info h5 { margin-bottom: 0.2rem; }
        .dish-rating { color: var(--c-gold-dark); font-size: 0.82rem; margin-bottom: 0.4rem; }
        .dish-desc { color: var(--color-text-muted); font-size: 0.88rem; flex-grow: 1; }
        .dish-view-link {
            margin-top: 0.75rem;
            font-size: 0.85rem;
            font-weight: 600;
            color: var(--color-accent-dark);
            text-decoration: none;
        }
        .dish-view-link:hover { color: var(--c-rust); }

        /* ==== Category filter pills ==== */
        .menu-filter-bar {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            gap: 0.6rem;
            margin-bottom: 2.5rem;
        }
        .filter-pill {
            padding: 0.5rem 1.25rem;
            border-radius: 999px;
            border: 1px solid var(--color-border);
            background: var(--color-bg-surface);
            color: var(--color-text-body);
            font-weight: 600;
            font-size: 0.88rem;
            cursor: pointer;
            transition: var(--transition);
        }
        .filter-pill:hover { border-color: var(--c-gold); color: var(--c-gold-dark); }
        .filter-pill.active {
            background: linear-gradient(135deg, var(--c-gold) 0%, var(--c-gold-dark) 100%);
            border-color: var(--c-gold);
            color: var(--c-ink);
            box-shadow: var(--shadow-gold);
        }

        /* ==== Division panels — clearer visual separation between categories ==== */
        .menu-division {
            background: var(--color-bg-surface-alt);
            border: 1px solid var(--color-border);
            border-radius: var(--radius-lg);
            padding: 2.5rem 1.5rem;
            margin-bottom: 3rem;
        }
        .menu-division:last-of-type { margin-bottom: 0; }
        @media (min-width: 992px) {
            .menu-division { padding: 3rem 3rem 2.5rem; }
        }

        .division-icon-medallion {
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
            margin-bottom: 0.75rem;
        }

    </style>
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

    <c:set var="totalCartQty" value="${0}"/>
    <c:forEach var="cartLineForCount" items="${sessionScope.cart}">
        <c:set var="totalCartQty" value="${totalCartQty + cartLineForCount.quantity}"/>
    </c:forEach>

    <a href="${pageContext.request.contextPath}/cart" class="floating-cart-btn" aria-label="Go to cart" title="Go to cart">
        <i class="bi bi-bag-fill"></i>
        <c:if test="${totalCartQty > 0}">
            <span class="floating-cart-badge">${totalCartQty}</span>
        </c:if>
    </a>

    <main class="container py-5">

        <c:choose>
            <%-- ============================================================
                 SINGLE-ITEM DETAIL VIEW
                 Shown when MenuServlet was hit with ?itemId=N. Works for ANY
                 menu item - including ones added later through the admin
                 panel - because it reads entirely from the ${item} object
                 MenuServlet already loads via MenuDAO.getMenuItemById(),
                 rather than a separate hand-built page per dish.
                 ============================================================ --%>
            <c:when test="${not empty item}">

                <c:set var="cartQuantity" value="${0}"/>
                <c:set var="cartIndex" value="${-1}"/>
                <c:forEach var="cartLine" items="${sessionScope.cart}" varStatus="cartLoop">
                    <c:if test="${cartLine.menuItemId == item.itemId}">
                        <c:set var="cartQuantity" value="${cartLine.quantity}"/>
                        <c:set var="cartIndex" value="${cartLoop.index}"/>
                    </c:if>
                </c:forEach>

                <c:choose>
                    <c:when test="${fn:startsWith(item.imageUrl, 'http')}">
                        <c:set var="heroImageUrl" value="${item.imageUrl}"/>
                    </c:when>
                    <c:when test="${not empty item.imageUrl}">
                        <c:set var="heroImageUrl" value="${pageContext.request.contextPath}/${item.imageUrl}"/>
                    </c:when>
                    <c:otherwise>
                        <c:set var="heroImageUrl" value="${pageContext.request.contextPath}/image/FO_appetizer.jpg"/>
                    </c:otherwise>
                </c:choose>

                <div class="item-detail-hero" style="background-image: url('${heroImageUrl}');">
                    <div class="item-detail-hero-overlay"></div>
                    <a href="${pageContext.request.contextPath}/menu" class="item-detail-close" aria-label="Back to menu" title="Back to menu">
                        <i class="bi bi-x-lg"></i>
                    </a>
                </div>

                <div class="item-detail-card">

                    <div class="d-flex justify-content-between align-items-start">
                        <div>
                            <span class="category-label">${item.categoryName}</span>
                            <h1 class="fs-2 fw-bold mb-0">${item.name}</h1>
                        </div>
                    </div>

                    <div class="mt-2 mb-3 d-flex align-items-center flex-wrap gap-2">
                        <span class="star-rating text-warning">
                            <i class="bi bi-star-fill"></i>
                            <span class="ms-1"><fmt:formatNumber value="${item.rating}" minFractionDigits="1" maxFractionDigits="1"/> / 5</span>
                        </span>
                        <span class="tag-pill">${item.categoryName}</span>
                        <c:choose>
                            <c:when test="${item.available}">
                                <span class="tag-pill tag-pill-available"><i class="bi bi-check-circle"></i> Available Now</span>
                            </c:when>
                            <c:otherwise>
                                <span class="tag-pill tag-pill-unavailable"><i class="bi bi-x-circle"></i> Currently Unavailable</span>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <h6 class="detail-section-label">Description</h6>
                    <p class="mb-3" style="opacity:0.85;">${item.description}</p>

                    <c:if test="${not empty item.ingredients}">
                        <h6 class="detail-section-label">Ingredients</h6>
                        <div class="ingredient-grid mb-3">
                            <c:forEach var="ingredientToken" items="${fn:split(item.ingredients, ',')}">
                                <c:set var="ingredientParts" value="${fn:split(fn:trim(ingredientToken), ':')}"/>
                                <div class="ingredient-row">
                                    <span>${ingredientParts[0]}</span>
                                    <c:if test="${fn:length(ingredientParts) > 1}">
                                        <span class="ingredient-qty">${fn:trim(ingredientParts[1])}</span>
                                    </c:if>
                                </div>
                            </c:forEach>
                        </div>
                    </c:if>

                    <div class="item-divider"></div>

                    <c:if test="${not empty item.nutritionalInfo}">
                        <h6 class="detail-section-label">Nutritional Information</h6>
                        <div class="d-flex flex-wrap gap-2 mb-4">
                            <c:forEach var="stat" items="${fn:split(item.nutritionalInfo, ',')}">
                                <div class="stat-chip"><div class="stat-value">${fn:trim(stat)}</div></div>
                            </c:forEach>
                        </div>
                    </c:if>

                    <c:if test="${cartQuantity > 0}">
                        <div class="cart-status-banner">
                            <div class="cart-status-text">
                                <i class="bi bi-bag-check-fill"></i>
                                In your cart: <strong>${cartQuantity}</strong>
                            </div>
                            <div class="cart-status-controls">
                                <form action="${pageContext.request.contextPath}/cart" method="post">
                                    <input type="hidden" name="index" value="${cartIndex}">
                                    <c:choose>
                                        <c:when test="${cartQuantity > 1}">
                                            <input type="hidden" name="action" value="update">
                                            <input type="hidden" name="quantity" value="${cartQuantity - 1}">
                                        </c:when>
                                        <c:otherwise>
                                            <input type="hidden" name="action" value="remove">
                                        </c:otherwise>
                                    </c:choose>
                                    <button type="submit" aria-label="Decrease quantity in cart">&minus;</button>
                                </form>
                                <form action="${pageContext.request.contextPath}/cart" method="post">
                                    <input type="hidden" name="action" value="update">
                                    <input type="hidden" name="index" value="${cartIndex}">
                                    <input type="hidden" name="quantity" value="${cartQuantity + 1}">
                                    <button type="submit" aria-label="Increase quantity in cart">+</button>
                                </form>
                                <form action="${pageContext.request.contextPath}/cart" method="post">
                                    <input type="hidden" name="action" value="remove">
                                    <input type="hidden" name="index" value="${cartIndex}">
                                    <button type="submit" class="cart-status-remove">Remove</button>
                                </form>
                            </div>
                        </div>
                    </c:if>

                    <c:choose>
                        <c:when test="${item.available}">
                            <form action="${pageContext.request.contextPath}/cart" method="post"
                                  class="add-to-cart-form"
                                  onsubmit="return prepareAddToCart(this)">
                                <input type="hidden" name="action" value="add">
                                <input type="hidden" name="itemId" value="${item.itemId}">
                                <input type="hidden" name="addOns" class="addons-hidden-input">

                                <c:if test="${not empty item.addonOptions}">
                                    <div class="mb-4">
                                        <h6 class="detail-section-label">Add-ons</h6>
                                        <div class="d-flex flex-wrap gap-2">
                                            <c:forEach var="addonName" items="${fn:split(item.addonOptions, ',')}" varStatus="addonLoop">
                                                <c:set var="addonTrimmed" value="${fn:trim(addonName)}"/>
                                                <c:set var="addonInputId" value="addon-${item.itemId}-${addonLoop.index}"/>
                                                <input class="addon-pill-input addon-checkbox" type="checkbox" value="${addonTrimmed}" id="${addonInputId}">
                                                <label class="addon-pill-label" for="${addonInputId}">${addonTrimmed}</label>
                                            </c:forEach>
                                        </div>
                                    </div>
                                </c:if>
                                <div class="text-danger small mb-2 qty-feedback"></div>

                                <div class="detail-sticky-bar">
                                    <span class="item-detail-price">
                                        RM <fmt:formatNumber value="${item.price}" minFractionDigits="2" maxFractionDigits="2"/>
                                    </span>
                                    <div class="qty-stepper">
                                        <button type="button" onclick="stepQuantity(this, -1)" aria-label="Decrease quantity">&minus;</button>
                                        <input type="number" name="quantity" class="item-quantity" value="1" min="1" max="20" required readonly>
                                        <button type="button" onclick="stepQuantity(this, 1)" aria-label="Increase quantity">+</button>
                                    </div>
                                    <button type="submit" class="btn btn-detail-cta btn-lg flex-grow-1">
                                        <i class="bi bi-cart-plus"></i> Add to Cart
                                    </button>
                                </div>
                            </form>
                            <div class="detail-sticky-bar-spacer"></div>
                        </c:when>
                        <c:otherwise>
                            <div class="detail-sticky-bar">
                                <span class="item-detail-price">
                                    RM <fmt:formatNumber value="${item.price}" minFractionDigits="2" maxFractionDigits="2"/>
                                </span>
                                <button type="button" class="btn btn-detail-cta btn-lg flex-grow-1" disabled>
                                    Currently Unavailable
                                </button>
                            </div>
                            <div class="detail-sticky-bar-spacer"></div>
                        </c:otherwise>
                    </c:choose>

                </div>

            </c:when>

            <%-- ============================================================
                 MENU GRID VIEW
                 Loops over ${menuItems} and ${categories} - both loaded from
                 the database by MenuServlet/MenuDAO. Any item added, edited,
                 or deleted through the admin panel appears here automatically
                 on the next page load, since nothing is hardcoded anymore.
                 ============================================================ --%>
            <c:otherwise>

                <section class="bg-dark text-white text-center py-4 mb-4 rounded-4">
                    <h1 class="fw-bold mb-0"><i class="bi bi-basket3"></i> Our Menu</h1>
                </section>

                <c:if test="${not empty error}">
                    <div class="alert alert-danger">${error}</div>
                </c:if>

                <div class="menu-filter-bar">
                    <button type="button" class="filter-pill active" data-filter="all">
                        <i class="bi bi-grid"></i> All
                    </button>
                    <c:forEach var="cat" items="${categories}">
                        <button type="button" class="filter-pill" data-filter="${cat.categoryId}">${cat.categoryName}</button>
                    </c:forEach>
                </div>

                <c:forEach var="cat" items="${categories}">
                    <div class="menu-division" data-filter="${cat.categoryId}">
                        <div class="menu-section-header">
                            <div class="division-icon-medallion">
                                <c:choose>
                                    <c:when test="${fn:containsIgnoreCase(cat.categoryName, 'appetizer')}"><i class="bi bi-egg-fried"></i></c:when>
                                    <c:when test="${fn:containsIgnoreCase(cat.categoryName, 'main')}"><i class="bi bi-fire"></i></c:when>
                                    <c:when test="${fn:containsIgnoreCase(cat.categoryName, 'dessert')}"><i class="bi bi-cake2"></i></c:when>
                                    <c:when test="${fn:containsIgnoreCase(cat.categoryName, 'beverage') or fn:containsIgnoreCase(cat.categoryName, 'drink')}"><i class="bi bi-cup-straw"></i></c:when>
                                    <c:otherwise><i class="bi bi-star"></i></c:otherwise>
                                </c:choose>
                            </div>
                            <span class="section-eyebrow">Chef's Selection</span>
                            <h2 class="fw-bold">${cat.categoryName}</h2>
                            <div class="section-divider"></div>
                        </div>

                        <div class="row g-4 mb-5">
                            <c:forEach var="mi" items="${menuItems}">
                                <c:if test="${mi.categoryId == cat.categoryId}">

                                    <c:set var="cartQty" value="${0}"/>
                                    <c:set var="cartIdx" value="${-1}"/>
                                    <c:forEach var="cl" items="${sessionScope.cart}" varStatus="clStatus">
                                        <c:if test="${cl.menuItemId == mi.itemId}">
                                            <c:set var="cartQty" value="${cl.quantity}"/>
                                            <c:set var="cartIdx" value="${clStatus.index}"/>
                                        </c:if>
                                    </c:forEach>

                                    <c:choose>
                                        <c:when test="${fn:startsWith(mi.imageUrl, 'http')}">
                                            <c:set var="photoUrl" value="${mi.imageUrl}"/>
                                        </c:when>
                                        <c:when test="${not empty mi.imageUrl}">
                                            <c:set var="photoUrl" value="${pageContext.request.contextPath}/${mi.imageUrl}"/>
                                        </c:when>
                                        <c:otherwise>
                                            <c:set var="photoUrl" value=""/>
                                        </c:otherwise>
                                    </c:choose>

                                    <div class="col-12 col-sm-6 col-lg-4">
                                        <div class="dish-card">
                                            <a href="${pageContext.request.contextPath}/menu?itemId=${mi.itemId}">
                                                <div class="dish-photo" style="background-image: url('${photoUrl}');">
                                                    <c:choose>
                                                        <c:when test="${mi.available}">
                                                            <span class="dish-badge dish-badge-available">Available</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="dish-badge dish-badge-unavailable">Unavailable</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                    <span class="dish-badge dish-badge-price">
                                                        RM <fmt:formatNumber value="${mi.price}" minFractionDigits="2" maxFractionDigits="2"/>
                                                    </span>
                                                </div>
                                            </a>
                                            <div class="dish-info">
                                                <h5><a href="${pageContext.request.contextPath}/menu?itemId=${mi.itemId}" class="text-decoration-none text-reset">${mi.name}</a></h5>
                                                <div class="dish-rating">
                                                    <i class="bi bi-star-fill"></i>
                                                    <fmt:formatNumber value="${mi.rating}" minFractionDigits="1" maxFractionDigits="1"/> / 5
                                                </div>
                                                <p class="dish-desc">${mi.description}</p>

                                                <c:if test="${cartQty > 0}">
                                                    <div class="dish-cart-controls">
                                                        <div class="qty-stepper qty-stepper-sm">
                                                            <form action="${pageContext.request.contextPath}/cart" method="post">
                                                                <input type="hidden" name="index" value="${cartIdx}">
                                                                <c:choose>
                                                                    <c:when test="${cartQty > 1}">
                                                                        <input type="hidden" name="action" value="update">
                                                                        <input type="hidden" name="quantity" value="${cartQty - 1}">
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <input type="hidden" name="action" value="remove">
                                                                    </c:otherwise>
                                                                </c:choose>
                                                                <button type="submit" aria-label="Decrease quantity">&minus;</button>
                                                            </form>
                                                            <span class="qty-stepper-value">${cartQty}</span>
                                                            <form action="${pageContext.request.contextPath}/cart" method="post">
                                                                <input type="hidden" name="action" value="update">
                                                                <input type="hidden" name="index" value="${cartIdx}">
                                                                <input type="hidden" name="quantity" value="${cartQty + 1}">
                                                                <button type="submit" aria-label="Increase quantity">+</button>
                                                            </form>
                                                        </div>
                                                        <form action="${pageContext.request.contextPath}/cart" method="post">
                                                            <input type="hidden" name="action" value="remove">
                                                            <input type="hidden" name="index" value="${cartIdx}">
                                                            <button type="submit" class="dish-remove-btn">
                                                                <i class="bi bi-trash"></i> Remove
                                                            </button>
                                                        </form>
                                                    </div>
                                                </c:if>

                                                <a href="${pageContext.request.contextPath}/menu?itemId=${mi.itemId}" class="dish-view-link">
                                                    View Details <i class="bi bi-arrow-right"></i>
                                                </a>
                                            </div>
                                        </div>
                                    </div>

                                </c:if>
                            </c:forEach>
                        </div>
                    </div>
                </c:forEach>

            </c:otherwise>
        </c:choose>

    </main>

    <footer class="bg-dark text-white text-center py-4 mt-5">
        <div class="container">
            <p class="mb-0">&copy; 2026 FeastOrder. All rights reserved.</p>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/main.js"></script>

    <script>
        // Category filter pills — purely client-side. All items are already
        // rendered on the page, so a click just toggles which .menu-division
        // sections are visible; no server round-trip needed.
        document.querySelectorAll('.filter-pill').forEach(function (pill) {
            pill.addEventListener('click', function () {
                document.querySelectorAll('.filter-pill').forEach(function (p) {
                    p.classList.remove('active');
                });
                this.classList.add('active');

                var filter = this.dataset.filter;
                document.querySelectorAll('.menu-division').forEach(function (division) {
                    var matches = (filter === 'all' || division.dataset.filter === filter);
                    division.style.display = matches ? '' : 'none';
                });
            });
        });
    </script>

</body>
</html>