<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>FeastOrder - Signature Chef's Platter</title>

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

    <style>
        /* ==== Item detail view — same component classes used by menu.jsp,
             so this standalone page matches the rest of the site exactly ==== */
        .item-detail-hero {
            position: relative;
            height: 46vh;
            min-height: 320px;
            max-height: 480px;
            border-radius: var(--radius-lg);
            background-size: cover;
            background-position: center;
            background-color: var(--c-ink);
            overflow: hidden;
        }
        .item-detail-hero-overlay {
            position: absolute;
            inset: 0;
            background: linear-gradient(180deg, rgba(17,26,25,0.15) 0%, rgba(17,26,25,0.35) 55%, rgba(17,26,25,0.85) 100%);
        }
        .item-detail-close {
            position: absolute;
            top: 18px;
            right: 18px;
            width: 42px;
            height: 42px;
            border-radius: 50%;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            background: rgba(17,26,25,0.45);
            backdrop-filter: blur(4px);
            color: #fff;
            border: 1px solid rgba(248,215,148,0.4);
            transition: var(--transition);
        }
        .item-detail-close:hover { background: var(--c-gold); color: var(--c-ink); }

        .item-detail-card {
            position: relative;
            margin: -64px 1rem 0;
            background: linear-gradient(160deg, rgba(17,26,25,0.94) 0%, rgba(40,65,57,0.94) 100%);
            border: 1px solid rgba(211,152,88,0.35);
            border-radius: var(--radius-lg);
            box-shadow: var(--shadow-lg);
            padding: 2rem 1.75rem;
            color: var(--c-champagne-soft);
        }
        @media (min-width: 992px) {
            .item-detail-card { margin: -80px 2.5rem 0; padding: 2.5rem 3rem; }
        }
        .item-detail-card h1 {
            font-family: var(--font-heading);
            color: #ffffff;
            margin-bottom: 0.15rem;
        }
        .item-detail-card .category-label {
            font-family: var(--font-body);
            letter-spacing: 0.14em;
            text-transform: uppercase;
            font-size: 0.75rem;
            color: var(--c-gold-light);
        }
        .item-favorite-toggle {
            width: 44px;
            height: 44px;
            border-radius: 50%;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            background: rgba(248,215,148,0.12);
            border: 1px solid rgba(248,215,148,0.4);
            color: var(--c-gold-light);
            transition: var(--transition);
            flex-shrink: 0;
        }
        .item-favorite-toggle:hover { background: var(--c-gold); color: var(--c-ink); }
        .item-favorite-toggle.is-active { background: var(--c-gold); color: var(--c-ink); }

        .item-detail-card .tag-pill {
            display: inline-block;
            padding: 0.3rem 0.85rem;
            border-radius: 999px;
            font-size: 0.78rem;
            font-weight: 600;
            background: rgba(234,206,170,0.14);
            border: 1px solid rgba(234,206,170,0.3);
            color: var(--c-champagne-soft);
        }
        .item-detail-card .tag-pill.tag-pill-available { background: rgba(128,153,118,0.25); border-color: rgba(128,153,118,0.5); }
        .item-detail-card .tag-pill.tag-pill-unavailable { background: rgba(133,67,30,0.25); border-color: rgba(133,67,30,0.5); }

        .item-detail-card .item-divider {
            width: 130px;
            height: 18px;
            margin: 1.25rem 0;
            background-image: var(--ornament-divider);
            background-repeat: no-repeat;
            background-position: left center;
            background-size: contain;
        }

        .detail-section-label {
            font-family: var(--font-body);
            letter-spacing: 0.1em;
            text-transform: uppercase;
            font-size: 0.72rem;
            font-weight: 700;
            color: var(--c-gold-light);
            margin-bottom: 0.4rem;
        }

        .star-rating i { font-size: 0.95rem; margin-right: 1px; }

        .ingredient-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 0.6rem 1.5rem;
            margin-bottom: 0.5rem;
        }
        .ingredient-row {
            display: flex;
            justify-content: space-between;
            font-size: 0.92rem;
            border-bottom: 1px dashed rgba(234,206,170,0.25);
            padding-bottom: 0.35rem;
        }
        .ingredient-row .ingredient-qty { color: var(--c-gold-light); font-weight: 600; }

        .stat-chip {
            flex: 1;
            min-width: 90px;
            text-align: center;
            padding: 0.65rem 0.5rem;
            border-radius: var(--radius-sm);
            background: rgba(255,255,255,0.06);
            border: 1px solid rgba(255,255,255,0.12);
        }
        .stat-chip .stat-value {
            font-family: var(--font-heading);
            font-size: 1.15rem;
            color: var(--c-gold-light);
            font-weight: 700;
        }

        .addon-pill-input { position: absolute; opacity: 0; pointer-events: none; }
        .addon-pill-label {
            display: inline-block;
            padding: 0.4rem 1rem;
            border-radius: 999px;
            border: 1px solid rgba(234,206,170,0.35);
            color: var(--c-champagne-soft);
            font-size: 0.85rem;
            cursor: pointer;
            transition: var(--transition);
            user-select: none;
        }
        .addon-pill-input:checked + .addon-pill-label {
            background: var(--c-gold);
            border-color: var(--c-gold);
            color: var(--c-ink);
            font-weight: 600;
        }

        .qty-stepper {
            display: inline-flex;
            align-items: center;
            border: 1px solid rgba(234,206,170,0.35);
            border-radius: 999px;
            overflow: hidden;
        }
        .qty-stepper button {
            width: 42px;
            height: 42px;
            border: none;
            background: transparent;
            color: var(--c-gold-light);
            font-size: 1.1rem;
            line-height: 1;
        }
        .qty-stepper button:hover { background: rgba(211,152,88,0.18); }
        .qty-stepper input {
            width: 46px;
            text-align: center;
            border: none;
            background: transparent;
            color: #fff;
            font-weight: 600;
            -moz-appearance: textfield;
        }
        .qty-stepper input::-webkit-outer-spin-button,
        .qty-stepper input::-webkit-inner-spin-button { -webkit-appearance: none; margin: 0; }

        .item-detail-price {
            font-family: var(--font-heading);
            font-size: 1.9rem;
            color: var(--c-gold-light);
            font-weight: 700;
        }

        .btn-detail-cta {
            background: linear-gradient(135deg, var(--c-gold) 0%, var(--c-gold-dark) 100%);
            border: none;
            color: var(--c-ink);
            font-weight: 700;
            letter-spacing: 0.02em;
            border-radius: 999px;
            box-shadow: var(--shadow-gold);
        }
        .btn-detail-cta:hover { color: var(--c-ink); filter: brightness(1.06); }

        .detail-sticky-bar {
            position: fixed;
            left: 0;
            right: 0;
            bottom: 0;
            z-index: 1040;
            display: flex;
            align-items: center;
            gap: 1rem;
            padding: 0.9rem 1.25rem;
            background: linear-gradient(180deg, rgba(17,26,25,0.85) 0%, rgba(17,26,25,0.98) 40%, var(--c-ink) 100%);
            border-top: 1px solid rgba(211,152,88,0.35);
            box-shadow: 0 -10px 30px rgba(17,26,25,0.35);
        }
        .detail-sticky-bar .item-detail-price { font-size: 1.4rem; white-space: nowrap; }
        .detail-sticky-bar-spacer { height: 90px; }
        @media (min-width: 992px) {
            .detail-sticky-bar { padding-left: 2.5rem; padding-right: 2.5rem; }
        }

        .cart-status-banner {
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 0.75rem;
            padding: 0.75rem 1rem;
            margin-bottom: 1.25rem;
            border-radius: var(--radius-sm);
            background: rgba(128,153,118,0.18);
            border: 1px solid rgba(128,153,118,0.45);
            color: var(--c-champagne-soft);
            font-size: 0.9rem;
        }
        .cart-status-text i { color: var(--c-sage); margin-right: 0.3rem; }
        .cart-status-controls { display: flex; align-items: center; gap: 0.5rem; }
        .cart-status-controls form { margin: 0; }
        .cart-status-controls button {
            width: 34px;
            height: 34px;
            border-radius: 50%;
            border: 1px solid rgba(234,206,170,0.4);
            background: rgba(255,255,255,0.06);
            color: var(--c-gold-light);
            font-size: 1rem;
            line-height: 1;
        }
        .cart-status-controls button:hover { background: rgba(211,152,88,0.2); }
        .cart-status-controls .cart-status-remove {
            width: auto;
            border-radius: 999px;
            padding: 0 0.85rem;
            font-size: 0.78rem;
            font-weight: 600;
            color: var(--c-rust);
            border-color: rgba(133,67,30,0.4);
        }
        .cart-status-controls .cart-status-remove:hover { background: rgba(133,67,30,0.25); }
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

                    </ul>
                </div>
            </div>
        </nav>
    </header>

    <main class="container py-5">

        <%-- This dish's session-cart status: itemId 6 = Signature Chef's Platter,
             matching the seed data / MenuServlet contract used elsewhere.
             Assumes each cart line exposes a "menuItemId" property. --%>
        <c:set var="cartQuantity" value="${0}"/>
        <c:set var="cartIndex" value="${-1}"/>
        <c:forEach var="cartLine" items="${sessionScope.cart}" varStatus="cartLoop">
            <c:if test="${cartLine.menuItemId == 6}">
                <c:set var="cartQuantity" value="${cartLine.quantity}"/>
                <c:set var="cartIndex" value="${cartLoop.index}"/>
            </c:if>
        </c:forEach>

        <div class="item-detail-hero"
             style="background-image: url('${pageContext.request.contextPath}/image/menu_signatureChefPlatter.jpg');">
            <div class="item-detail-hero-overlay"></div>
            <a href="${pageContext.request.contextPath}/menu" class="item-detail-close" aria-label="Back to menu" title="Back to menu">
                <i class="bi bi-x-lg"></i>
            </a>
        </div>

        <div class="item-detail-card">

            <div class="d-flex justify-content-between align-items-start">
                <div>
                    <span class="category-label">Main Courses</span>
                    <h1 class="fs-2 fw-bold mb-0">Signature Chef&rsquo;s Platter</h1>
                </div>
                <button type="button" class="item-favorite-toggle" onclick="this.classList.toggle('is-active'); this.querySelector('i').classList.toggle('bi-heart'); this.querySelector('i').classList.toggle('bi-heart-fill');" aria-label="Save as favorite">
                    <i class="bi bi-heart"></i>
                </button>
            </div>

            <div class="mt-2 mb-3 d-flex align-items-center flex-wrap gap-2">
                <span class="star-rating text-warning">
                    <i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-half"></i>
                    <span class="ms-1">4.8 / 5</span>
                </span>
                <span class="tag-pill">Main Courses</span>
                <span class="tag-pill">Chef's Pick</span>
                <span class="tag-pill">Signature</span>
                <span class="tag-pill tag-pill-available"><i class="bi bi-check-circle"></i> Available Now</span>
            </div>

            <h6 class="detail-section-label">Description</h6>
            <p class="mb-3" style="opacity:0.85;">
                Our chef's daily selection of grilled meats and roasted vegetables, finished with a rich house-made jus &mdash; a true taste of FeastOrder Kitchen.
            </p>

            <h6 class="detail-section-label">Ingredients</h6>
            <div class="ingredient-grid mb-3">
                <div class="ingredient-row"><span>Mixed grilled meats</span><span class="ingredient-qty">0.4 kg</span></div>
                <div class="ingredient-row"><span>Roasted vegetables</span><span class="ingredient-qty">0.2 kg</span></div>
                <div class="ingredient-row"><span>House jus</span><span class="ingredient-qty">0.05 kg</span></div>
            </div>
            <p class="mb-0" style="opacity:0.7; font-size:0.82rem;">
                <i class="bi bi-info-circle"></i> Allergens vary by daily selection. Please ask your server for details.
            </p>

            <div class="item-divider"></div>

            <h6 class="detail-section-label">Nutritional Information</h6>
            <div class="d-flex flex-wrap gap-2 mb-4">
                <div class="stat-chip"><div class="stat-value">710 kcal</div></div>
                <div class="stat-chip"><div class="stat-value">38g fat</div></div>
                <div class="stat-chip"><div class="stat-value">45g carbs</div></div>
            </div>

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

            <form action="${pageContext.request.contextPath}/cart" method="post"
                  class="add-to-cart-form"
                  onsubmit="return prepareAddToCart(this)">
                <input type="hidden" name="action" value="add">
                <input type="hidden" name="itemId" value="6">
                <input type="hidden" name="addOns" class="addons-hidden-input">

                <div class="mb-4">
                    <h6 class="detail-section-label">Add-ons</h6>
                    <div class="d-flex flex-wrap gap-2">
                        <input class="addon-pill-input addon-checkbox" type="checkbox" value="Extra Meat" id="addon-meat">
                        <label class="addon-pill-label" for="addon-meat">Extra Meat</label>

                        <input class="addon-pill-input addon-checkbox" type="checkbox" value="Extra Vegetables" id="addon-veg">
                        <label class="addon-pill-label" for="addon-veg">Extra Vegetables</label>

                        <input class="addon-pill-input addon-checkbox" type="checkbox" value="Add Drink" id="addon-drink">
                        <label class="addon-pill-label" for="addon-drink">Add Drink</label>

                    </div>
                </div>
                <div class="text-danger small mb-2 qty-feedback"></div>

                <div class="detail-sticky-bar">
                    <span class="item-detail-price">RM 18.90</span>
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
        </div>

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
