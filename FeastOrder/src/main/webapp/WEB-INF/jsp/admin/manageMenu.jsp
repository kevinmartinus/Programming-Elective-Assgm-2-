<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Manage Menu - FeastOrder Admin</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="bg-light">

    <%@ include file="adminNavbar.jsp" %>

    <div class="container py-5">
        <h2 class="mb-4"><i class="bi bi-egg-fried"></i> Manage Menu</h2>

        <c:if test="${not empty message}">
            <div class="alert ${isError ? 'alert-danger' : 'alert-success'} alert-dismissible fade show">
                ${message}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- MENU ITEMS TABLE -->
        <div class="card shadow-sm border-0 mb-5">
            <div class="card-header d-flex justify-content-between align-items-center bg-white">
                <h5 class="mb-0">Current Menu Items (${menuItems.size()})</h5>
                <button class="btn btn-warning btn-sm" data-bs-toggle="modal" data-bs-target="#addItemModal">
                    <i class="bi bi-plus-circle"></i> Add New Item
                </button>
            </div>
            <div class="card-body p-0">
                <c:if test="${empty menuItems}">
                    <p class="text-muted text-center p-4 mb-0">No menu items yet — add your first one above.</p>
                </c:if>
                <c:if test="${not empty menuItems}">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-light">
                                <tr>
                                    <th>Name</th>
                                    <th>Category</th>
                                    <th>Price</th>
                                    <th>Rating</th>
                                    <th>Status</th>
                                    <th class="text-end">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="item" items="${menuItems}">
                                    <tr>
                                        <td>
                                            <strong>${item.name}</strong>
                                            <div class="small text-muted">${item.description}</div>
                                        </td>
                                        <td>${item.categoryName}</td>
                                        <td>$<fmt:formatNumber value="${item.price}" minFractionDigits="2" maxFractionDigits="2"/></td>
                                        <td><i class="bi bi-star-fill text-warning"></i> ${item.rating}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${item.available}">
                                                    <span class="badge bg-success">Available</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-secondary">Unavailable</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-end">
                                            <button type="button" class="btn btn-outline-primary btn-sm edit-item-btn"
                                                    data-bs-toggle="modal" data-bs-target="#editItemModal"
                                                    data-item-id="${item.itemId}"
                                                    data-item-name="${item.name}"
                                                    data-item-description="${item.description}"
                                                    data-item-nutrition="${item.nutritionalInfo}"
                                                    data-item-price="${item.price}"
                                                    data-item-image="${item.imageUrl}"
                                                    data-item-category="${item.categoryId}"
                                                    data-item-available="${item.available}">
                                                <i class="bi bi-pencil"></i> Edit
                                            </button>
                                            <form method="post" action="${pageContext.request.contextPath}/admin/menu"
                                                class="d-inline" onsubmit="return confirm('Delete \'${item.name}\'? This cannot be undone.');">
                                                <input type="hidden" name="action" value="delete">
                                                <input type="hidden" name="itemId" value="${item.itemId}">
                                                <button type="submit" class="btn btn-outline-danger btn-sm">
                                                    <i class="bi bi-trash"></i> Delete
                                                </button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:if>
            </div>
        </div>

        <!-- CATEGORY MANAGEMENT -->
        <div class="card shadow-sm border-0">
            <div class="card-header bg-white">
                <h5 class="mb-0"><i class="bi bi-tags"></i> Manage Categories</h5>
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-7">
                        <c:if test="${empty categories}">
                            <p class="text-muted mb-0">No categories yet — add one to get started.</p>
                        </c:if>
                        <c:if test="${not empty categories}">
                            <ul class="list-group">
                                <c:forEach var="cat" items="${categories}">
                                    <li class="list-group-item d-flex justify-content-between align-items-center">
                                        <div>
                                            <strong>${cat.categoryName}</strong>
                                            <c:if test="${not empty cat.description}">
                                                <span class="text-muted small"> — ${cat.description}</span>
                                            </c:if>
                                        </div>
                                        <form method="post" action="${pageContext.request.contextPath}/admin/menu"
                                            onsubmit="return confirm('Delete category \'${cat.categoryName}\'? Items using it must be moved or removed first.');">
                                            <input type="hidden" name="action" value="deleteCategory">
                                            <input type="hidden" name="categoryId" value="${cat.categoryId}">
                                            <button type="submit" class="btn btn-outline-danger btn-sm">
                                                <i class="bi bi-trash"></i>
                                            </button>
                                        </form>
                                    </li>
                                </c:forEach>
                            </ul>
                        </c:if>
                    </div>
                    <div class="col-md-5">
                        <form method="post" action="${pageContext.request.contextPath}/admin/menu">
                            <input type="hidden" name="action" value="addCategory">
                            <div class="mb-2">
                                <label class="form-label small">New Category Name</label>
                                <input type="text" name="categoryName" class="form-control form-control-sm" required maxlength="50">
                            </div>
                            <div class="mb-2">
                                <label class="form-label small">Description (optional)</label>
                                <input type="text" name="categoryDescription" class="form-control form-control-sm" maxlength="255">
                            </div>
                            <button type="submit" class="btn btn-outline-warning btn-sm w-100">
                                <i class="bi bi-plus-circle"></i> Add Category
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- ADD ITEM MODAL -->
    <div class="modal fade" id="addItemModal" tabindex="-1">
        <div class="modal-dialog">
            <form method="post" action="${pageContext.request.contextPath}/admin/menu" class="modal-content" onsubmit="return validateMenuItemForm(this);">
                <input type="hidden" name="action" value="add">
                <div class="modal-header">
                    <h5 class="modal-title">Add New Menu Item</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-2">
                        <label class="form-label">Name</label>
                        <input type="text" name="name" class="form-control" required maxlength="100">
                    </div>
                    <div class="mb-2">
                        <label class="form-label">Description / Ingredients</label>
                        <textarea name="description" class="form-control" rows="2"></textarea>
                    </div>
                    <div class="mb-2">
                        <label class="form-label">Nutritional Info</label>
                        <input type="text" name="nutritionalInfo" class="form-control" placeholder="e.g. 650 kcal, 22g fat">
                    </div>
                    <div class="row">
                        <div class="col-6 mb-2">
                            <label class="form-label">Price (RM)</label>
                            <input type="number" name="price" class="form-control" step="0.01" min="0" required>
                        </div>
                        <div class="col-6 mb-2">
                            <label class="form-label">Category</label>
                            <select name="categoryId" class="form-select" required>
                                <c:forEach var="cat" items="${categories}">
                                    <option value="${cat.categoryId}">${cat.categoryName}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>
                    <div class="mb-2">
                        <label class="form-label">Image URL</label>
                        <input type="text" name="imageUrl" class="form-control" placeholder="images/dish-name.jpg">
                    </div>
                    <div class="form-check">
                        <input type="checkbox" name="available" class="form-check-input" id="addAvailable" checked>
                        <label class="form-check-label" for="addAvailable">Available for ordering</label>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-warning">Add Item</button>
                </div>
            </form>
        </div>
    </div>

    <!-- EDIT ITEM MODAL (single modal, re-populated via JS per row) -->
    <div class="modal fade" id="editItemModal" tabindex="-1">
        <div class="modal-dialog">
            <form method="post" action="${pageContext.request.contextPath}/admin/menu" class="modal-content" onsubmit="return validateMenuItemForm(this);">
                <input type="hidden" name="action" value="edit">
                <input type="hidden" name="itemId" id="editItemId">
                <div class="modal-header">
                    <h5 class="modal-title">Edit Menu Item</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-2">
                        <label class="form-label">Name</label>
                        <input type="text" name="name" id="editName" class="form-control" required maxlength="100">
                    </div>
                    <div class="mb-2">
                        <label class="form-label">Description / Ingredients</label>
                        <textarea name="description" id="editDescription" class="form-control" rows="2"></textarea>
                    </div>
                    <div class="mb-2">
                        <label class="form-label">Nutritional Info</label>
                        <input type="text" name="nutritionalInfo" id="editNutrition" class="form-control">
                    </div>
                    <div class="row">
                        <div class="col-6 mb-2">
                            <label class="form-label">Price (RM)</label>
                            <input type="number" name="price" id="editPrice" class="form-control" step="0.01" min="0" required>
                        </div>
                        <div class="col-6 mb-2">
                            <label class="form-label">Category</label>
                            <select name="categoryId" id="editCategoryId" class="form-select" required>
                                <c:forEach var="cat" items="${categories}">
                                    <option value="${cat.categoryId}">${cat.categoryName}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>
                    <div class="mb-2">
                        <label class="form-label">Image URL</label>
                        <input type="text" name="imageUrl" id="editImageUrl" class="form-control">
                    </div>
                    <div class="form-check">
                        <input type="checkbox" name="available" class="form-check-input" id="editAvailable">
                        <label class="form-check-label" for="editAvailable">Available for ordering</label>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary">Save Changes</button>
                </div>
            </form>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Populate the Edit modal from the clicked row's data-* attributes —
        // avoids a server round-trip just to fetch one item's current values.
        document.querySelectorAll('.edit-item-btn').forEach(function (btn) {
            btn.addEventListener('click', function () {
                document.getElementById('editItemId').value = btn.dataset.itemId;
                document.getElementById('editName').value = btn.dataset.itemName;
                document.getElementById('editDescription').value = btn.dataset.itemDescription || '';
                document.getElementById('editNutrition').value = btn.dataset.itemNutrition || '';
                document.getElementById('editPrice').value = btn.dataset.itemPrice;
                document.getElementById('editImageUrl').value = btn.dataset.itemImage || '';
                document.getElementById('editCategoryId').value = btn.dataset.itemCategory;
                document.getElementById('editAvailable').checked = (btn.dataset.itemAvailable === 'true');
            });
        });

        // Client-side validation (server-side re-validates independently in AdminMenuServlet).
        function validateMenuItemForm(form) {
            var price = parseFloat(form.price.value);
            if (isNaN(price) || price < 0) {
                alert('Please enter a valid, non-negative price.');
                return false;
            }
            if (form.name.value.trim() === '') {
                alert('Name is required.');
                return false;
            }
            return true;
        }
    </script>
</body>
</html>
