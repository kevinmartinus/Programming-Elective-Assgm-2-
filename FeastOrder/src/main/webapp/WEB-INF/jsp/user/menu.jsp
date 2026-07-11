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

    <section class="bg-dark text-white text-center py-4">
        <div class="container">
            <h1 class="fw-bold mb-0"><i class="bi bi-basket3"></i> Our Menu</h1>
        </div>
    </section>

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

        <c:if test="${not empty error}">
            <div class="alert alert-danger">${error}</div>
        </c:if>

        <div class="menu-filter-bar">
            <button type="button" class="filter-pill active" data-filter="all">
                <i class="bi bi-grid"></i> All
            </button>
            <button type="button" class="filter-pill" data-filter="appetizers">Appetizers</button>
            <button type="button" class="filter-pill" data-filter="mains">Main Courses</button>
            <button type="button" class="filter-pill" data-filter="desserts">Desserts</button>
            <button type="button" class="filter-pill" data-filter="beverages">Beverages</button>
        </div>

        <div class="menu-division" id="section-appetizers" data-filter="appetizers">
            <div class="menu-section-header">
                <div class="division-icon-medallion"><i class="bi bi-egg-fried"></i></div>
                <span class="section-eyebrow">Chef's Selection</span>
                <h2 class="fw-bold">Appetizers</h2>
                <div class="section-divider"></div>
            </div>

            <div class="row g-4 mb-5">

                <div class="col-12 col-sm-6 col-lg-4">
                    <div class="dish-card">
                        <a href="${pageContext.request.contextPath}/menu?itemId=1">
                            <div class="dish-photo" style="background-image: url('${pageContext.request.contextPath}/image/FO_springRoll.jpg');">
                                <span class="dish-badge dish-badge-available">Available</span>
                                <span class="dish-badge dish-badge-price">RM 5.90</span>
                            </div>
                        </a>
                        <div class="dish-info">
                            <h5><a href="${pageContext.request.contextPath}/menu?itemId=1" class="text-decoration-none text-reset">Spring Rolls</a></h5>
                            <div class="dish-rating"><i class="bi bi-star-fill"></i> 4.5 / 5</div>
                            <p class="dish-desc">Crispy rolls with cabbage, carrot, glass noodles</p>

                            <c:set var="cartQuantity1" value="${0}"/>
                            <c:set var="cartIndex1" value="${-1}"/>
                            <c:forEach var="cartLine" items="${sessionScope.cart}" varStatus="cartLoop">
                                <c:if test="${cartLine.menuItemId == 1}">
                                    <c:set var="cartQuantity1" value="${cartLine.quantity}"/>
                                    <c:set var="cartIndex1" value="${cartLoop.index}"/>
                                </c:if>
                            </c:forEach>

                            <c:if test="${cartQuantity1 > 0}">
                                <div class="dish-cart-controls">
                                    <div class="qty-stepper qty-stepper-sm">
                                        <form action="${pageContext.request.contextPath}/cart" method="post">
                                            <input type="hidden" name="index" value="${cartIndex1}">
                                            <c:choose>
                                                <c:when test="${cartQuantity1 > 1}">
                                                    <input type="hidden" name="action" value="update">
                                                    <input type="hidden" name="quantity" value="${cartQuantity1 - 1}">
                                                </c:when>
                                                <c:otherwise>
                                                    <input type="hidden" name="action" value="remove">
                                                </c:otherwise>
                                            </c:choose>
                                            <button type="submit" aria-label="Decrease quantity">&minus;</button>
                                        </form>
                                        <span class="qty-stepper-value">${cartQuantity1}</span>
                                        <form action="${pageContext.request.contextPath}/cart" method="post">
                                            <input type="hidden" name="action" value="update">
                                            <input type="hidden" name="index" value="${cartIndex1}">
                                            <input type="hidden" name="quantity" value="${cartQuantity1 + 1}">
                                            <button type="submit" aria-label="Increase quantity">+</button>
                                        </form>
                                    </div>
                                    <form action="${pageContext.request.contextPath}/cart" method="post">
                                        <input type="hidden" name="action" value="remove">
                                        <input type="hidden" name="index" value="${cartIndex1}">
                                        <button type="submit" class="dish-remove-btn">
                                            <i class="bi bi-trash"></i> Remove
                                        </button>
                                    </form>
                                </div>
                            </c:if>

                            <a href="${pageContext.request.contextPath}/menu?itemId=1" class="dish-view-link">
                                View Details <i class="bi bi-arrow-right"></i>
                            </a>
                        </div>
                    </div>
                </div>
                <div class="col-12 col-sm-6 col-lg-4">
                    <div class="dish-card">
                        <a href="${pageContext.request.contextPath}/menu?itemId=2">
                            <div class="dish-photo" style="background-image: url('${pageContext.request.contextPath}/image/FO_appetizer.jpg');">
                                <span class="dish-badge dish-badge-available">Available</span>
                                <span class="dish-badge dish-badge-price">RM 7.50</span>
                            </div>
                        </a>
                        <div class="dish-info">
                            <h5><a href="${pageContext.request.contextPath}/menu?itemId=2" class="text-decoration-none text-reset">Garden Salad Bites</a></h5>
                            <div class="dish-rating"><i class="bi bi-star-fill"></i> 4.6 / 5</div>
                            <p class="dish-desc">Fresh mixed greens, cherry tomato, avocado, citrus vinaigrette</p>

                            <c:set var="cartQuantity2" value="${0}"/>
                            <c:set var="cartIndex2" value="${-1}"/>
                            <c:forEach var="cartLine" items="${sessionScope.cart}" varStatus="cartLoop">
                                <c:if test="${cartLine.menuItemId == 2}">
                                    <c:set var="cartQuantity2" value="${cartLine.quantity}"/>
                                    <c:set var="cartIndex2" value="${cartLoop.index}"/>
                                </c:if>
                            </c:forEach>

                            <c:if test="${cartQuantity2 > 0}">
                                <div class="dish-cart-controls">
                                    <div class="qty-stepper qty-stepper-sm">
                                        <form action="${pageContext.request.contextPath}/cart" method="post">
                                            <input type="hidden" name="index" value="${cartIndex2}">
                                            <c:choose>
                                                <c:when test="${cartQuantity2 > 1}">
                                                    <input type="hidden" name="action" value="update">
                                                    <input type="hidden" name="quantity" value="${cartQuantity2 - 1}">
                                                </c:when>
                                                <c:otherwise>
                                                    <input type="hidden" name="action" value="remove">
                                                </c:otherwise>
                                            </c:choose>
                                            <button type="submit" aria-label="Decrease quantity">&minus;</button>
                                        </form>
                                        <span class="qty-stepper-value">${cartQuantity2}</span>
                                        <form action="${pageContext.request.contextPath}/cart" method="post">
                                            <input type="hidden" name="action" value="update">
                                            <input type="hidden" name="index" value="${cartIndex2}">
                                            <input type="hidden" name="quantity" value="${cartQuantity2 + 1}">
                                            <button type="submit" aria-label="Increase quantity">+</button>
                                        </form>
                                    </div>
                                    <form action="${pageContext.request.contextPath}/cart" method="post">
                                        <input type="hidden" name="action" value="remove">
                                        <input type="hidden" name="index" value="${cartIndex2}">
                                        <button type="submit" class="dish-remove-btn">
                                            <i class="bi bi-trash"></i> Remove
                                        </button>
                                    </form>
                                </div>
                            </c:if>

                            <a href="${pageContext.request.contextPath}/menu?itemId=2" class="dish-view-link">
                                View Details <i class="bi bi-arrow-right"></i>
                            </a>
                        </div>
                    </div>
                </div>
                <div class="col-12 col-sm-6 col-lg-4">
                    <div class="dish-card">
                        <a href="${pageContext.request.contextPath}/menu?itemId=3">
                            <div class="dish-photo" style="background-image: url('https://placehold.co/400x280/e8d9c5/6b3f1d?text=Chicken+Satay');">
                                <span class="dish-badge dish-badge-available">Available</span>
                                <span class="dish-badge dish-badge-price">RM 8.90</span>
                            </div>
                        </a>
                        <div class="dish-info">
                            <h5><a href="${pageContext.request.contextPath}/menu?itemId=3" class="text-decoration-none text-reset">Chicken Satay Skewers</a></h5>
                            <div class="dish-rating"><i class="bi bi-star-fill"></i> 4.7 / 5</div>
                            <p class="dish-desc">Grilled marinated chicken skewers, peanut sauce, cucumber relish</p>

                            <c:set var="cartQuantity3" value="${0}"/>
                            <c:set var="cartIndex3" value="${-1}"/>
                            <c:forEach var="cartLine" items="${sessionScope.cart}" varStatus="cartLoop">
                                <c:if test="${cartLine.menuItemId == 3}">
                                    <c:set var="cartQuantity3" value="${cartLine.quantity}"/>
                                    <c:set var="cartIndex3" value="${cartLoop.index}"/>
                                </c:if>
                            </c:forEach>

                            <c:if test="${cartQuantity3 > 0}">
                                <div class="dish-cart-controls">
                                    <div class="qty-stepper qty-stepper-sm">
                                        <form action="${pageContext.request.contextPath}/cart" method="post">
                                            <input type="hidden" name="index" value="${cartIndex3}">
                                            <c:choose>
                                                <c:when test="${cartQuantity3 > 1}">
                                                    <input type="hidden" name="action" value="update">
                                                    <input type="hidden" name="quantity" value="${cartQuantity3 - 1}">
                                                </c:when>
                                                <c:otherwise>
                                                    <input type="hidden" name="action" value="remove">
                                                </c:otherwise>
                                            </c:choose>
                                            <button type="submit" aria-label="Decrease quantity">&minus;</button>
                                        </form>
                                        <span class="qty-stepper-value">${cartQuantity3}</span>
                                        <form action="${pageContext.request.contextPath}/cart" method="post">
                                            <input type="hidden" name="action" value="update">
                                            <input type="hidden" name="index" value="${cartIndex3}">
                                            <input type="hidden" name="quantity" value="${cartQuantity3 + 1}">
                                            <button type="submit" aria-label="Increase quantity">+</button>
                                        </form>
                                    </div>
                                    <form action="${pageContext.request.contextPath}/cart" method="post">
                                        <input type="hidden" name="action" value="remove">
                                        <input type="hidden" name="index" value="${cartIndex3}">
                                        <button type="submit" class="dish-remove-btn">
                                            <i class="bi bi-trash"></i> Remove
                                        </button>
                                    </form>
                                </div>
                            </c:if>

                            <a href="${pageContext.request.contextPath}/menu?itemId=3" class="dish-view-link">
                                View Details <i class="bi bi-arrow-right"></i>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="menu-division" id="section-mains" data-filter="mains">
            <div class="menu-section-header">
                <div class="division-icon-medallion"><i class="bi bi-fire"></i></div>
                <span class="section-eyebrow">Chef's Selection</span>
                <h2 class="fw-bold">Main Courses</h2>
                <div class="section-divider"></div>
            </div>

            <div class="row g-4 mb-5">

                <div class="col-12 col-sm-6 col-lg-4">
                    <div class="dish-card">
                        <a href="${pageContext.request.contextPath}/menu?itemId=4">
                            <div class="dish-photo" style="background-image: url('${pageContext.request.contextPath}/image/FO_grilledChickenRice.jpg');">
                                <span class="dish-badge dish-badge-available">Available</span>
                                <span class="dish-badge dish-badge-price">RM 12.90</span>
                            </div>
                        </a>
                        <div class="dish-info">
                            <h5><a href="${pageContext.request.contextPath}/menu?itemId=4" class="text-decoration-none text-reset">Grilled Chicken Rice</a></h5>
                            <div class="dish-rating"><i class="bi bi-star-fill"></i> 4.7 / 5</div>
                            <p class="dish-desc">Grilled chicken thigh, jasmine rice, side salad</p>

                            <c:set var="cartQuantity4" value="${0}"/>
                            <c:set var="cartIndex4" value="${-1}"/>
                            <c:forEach var="cartLine" items="${sessionScope.cart}" varStatus="cartLoop">
                                <c:if test="${cartLine.menuItemId == 4}">
                                    <c:set var="cartQuantity4" value="${cartLine.quantity}"/>
                                    <c:set var="cartIndex4" value="${cartLoop.index}"/>
                                </c:if>
                            </c:forEach>

                            <c:if test="${cartQuantity4 > 0}">
                                <div class="dish-cart-controls">
                                    <div class="qty-stepper qty-stepper-sm">
                                        <form action="${pageContext.request.contextPath}/cart" method="post">
                                            <input type="hidden" name="index" value="${cartIndex4}">
                                            <c:choose>
                                                <c:when test="${cartQuantity4 > 1}">
                                                    <input type="hidden" name="action" value="update">
                                                    <input type="hidden" name="quantity" value="${cartQuantity4 - 1}">
                                                </c:when>
                                                <c:otherwise>
                                                    <input type="hidden" name="action" value="remove">
                                                </c:otherwise>
                                            </c:choose>
                                            <button type="submit" aria-label="Decrease quantity">&minus;</button>
                                        </form>
                                        <span class="qty-stepper-value">${cartQuantity4}</span>
                                        <form action="${pageContext.request.contextPath}/cart" method="post">
                                            <input type="hidden" name="action" value="update">
                                            <input type="hidden" name="index" value="${cartIndex4}">
                                            <input type="hidden" name="quantity" value="${cartQuantity4 + 1}">
                                            <button type="submit" aria-label="Increase quantity">+</button>
                                        </form>
                                    </div>
                                    <form action="${pageContext.request.contextPath}/cart" method="post">
                                        <input type="hidden" name="action" value="remove">
                                        <input type="hidden" name="index" value="${cartIndex4}">
                                        <button type="submit" class="dish-remove-btn">
                                            <i class="bi bi-trash"></i> Remove
                                        </button>
                                    </form>
                                </div>
                            </c:if>

                            <a href="${pageContext.request.contextPath}/menu?itemId=4" class="dish-view-link">
                                View Details <i class="bi bi-arrow-right"></i>
                            </a>
                        </div>
                    </div>
                </div>
                <div class="col-12 col-sm-6 col-lg-4">
                    <div class="dish-card">
                        <a href="${pageContext.request.contextPath}/menu?itemId=5">
                            <div class="dish-photo" style="background-image: url('${pageContext.request.contextPath}/image/FO_beefBurger.jpg');">
                                <span class="dish-badge dish-badge-available">Available</span>
                                <span class="dish-badge dish-badge-price">RM 11.50</span>
                            </div>
                        </a>
                        <div class="dish-info">
                            <h5><a href="${pageContext.request.contextPath}/menu?itemId=5" class="text-decoration-none text-reset">Beef Burger</a></h5>
                            <div class="dish-rating"><i class="bi bi-star-fill"></i> 4.6 / 5</div>
                            <p class="dish-desc">Beef patty, cheddar, lettuce, tomato, brioche bun</p>

                            <c:set var="cartQuantity5" value="${0}"/>
                            <c:set var="cartIndex5" value="${-1}"/>
                            <c:forEach var="cartLine" items="${sessionScope.cart}" varStatus="cartLoop">
                                <c:if test="${cartLine.menuItemId == 5}">
                                    <c:set var="cartQuantity5" value="${cartLine.quantity}"/>
                                    <c:set var="cartIndex5" value="${cartLoop.index}"/>
                                </c:if>
                            </c:forEach>

                            <c:if test="${cartQuantity5 > 0}">
                                <div class="dish-cart-controls">
                                    <div class="qty-stepper qty-stepper-sm">
                                        <form action="${pageContext.request.contextPath}/cart" method="post">
                                            <input type="hidden" name="index" value="${cartIndex5}">
                                            <c:choose>
                                                <c:when test="${cartQuantity5 > 1}">
                                                    <input type="hidden" name="action" value="update">
                                                    <input type="hidden" name="quantity" value="${cartQuantity5 - 1}">
                                                </c:when>
                                                <c:otherwise>
                                                    <input type="hidden" name="action" value="remove">
                                                </c:otherwise>
                                            </c:choose>
                                            <button type="submit" aria-label="Decrease quantity">&minus;</button>
                                        </form>
                                        <span class="qty-stepper-value">${cartQuantity5}</span>
                                        <form action="${pageContext.request.contextPath}/cart" method="post">
                                            <input type="hidden" name="action" value="update">
                                            <input type="hidden" name="index" value="${cartIndex5}">
                                            <input type="hidden" name="quantity" value="${cartQuantity5 + 1}">
                                            <button type="submit" aria-label="Increase quantity">+</button>
                                        </form>
                                    </div>
                                    <form action="${pageContext.request.contextPath}/cart" method="post">
                                        <input type="hidden" name="action" value="remove">
                                        <input type="hidden" name="index" value="${cartIndex5}">
                                        <button type="submit" class="dish-remove-btn">
                                            <i class="bi bi-trash"></i> Remove
                                        </button>
                                    </form>
                                </div>
                            </c:if>

                            <a href="${pageContext.request.contextPath}/menu?itemId=5" class="dish-view-link">
                                View Details <i class="bi bi-arrow-right"></i>
                            </a>
                        </div>
                    </div>
                </div>
                <div class="col-12 col-sm-6 col-lg-4">
                    <div class="dish-card">
                        <a href="${pageContext.request.contextPath}/menu?itemId=6">
                            <div class="dish-photo" style="background-image: url('${pageContext.request.contextPath}/image/FO_mainCourse.jpg');">
                                <span class="dish-badge dish-badge-available">Available</span>
                                <span class="dish-badge dish-badge-price">RM 18.90</span>
                            </div>
                        </a>
                        <div class="dish-info">
                            <h5><a href="${pageContext.request.contextPath}/menu?itemId=6" class="text-decoration-none text-reset">Signature Chef's Platter</a></h5>
                            <div class="dish-rating"><i class="bi bi-star-fill"></i> 4.8 / 5</div>
                            <p class="dish-desc">Chef's daily selection of grilled meats, roasted vegetables, jus</p>

                            <c:set var="cartQuantity6" value="${0}"/>
                            <c:set var="cartIndex6" value="${-1}"/>
                            <c:forEach var="cartLine" items="${sessionScope.cart}" varStatus="cartLoop">
                                <c:if test="${cartLine.menuItemId == 6}">
                                    <c:set var="cartQuantity6" value="${cartLine.quantity}"/>
                                    <c:set var="cartIndex6" value="${cartLoop.index}"/>
                                </c:if>
                            </c:forEach>

                            <c:if test="${cartQuantity6 > 0}">
                                <div class="dish-cart-controls">
                                    <div class="qty-stepper qty-stepper-sm">
                                        <form action="${pageContext.request.contextPath}/cart" method="post">
                                            <input type="hidden" name="index" value="${cartIndex6}">
                                            <c:choose>
                                                <c:when test="${cartQuantity6 > 1}">
                                                    <input type="hidden" name="action" value="update">
                                                    <input type="hidden" name="quantity" value="${cartQuantity6 - 1}">
                                                </c:when>
                                                <c:otherwise>
                                                    <input type="hidden" name="action" value="remove">
                                                </c:otherwise>
                                            </c:choose>
                                            <button type="submit" aria-label="Decrease quantity">&minus;</button>
                                        </form>
                                        <span class="qty-stepper-value">${cartQuantity6}</span>
                                        <form action="${pageContext.request.contextPath}/cart" method="post">
                                            <input type="hidden" name="action" value="update">
                                            <input type="hidden" name="index" value="${cartIndex6}">
                                            <input type="hidden" name="quantity" value="${cartQuantity6 + 1}">
                                            <button type="submit" aria-label="Increase quantity">+</button>
                                        </form>
                                    </div>
                                    <form action="${pageContext.request.contextPath}/cart" method="post">
                                        <input type="hidden" name="action" value="remove">
                                        <input type="hidden" name="index" value="${cartIndex6}">
                                        <button type="submit" class="dish-remove-btn">
                                            <i class="bi bi-trash"></i> Remove
                                        </button>
                                    </form>
                                </div>
                            </c:if>

                            <a href="${pageContext.request.contextPath}/menu?itemId=6" class="dish-view-link">
                                View Details <i class="bi bi-arrow-right"></i>
                            </a>
                        </div>
                    </div>
                </div>
                <div class="col-12 col-sm-6 col-lg-4">
                    <div class="dish-card">
                        <a href="${pageContext.request.contextPath}/menu?itemId=7">
                            <div class="dish-photo" style="background-image: url('https://placehold.co/400x280/e8d9c5/6b3f1d?text=Prawn+Pasta');">
                                <span class="dish-badge dish-badge-available">Available</span>
                                <span class="dish-badge dish-badge-price">RM 16.50</span>
                            </div>
                        </a>
                        <div class="dish-info">
                            <h5><a href="${pageContext.request.contextPath}/menu?itemId=7" class="text-decoration-none text-reset">Butter Garlic Prawn Pasta</a></h5>
                            <div class="dish-rating"><i class="bi bi-star-fill"></i> 4.7 / 5</div>
                            <p class="dish-desc">Linguine tossed in butter garlic sauce with pan-seared prawns</p>

                            <c:set var="cartQuantity7" value="${0}"/>
                            <c:set var="cartIndex7" value="${-1}"/>
                            <c:forEach var="cartLine" items="${sessionScope.cart}" varStatus="cartLoop">
                                <c:if test="${cartLine.menuItemId == 7}">
                                    <c:set var="cartQuantity7" value="${cartLine.quantity}"/>
                                    <c:set var="cartIndex7" value="${cartLoop.index}"/>
                                </c:if>
                            </c:forEach>

                            <c:if test="${cartQuantity7 > 0}">
                                <div class="dish-cart-controls">
                                    <div class="qty-stepper qty-stepper-sm">
                                        <form action="${pageContext.request.contextPath}/cart" method="post">
                                            <input type="hidden" name="index" value="${cartIndex7}">
                                            <c:choose>
                                                <c:when test="${cartQuantity7 > 1}">
                                                    <input type="hidden" name="action" value="update">
                                                    <input type="hidden" name="quantity" value="${cartQuantity7 - 1}">
                                                </c:when>
                                                <c:otherwise>
                                                    <input type="hidden" name="action" value="remove">
                                                </c:otherwise>
                                            </c:choose>
                                            <button type="submit" aria-label="Decrease quantity">&minus;</button>
                                        </form>
                                        <span class="qty-stepper-value">${cartQuantity7}</span>
                                        <form action="${pageContext.request.contextPath}/cart" method="post">
                                            <input type="hidden" name="action" value="update">
                                            <input type="hidden" name="index" value="${cartIndex7}">
                                            <input type="hidden" name="quantity" value="${cartQuantity7 + 1}">
                                            <button type="submit" aria-label="Increase quantity">+</button>
                                        </form>
                                    </div>
                                    <form action="${pageContext.request.contextPath}/cart" method="post">
                                        <input type="hidden" name="action" value="remove">
                                        <input type="hidden" name="index" value="${cartIndex7}">
                                        <button type="submit" class="dish-remove-btn">
                                            <i class="bi bi-trash"></i> Remove
                                        </button>
                                    </form>
                                </div>
                            </c:if>

                            <a href="${pageContext.request.contextPath}/menu?itemId=7" class="dish-view-link">
                                View Details <i class="bi bi-arrow-right"></i>
                            </a>
                        </div>
                    </div>
                </div>
                <div class="col-12 col-sm-6 col-lg-4">
                    <div class="dish-card">
                        <a href="${pageContext.request.contextPath}/menu?itemId=8">
                            <div class="dish-photo" style="background-image: url('https://placehold.co/400x280/e8d9c5/6b3f1d?text=Roasted+Salmon');">
                                <span class="dish-badge dish-badge-available">Available</span>
                                <span class="dish-badge dish-badge-price">RM 21.00</span>
                            </div>
                        </a>
                        <div class="dish-info">
                            <h5><a href="${pageContext.request.contextPath}/menu?itemId=8" class="text-decoration-none text-reset">Herb-Roasted Salmon</a></h5>
                            <div class="dish-rating"><i class="bi bi-star-fill"></i> 4.9 / 5</div>
                            <p class="dish-desc">Oven-roasted salmon fillet, lemon butter sauce, seasonal greens</p>

                            <c:set var="cartQuantity8" value="${0}"/>
                            <c:set var="cartIndex8" value="${-1}"/>
                            <c:forEach var="cartLine" items="${sessionScope.cart}" varStatus="cartLoop">
                                <c:if test="${cartLine.menuItemId == 8}">
                                    <c:set var="cartQuantity8" value="${cartLine.quantity}"/>
                                    <c:set var="cartIndex8" value="${cartLoop.index}"/>
                                </c:if>
                            </c:forEach>

                            <c:if test="${cartQuantity8 > 0}">
                                <div class="dish-cart-controls">
                                    <div class="qty-stepper qty-stepper-sm">
                                        <form action="${pageContext.request.contextPath}/cart" method="post">
                                            <input type="hidden" name="index" value="${cartIndex8}">
                                            <c:choose>
                                                <c:when test="${cartQuantity8 > 1}">
                                                    <input type="hidden" name="action" value="update">
                                                    <input type="hidden" name="quantity" value="${cartQuantity8 - 1}">
                                                </c:when>
                                                <c:otherwise>
                                                    <input type="hidden" name="action" value="remove">
                                                </c:otherwise>
                                            </c:choose>
                                            <button type="submit" aria-label="Decrease quantity">&minus;</button>
                                        </form>
                                        <span class="qty-stepper-value">${cartQuantity8}</span>
                                        <form action="${pageContext.request.contextPath}/cart" method="post">
                                            <input type="hidden" name="action" value="update">
                                            <input type="hidden" name="index" value="${cartIndex8}">
                                            <input type="hidden" name="quantity" value="${cartQuantity8 + 1}">
                                            <button type="submit" aria-label="Increase quantity">+</button>
                                        </form>
                                    </div>
                                    <form action="${pageContext.request.contextPath}/cart" method="post">
                                        <input type="hidden" name="action" value="remove">
                                        <input type="hidden" name="index" value="${cartIndex8}">
                                        <button type="submit" class="dish-remove-btn">
                                            <i class="bi bi-trash"></i> Remove
                                        </button>
                                    </form>
                                </div>
                            </c:if>

                            <a href="${pageContext.request.contextPath}/menu?itemId=8" class="dish-view-link">
                                View Details <i class="bi bi-arrow-right"></i>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="menu-division" id="section-desserts" data-filter="desserts">
            <div class="menu-section-header">
                <div class="division-icon-medallion"><i class="bi bi-cake2"></i></div>
                <span class="section-eyebrow">Chef's Selection</span>
                <h2 class="fw-bold">Desserts</h2>
                <div class="section-divider"></div>
            </div>

            <div class="row g-4 mb-5">

                <div class="col-12 col-sm-6 col-lg-4">
                    <div class="dish-card">
                        <a href="${pageContext.request.contextPath}/menu?itemId=9">
                            <div class="dish-photo" style="background-image: url('${pageContext.request.contextPath}/image/FeastOrder_chocoLava.jpg');">
                                <span class="dish-badge dish-badge-available">Available</span>
                                <span class="dish-badge dish-badge-price">RM 6.90</span>
                            </div>
                        </a>
                        <div class="dish-info">
                            <h5><a href="${pageContext.request.contextPath}/menu?itemId=9" class="text-decoration-none text-reset">Chocolate Lava Cake</a></h5>
                            <div class="dish-rating"><i class="bi bi-star-fill"></i> 4.8 / 5</div>
                            <p class="dish-desc">Warm chocolate cake with molten center</p>

                            <c:set var="cartQuantity9" value="${0}"/>
                            <c:set var="cartIndex9" value="${-1}"/>
                            <c:forEach var="cartLine" items="${sessionScope.cart}" varStatus="cartLoop">
                                <c:if test="${cartLine.menuItemId == 9}">
                                    <c:set var="cartQuantity9" value="${cartLine.quantity}"/>
                                    <c:set var="cartIndex9" value="${cartLoop.index}"/>
                                </c:if>
                            </c:forEach>

                            <c:if test="${cartQuantity9 > 0}">
                                <div class="dish-cart-controls">
                                    <div class="qty-stepper qty-stepper-sm">
                                        <form action="${pageContext.request.contextPath}/cart" method="post">
                                            <input type="hidden" name="index" value="${cartIndex9}">
                                            <c:choose>
                                                <c:when test="${cartQuantity9 > 1}">
                                                    <input type="hidden" name="action" value="update">
                                                    <input type="hidden" name="quantity" value="${cartQuantity9 - 1}">
                                                </c:when>
                                                <c:otherwise>
                                                    <input type="hidden" name="action" value="remove">
                                                </c:otherwise>
                                            </c:choose>
                                            <button type="submit" aria-label="Decrease quantity">&minus;</button>
                                        </form>
                                        <span class="qty-stepper-value">${cartQuantity9}</span>
                                        <form action="${pageContext.request.contextPath}/cart" method="post">
                                            <input type="hidden" name="action" value="update">
                                            <input type="hidden" name="index" value="${cartIndex9}">
                                            <input type="hidden" name="quantity" value="${cartQuantity9 + 1}">
                                            <button type="submit" aria-label="Increase quantity">+</button>
                                        </form>
                                    </div>
                                    <form action="${pageContext.request.contextPath}/cart" method="post">
                                        <input type="hidden" name="action" value="remove">
                                        <input type="hidden" name="index" value="${cartIndex9}">
                                        <button type="submit" class="dish-remove-btn">
                                            <i class="bi bi-trash"></i> Remove
                                        </button>
                                    </form>
                                </div>
                            </c:if>

                            <a href="${pageContext.request.contextPath}/menu?itemId=9" class="dish-view-link">
                                View Details <i class="bi bi-arrow-right"></i>
                            </a>
                        </div>
                    </div>
                </div>
                <div class="col-12 col-sm-6 col-lg-4">
                    <div class="dish-card">
                        <a href="${pageContext.request.contextPath}/menu?itemId=10">
                            <div class="dish-photo" style="background-image: url('${pageContext.request.contextPath}/image/FO_dessert.jpg');">
                                <span class="dish-badge dish-badge-available">Available</span>
                                <span class="dish-badge dish-badge-price">RM 7.50</span>
                            </div>
                        </a>
                        <div class="dish-info">
                            <h5><a href="${pageContext.request.contextPath}/menu?itemId=10" class="text-decoration-none text-reset">Classic Tiramisu</a></h5>
                            <div class="dish-rating"><i class="bi bi-star-fill"></i> 4.7 / 5</div>
                            <p class="dish-desc">Espresso-soaked sponge, mascarpone cream, cocoa dust</p>

                            <c:set var="cartQuantity10" value="${0}"/>
                            <c:set var="cartIndex10" value="${-1}"/>
                            <c:forEach var="cartLine" items="${sessionScope.cart}" varStatus="cartLoop">
                                <c:if test="${cartLine.menuItemId == 10}">
                                    <c:set var="cartQuantity10" value="${cartLine.quantity}"/>
                                    <c:set var="cartIndex10" value="${cartLoop.index}"/>
                                </c:if>
                            </c:forEach>

                            <c:if test="${cartQuantity10 > 0}">
                                <div class="dish-cart-controls">
                                    <div class="qty-stepper qty-stepper-sm">
                                        <form action="${pageContext.request.contextPath}/cart" method="post">
                                            <input type="hidden" name="index" value="${cartIndex10}">
                                            <c:choose>
                                                <c:when test="${cartQuantity10 > 1}">
                                                    <input type="hidden" name="action" value="update">
                                                    <input type="hidden" name="quantity" value="${cartQuantity10 - 1}">
                                                </c:when>
                                                <c:otherwise>
                                                    <input type="hidden" name="action" value="remove">
                                                </c:otherwise>
                                            </c:choose>
                                            <button type="submit" aria-label="Decrease quantity">&minus;</button>
                                        </form>
                                        <span class="qty-stepper-value">${cartQuantity10}</span>
                                        <form action="${pageContext.request.contextPath}/cart" method="post">
                                            <input type="hidden" name="action" value="update">
                                            <input type="hidden" name="index" value="${cartIndex10}">
                                            <input type="hidden" name="quantity" value="${cartQuantity10 + 1}">
                                            <button type="submit" aria-label="Increase quantity">+</button>
                                        </form>
                                    </div>
                                    <form action="${pageContext.request.contextPath}/cart" method="post">
                                        <input type="hidden" name="action" value="remove">
                                        <input type="hidden" name="index" value="${cartIndex10}">
                                        <button type="submit" class="dish-remove-btn">
                                            <i class="bi bi-trash"></i> Remove
                                        </button>
                                    </form>
                                </div>
                            </c:if>

                            <a href="${pageContext.request.contextPath}/menu?itemId=10" class="dish-view-link">
                                View Details <i class="bi bi-arrow-right"></i>
                            </a>
                        </div>
                    </div>
                </div>
                <div class="col-12 col-sm-6 col-lg-4">
                    <div class="dish-card">
                        <a href="${pageContext.request.contextPath}/menu?itemId=11">
                            <div class="dish-photo" style="background-image: url('https://placehold.co/400x280/e8d9c5/6b3f1d?text=Mango+Sticky+Rice');">
                                <span class="dish-badge dish-badge-available">Available</span>
                                <span class="dish-badge dish-badge-price">RM 6.50</span>
                            </div>
                        </a>
                        <div class="dish-info">
                            <h5><a href="${pageContext.request.contextPath}/menu?itemId=11" class="text-decoration-none text-reset">Mango Sticky Rice</a></h5>
                            <div class="dish-rating"><i class="bi bi-star-fill"></i> 4.6 / 5</div>
                            <p class="dish-desc">Sweet glutinous rice, fresh mango, coconut cream</p>

                            <c:set var="cartQuantity11" value="${0}"/>
                            <c:set var="cartIndex11" value="${-1}"/>
                            <c:forEach var="cartLine" items="${sessionScope.cart}" varStatus="cartLoop">
                                <c:if test="${cartLine.menuItemId == 11}">
                                    <c:set var="cartQuantity11" value="${cartLine.quantity}"/>
                                    <c:set var="cartIndex11" value="${cartLoop.index}"/>
                                </c:if>
                            </c:forEach>

                            <c:if test="${cartQuantity11 > 0}">
                                <div class="dish-cart-controls">
                                    <div class="qty-stepper qty-stepper-sm">
                                        <form action="${pageContext.request.contextPath}/cart" method="post">
                                            <input type="hidden" name="index" value="${cartIndex11}">
                                            <c:choose>
                                                <c:when test="${cartQuantity11 > 1}">
                                                    <input type="hidden" name="action" value="update">
                                                    <input type="hidden" name="quantity" value="${cartQuantity11 - 1}">
                                                </c:when>
                                                <c:otherwise>
                                                    <input type="hidden" name="action" value="remove">
                                                </c:otherwise>
                                            </c:choose>
                                            <button type="submit" aria-label="Decrease quantity">&minus;</button>
                                        </form>
                                        <span class="qty-stepper-value">${cartQuantity11}</span>
                                        <form action="${pageContext.request.contextPath}/cart" method="post">
                                            <input type="hidden" name="action" value="update">
                                            <input type="hidden" name="index" value="${cartIndex11}">
                                            <input type="hidden" name="quantity" value="${cartQuantity11 + 1}">
                                            <button type="submit" aria-label="Increase quantity">+</button>
                                        </form>
                                    </div>
                                    <form action="${pageContext.request.contextPath}/cart" method="post">
                                        <input type="hidden" name="action" value="remove">
                                        <input type="hidden" name="index" value="${cartIndex11}">
                                        <button type="submit" class="dish-remove-btn">
                                            <i class="bi bi-trash"></i> Remove
                                        </button>
                                    </form>
                                </div>
                            </c:if>

                            <a href="${pageContext.request.contextPath}/menu?itemId=11" class="dish-view-link">
                                View Details <i class="bi bi-arrow-right"></i>
                            </a>
                        </div>
                    </div>
                </div>
                <div class="col-12 col-sm-6 col-lg-4">
                    <div class="dish-card">
                        <a href="${pageContext.request.contextPath}/menu?itemId=12">
                            <div class="dish-photo" style="background-image: url('https://placehold.co/400x280/e8d9c5/6b3f1d?text=Cheesecake');">
                                <span class="dish-badge dish-badge-available">Available</span>
                                <span class="dish-badge dish-badge-price">RM 7.90</span>
                            </div>
                        </a>
                        <div class="dish-info">
                            <h5><a href="${pageContext.request.contextPath}/menu?itemId=12" class="text-decoration-none text-reset">New York Cheesecake</a></h5>
                            <div class="dish-rating"><i class="bi bi-star-fill"></i> 4.8 / 5</div>
                            <p class="dish-desc">Baked cheesecake, berry compote, buttery biscuit base</p>

                            <c:set var="cartQuantity12" value="${0}"/>
                            <c:set var="cartIndex12" value="${-1}"/>
                            <c:forEach var="cartLine" items="${sessionScope.cart}" varStatus="cartLoop">
                                <c:if test="${cartLine.menuItemId == 12}">
                                    <c:set var="cartQuantity12" value="${cartLine.quantity}"/>
                                    <c:set var="cartIndex12" value="${cartLoop.index}"/>
                                </c:if>
                            </c:forEach>

                            <c:if test="${cartQuantity12 > 0}">
                                <div class="dish-cart-controls">
                                    <div class="qty-stepper qty-stepper-sm">
                                        <form action="${pageContext.request.contextPath}/cart" method="post">
                                            <input type="hidden" name="index" value="${cartIndex12}">
                                            <c:choose>
                                                <c:when test="${cartQuantity12 > 1}">
                                                    <input type="hidden" name="action" value="update">
                                                    <input type="hidden" name="quantity" value="${cartQuantity12 - 1}">
                                                </c:when>
                                                <c:otherwise>
                                                    <input type="hidden" name="action" value="remove">
                                                </c:otherwise>
                                            </c:choose>
                                            <button type="submit" aria-label="Decrease quantity">&minus;</button>
                                        </form>
                                        <span class="qty-stepper-value">${cartQuantity12}</span>
                                        <form action="${pageContext.request.contextPath}/cart" method="post">
                                            <input type="hidden" name="action" value="update">
                                            <input type="hidden" name="index" value="${cartIndex12}">
                                            <input type="hidden" name="quantity" value="${cartQuantity12 + 1}">
                                            <button type="submit" aria-label="Increase quantity">+</button>
                                        </form>
                                    </div>
                                    <form action="${pageContext.request.contextPath}/cart" method="post">
                                        <input type="hidden" name="action" value="remove">
                                        <input type="hidden" name="index" value="${cartIndex12}">
                                        <button type="submit" class="dish-remove-btn">
                                            <i class="bi bi-trash"></i> Remove
                                        </button>
                                    </form>
                                </div>
                            </c:if>

                            <a href="${pageContext.request.contextPath}/menu?itemId=12" class="dish-view-link">
                                View Details <i class="bi bi-arrow-right"></i>
                            </a>
                        </div>
                    </div>
                </div>
                <div class="col-12 col-sm-6 col-lg-4">
                    <div class="dish-card">
                        <a href="${pageContext.request.contextPath}/menu?itemId=13">
                            <div class="dish-photo" style="background-image: url('https://placehold.co/400x280/e8d9c5/6b3f1d?text=Creme+Brulee');">
                                <span class="dish-badge dish-badge-available">Available</span>
                                <span class="dish-badge dish-badge-price">RM 7.20</span>
                            </div>
                        </a>
                        <div class="dish-info">
                            <h5><a href="${pageContext.request.contextPath}/menu?itemId=13" class="text-decoration-none text-reset">Crème Brûlée</a></h5>
                            <div class="dish-rating"><i class="bi bi-star-fill"></i> 4.7 / 5</div>
                            <p class="dish-desc">Silky vanilla custard, caramelized sugar crust</p>

                            <c:set var="cartQuantity13" value="${0}"/>
                            <c:set var="cartIndex13" value="${-1}"/>
                            <c:forEach var="cartLine" items="${sessionScope.cart}" varStatus="cartLoop">
                                <c:if test="${cartLine.menuItemId == 13}">
                                    <c:set var="cartQuantity13" value="${cartLine.quantity}"/>
                                    <c:set var="cartIndex13" value="${cartLoop.index}"/>
                                </c:if>
                            </c:forEach>

                            <c:if test="${cartQuantity13 > 0}">
                                <div class="dish-cart-controls">
                                    <div class="qty-stepper qty-stepper-sm">
                                        <form action="${pageContext.request.contextPath}/cart" method="post">
                                            <input type="hidden" name="index" value="${cartIndex13}">
                                            <c:choose>
                                                <c:when test="${cartQuantity13 > 1}">
                                                    <input type="hidden" name="action" value="update">
                                                    <input type="hidden" name="quantity" value="${cartQuantity13 - 1}">
                                                </c:when>
                                                <c:otherwise>
                                                    <input type="hidden" name="action" value="remove">
                                                </c:otherwise>
                                            </c:choose>
                                            <button type="submit" aria-label="Decrease quantity">&minus;</button>
                                        </form>
                                        <span class="qty-stepper-value">${cartQuantity13}</span>
                                        <form action="${pageContext.request.contextPath}/cart" method="post">
                                            <input type="hidden" name="action" value="update">
                                            <input type="hidden" name="index" value="${cartIndex13}">
                                            <input type="hidden" name="quantity" value="${cartQuantity13 + 1}">
                                            <button type="submit" aria-label="Increase quantity">+</button>
                                        </form>
                                    </div>
                                    <form action="${pageContext.request.contextPath}/cart" method="post">
                                        <input type="hidden" name="action" value="remove">
                                        <input type="hidden" name="index" value="${cartIndex13}">
                                        <button type="submit" class="dish-remove-btn">
                                            <i class="bi bi-trash"></i> Remove
                                        </button>
                                    </form>
                                </div>
                            </c:if>

                            <a href="${pageContext.request.contextPath}/menu?itemId=13" class="dish-view-link">
                                View Details <i class="bi bi-arrow-right"></i>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="menu-division" id="section-beverages" data-filter="beverages">
            <div class="menu-section-header">
                <div class="division-icon-medallion"><i class="bi bi-cup-straw"></i></div>
                <span class="section-eyebrow">Chef's Selection</span>
                <h2 class="fw-bold">Beverages</h2>
                <div class="section-divider"></div>
            </div>

            <div class="row g-4 mb-5">

                <div class="col-12 col-sm-6 col-lg-4">
                    <div class="dish-card">
                        <a href="${pageContext.request.contextPath}/menu_b_aperolS.jsp">
                            <div class="dish-photo" style="background-image: url('https://placehold.co/400x280/e8d9c5/6b3f1d?text=Aperol+Spritz');">
                                <span class="dish-badge dish-badge-available">Available</span>
                                <span class="dish-badge dish-badge-price">RM 28.00</span>
                            </div>
                        </a>
                        <div class="dish-info">
                            <h5><a href="${pageContext.request.contextPath}/menu_b_aperolS.jsp" class="text-decoration-none text-reset">Aperol Spritz</a></h5>
                            <div class="dish-rating"><i class="bi bi-star-fill"></i> 4.8 / 5</div>
                            <p class="dish-desc">Aperol, Prosecco, and a splash of soda over ice, finished with a fresh orange slice — Italy's beloved aperitivo</p>

                            <c:set var="cartQuantity14" value="${0}"/>
                            <c:set var="cartIndex14" value="${-1}"/>
                            <c:forEach var="cartLine" items="${sessionScope.cart}" varStatus="cartLoop">
                                <c:if test="${cartLine.menuItemId == 14}">
                                    <c:set var="cartQuantity14" value="${cartLine.quantity}"/>
                                    <c:set var="cartIndex14" value="${cartLoop.index}"/>
                                </c:if>
                            </c:forEach>

                            <c:if test="${cartQuantity14 > 0}">
                                <div class="dish-cart-controls">
                                    <div class="qty-stepper qty-stepper-sm">
                                        <form action="${pageContext.request.contextPath}/cart" method="post">
                                            <input type="hidden" name="index" value="${cartIndex14}">
                                            <c:choose>
                                                <c:when test="${cartQuantity14 > 1}">
                                                    <input type="hidden" name="action" value="update">
                                                    <input type="hidden" name="quantity" value="${cartQuantity14 - 1}">
                                                </c:when>
                                                <c:otherwise>
                                                    <input type="hidden" name="action" value="remove">
                                                </c:otherwise>
                                            </c:choose>
                                            <button type="submit" aria-label="Decrease quantity">&minus;</button>
                                        </form>
                                        <span class="qty-stepper-value">${cartQuantity14}</span>
                                        <form action="${pageContext.request.contextPath}/cart" method="post">
                                            <input type="hidden" name="action" value="update">
                                            <input type="hidden" name="index" value="${cartIndex14}">
                                            <input type="hidden" name="quantity" value="${cartQuantity14 + 1}">
                                            <button type="submit" aria-label="Increase quantity">+</button>
                                        </form>
                                    </div>
                                    <form action="${pageContext.request.contextPath}/cart" method="post">
                                        <input type="hidden" name="action" value="remove">
                                        <input type="hidden" name="index" value="${cartIndex14}">
                                        <button type="submit" class="dish-remove-btn">
                                            <i class="bi bi-trash"></i> Remove
                                        </button>
                                    </form>
                                </div>
                            </c:if>

                            <a href="${pageContext.request.contextPath}/menu_b_aperolS.jsp" class="dish-view-link">
                                View Details <i class="bi bi-arrow-right"></i>
                            </a>
                        </div>
                    </div>
                </div>
                <div class="col-12 col-sm-6 col-lg-4">
                    <div class="dish-card">
                        <a href="${pageContext.request.contextPath}/menu_b_espressoM.jsp">
                            <div class="dish-photo" style="background-image: url('https://placehold.co/400x280/e8d9c5/6b3f1d?text=Espresso+Martini');">
                                <span class="dish-badge dish-badge-available">Available</span>
                                <span class="dish-badge dish-badge-price">RM 32.00</span>
                            </div>
                        </a>
                        <div class="dish-info">
                            <h5><a href="${pageContext.request.contextPath}/menu_b_espressoM.jsp" class="text-decoration-none text-reset">Espresso Martini</a></h5>
                            <div class="dish-rating"><i class="bi bi-star-fill"></i> 4.9 / 5</div>
                            <p class="dish-desc">Vodka, coffee liqueur, and a shot of espresso, shaken until dark and frothy</p>

                            <c:set var="cartQuantity15" value="${0}"/>
                            <c:set var="cartIndex15" value="${-1}"/>
                            <c:forEach var="cartLine" items="${sessionScope.cart}" varStatus="cartLoop">
                                <c:if test="${cartLine.menuItemId == 15}">
                                    <c:set var="cartQuantity15" value="${cartLine.quantity}"/>
                                    <c:set var="cartIndex15" value="${cartLoop.index}"/>
                                </c:if>
                            </c:forEach>

                            <c:if test="${cartQuantity15 > 0}">
                                <div class="dish-cart-controls">
                                    <div class="qty-stepper qty-stepper-sm">
                                        <form action="${pageContext.request.contextPath}/cart" method="post">
                                            <input type="hidden" name="index" value="${cartIndex15}">
                                            <c:choose>
                                                <c:when test="${cartQuantity15 > 1}">
                                                    <input type="hidden" name="action" value="update">
                                                    <input type="hidden" name="quantity" value="${cartQuantity15 - 1}">
                                                </c:when>
                                                <c:otherwise>
                                                    <input type="hidden" name="action" value="remove">
                                                </c:otherwise>
                                            </c:choose>
                                            <button type="submit" aria-label="Decrease quantity">&minus;</button>
                                        </form>
                                        <span class="qty-stepper-value">${cartQuantity15}</span>
                                        <form action="${pageContext.request.contextPath}/cart" method="post">
                                            <input type="hidden" name="action" value="update">
                                            <input type="hidden" name="index" value="${cartIndex15}">
                                            <input type="hidden" name="quantity" value="${cartQuantity15 + 1}">
                                            <button type="submit" aria-label="Increase quantity">+</button>
                                        </form>
                                    </div>
                                    <form action="${pageContext.request.contextPath}/cart" method="post">
                                        <input type="hidden" name="action" value="remove">
                                        <input type="hidden" name="index" value="${cartIndex15}">
                                        <button type="submit" class="dish-remove-btn">
                                            <i class="bi bi-trash"></i> Remove
                                        </button>
                                    </form>
                                </div>
                            </c:if>

                            <a href="${pageContext.request.contextPath}/menu_b_espressoM.jsp" class="dish-view-link">
                                View Details <i class="bi bi-arrow-right"></i>
                            </a>
                        </div>
                    </div>
                </div>
                <div class="col-12 col-sm-6 col-lg-4">
                    <div class="dish-card">
                        <a href="${pageContext.request.contextPath}/menu_b_bellini.jsp">
                            <div class="dish-photo" style="background-image: url('https://placehold.co/400x280/e8d9c5/6b3f1d?text=Bellini');">
                                <span class="dish-badge dish-badge-available">Available</span>
                                <span class="dish-badge dish-badge-price">RM 26.00</span>
                            </div>
                        </a>
                        <div class="dish-info">
                            <h5><a href="${pageContext.request.contextPath}/menu_b_bellini.jsp" class="text-decoration-none text-reset">Bellini</a></h5>
                            <div class="dish-rating"><i class="bi bi-star-fill"></i> 4.7 / 5</div>
                            <p class="dish-desc">Chilled Prosecco layered with silky white peach purée, a Venetian classic since 1948</p>

                            <c:set var="cartQuantity16" value="${0}"/>
                            <c:set var="cartIndex16" value="${-1}"/>
                            <c:forEach var="cartLine" items="${sessionScope.cart}" varStatus="cartLoop">
                                <c:if test="${cartLine.menuItemId == 16}">
                                    <c:set var="cartQuantity16" value="${cartLine.quantity}"/>
                                    <c:set var="cartIndex16" value="${cartLoop.index}"/>
                                </c:if>
                            </c:forEach>

                            <c:if test="${cartQuantity16 > 0}">
                                <div class="dish-cart-controls">
                                    <div class="qty-stepper qty-stepper-sm">
                                        <form action="${pageContext.request.contextPath}/cart" method="post">
                                            <input type="hidden" name="index" value="${cartIndex16}">
                                            <c:choose>
                                                <c:when test="${cartQuantity16 > 1}">
                                                    <input type="hidden" name="action" value="update">
                                                    <input type="hidden" name="quantity" value="${cartQuantity16 - 1}">
                                                </c:when>
                                                <c:otherwise>
                                                    <input type="hidden" name="action" value="remove">
                                                </c:otherwise>
                                            </c:choose>
                                            <button type="submit" aria-label="Decrease quantity">&minus;</button>
                                        </form>
                                        <span class="qty-stepper-value">${cartQuantity16}</span>
                                        <form action="${pageContext.request.contextPath}/cart" method="post">
                                            <input type="hidden" name="action" value="update">
                                            <input type="hidden" name="index" value="${cartIndex16}">
                                            <input type="hidden" name="quantity" value="${cartQuantity16 + 1}">
                                            <button type="submit" aria-label="Increase quantity">+</button>
                                        </form>
                                    </div>
                                    <form action="${pageContext.request.contextPath}/cart" method="post">
                                        <input type="hidden" name="action" value="remove">
                                        <input type="hidden" name="index" value="${cartIndex16}">
                                        <button type="submit" class="dish-remove-btn">
                                            <i class="bi bi-trash"></i> Remove
                                        </button>
                                    </form>
                                </div>
                            </c:if>

                            <a href="${pageContext.request.contextPath}/menu_b_bellini.jsp" class="dish-view-link">
                                View Details <i class="bi bi-arrow-right"></i>
                            </a>
                        </div>
                    </div>
                </div>
                <div class="col-12 col-sm-6 col-lg-4">
                    <div class="dish-card">
                        <a href="${pageContext.request.contextPath}/menu_b_negroni.jsp">
                            <div class="dish-photo" style="background-image: url('https://placehold.co/400x280/e8d9c5/6b3f1d?text=Negroni');">
                                <span class="dish-badge dish-badge-available">Available</span>
                                <span class="dish-badge dish-badge-price">RM 30.00</span>
                            </div>
                        </a>
                        <div class="dish-info">
                            <h5><a href="${pageContext.request.contextPath}/menu_b_negroni.jsp" class="text-decoration-none text-reset">Negroni</a></h5>
                            <div class="dish-rating"><i class="bi bi-star-fill"></i> 4.6 / 5</div>
                            <p class="dish-desc">Equal parts gin, Campari, and sweet vermouth, stirred over ice with an orange twist</p>

                            <c:set var="cartQuantity17" value="${0}"/>
                            <c:set var="cartIndex17" value="${-1}"/>
                            <c:forEach var="cartLine" items="${sessionScope.cart}" varStatus="cartLoop">
                                <c:if test="${cartLine.menuItemId == 17}">
                                    <c:set var="cartQuantity17" value="${cartLine.quantity}"/>
                                    <c:set var="cartIndex17" value="${cartLoop.index}"/>
                                </c:if>
                            </c:forEach>

                            <c:if test="${cartQuantity17 > 0}">
                                <div class="dish-cart-controls">
                                    <div class="qty-stepper qty-stepper-sm">
                                        <form action="${pageContext.request.contextPath}/cart" method="post">
                                            <input type="hidden" name="index" value="${cartIndex17}">
                                            <c:choose>
                                                <c:when test="${cartQuantity17 > 1}">
                                                    <input type="hidden" name="action" value="update">
                                                    <input type="hidden" name="quantity" value="${cartQuantity17 - 1}">
                                                </c:when>
                                                <c:otherwise>
                                                    <input type="hidden" name="action" value="remove">
                                                </c:otherwise>
                                            </c:choose>
                                            <button type="submit" aria-label="Decrease quantity">&minus;</button>
                                        </form>
                                        <span class="qty-stepper-value">${cartQuantity17}</span>
                                        <form action="${pageContext.request.contextPath}/cart" method="post">
                                            <input type="hidden" name="action" value="update">
                                            <input type="hidden" name="index" value="${cartIndex17}">
                                            <input type="hidden" name="quantity" value="${cartQuantity17 + 1}">
                                            <button type="submit" aria-label="Increase quantity">+</button>
                                        </form>
                                    </div>
                                    <form action="${pageContext.request.contextPath}/cart" method="post">
                                        <input type="hidden" name="action" value="remove">
                                        <input type="hidden" name="index" value="${cartIndex17}">
                                        <button type="submit" class="dish-remove-btn">
                                            <i class="bi bi-trash"></i> Remove
                                        </button>
                                    </form>
                                </div>
                            </c:if>

                            <a href="${pageContext.request.contextPath}/menu_b_negroni.jsp" class="dish-view-link">
                                View Details <i class="bi bi-arrow-right"></i>
                            </a>
                        </div>
                    </div>
                </div>
                <div class="col-12 col-sm-6 col-lg-4">
                    <div class="dish-card">
                        <a href="${pageContext.request.contextPath}/menu_b_affogato.jsp">
                            <div class="dish-photo" style="background-image: url('https://placehold.co/400x280/e8d9c5/6b3f1d?text=Affogato');">
                                <span class="dish-badge dish-badge-available">Available</span>
                                <span class="dish-badge dish-badge-price">RM 14.00</span>
                            </div>
                        </a>
                        <div class="dish-info">
                            <h5><a href="${pageContext.request.contextPath}/menu_b_affogato.jsp" class="text-decoration-none text-reset">Affogato al Caffè</a></h5>
                            <div class="dish-rating"><i class="bi bi-star-fill"></i> 4.9 / 5</div>
                            <p class="dish-desc">A scoop of vanilla gelato “drowned” in a hot shot of espresso — dessert and drink in one, non-alcoholic</p>

                            <c:set var="cartQuantity18" value="${0}"/>
                            <c:set var="cartIndex18" value="${-1}"/>
                            <c:forEach var="cartLine" items="${sessionScope.cart}" varStatus="cartLoop">
                                <c:if test="${cartLine.menuItemId == 18}">
                                    <c:set var="cartQuantity18" value="${cartLine.quantity}"/>
                                    <c:set var="cartIndex18" value="${cartLoop.index}"/>
                                </c:if>
                            </c:forEach>

                            <c:if test="${cartQuantity18 > 0}">
                                <div class="dish-cart-controls">
                                    <div class="qty-stepper qty-stepper-sm">
                                        <form action="${pageContext.request.contextPath}/cart" method="post">
                                            <input type="hidden" name="index" value="${cartIndex18}">
                                            <c:choose>
                                                <c:when test="${cartQuantity18 > 1}">
                                                    <input type="hidden" name="action" value="update">
                                                    <input type="hidden" name="quantity" value="${cartQuantity18 - 1}">
                                                </c:when>
                                                <c:otherwise>
                                                    <input type="hidden" name="action" value="remove">
                                                </c:otherwise>
                                            </c:choose>
                                            <button type="submit" aria-label="Decrease quantity">&minus;</button>
                                        </form>
                                        <span class="qty-stepper-value">${cartQuantity18}</span>
                                        <form action="${pageContext.request.contextPath}/cart" method="post">
                                            <input type="hidden" name="action" value="update">
                                            <input type="hidden" name="index" value="${cartIndex18}">
                                            <input type="hidden" name="quantity" value="${cartQuantity18 + 1}">
                                            <button type="submit" aria-label="Increase quantity">+</button>
                                        </form>
                                    </div>
                                    <form action="${pageContext.request.contextPath}/cart" method="post">
                                        <input type="hidden" name="action" value="remove">
                                        <input type="hidden" name="index" value="${cartIndex18}">
                                        <button type="submit" class="dish-remove-btn">
                                            <i class="bi bi-trash"></i> Remove
                                        </button>
                                    </form>
                                </div>
                            </c:if>

                            <a href="${pageContext.request.contextPath}/menu_b_affogato.jsp" class="dish-view-link">
                                View Details <i class="bi bi-arrow-right"></i>
                            </a>
                        </div>
                    </div>
                </div>

            </div>
        </div>


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
