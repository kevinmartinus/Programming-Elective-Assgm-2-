/*
    FeastOrder — Client-side JavaScript
    ------------------------------------------------------------
    IMPORTANT: JS validation improves UX but is NOT a substitute for
    server-side validation in your Servlets — always validate on both ends.
*/

// ==== Login Validation ====
function validateLoginForm() {
  let isValid = true;

  const username = document.getElementById("username").value.trim();
  const password = document.getElementById("password").value;

  // Clear previous error messages
  document.getElementById("usernameError").textContent = "";
  document.getElementById("passwordError").textContent = "";

  if (username === "") {
    document.getElementById("usernameError").textContent = "Please enter your username.";
    isValid = false;
  }
  if (password === "") {
    document.getElementById("passwordError").textContent = "Please enter your password.";
    isValid = false;
  }
  // Returning true lets the form submit normally to LoginServlet.
  // Returning false blocks submission so the servlet is never hit with empty fields.
  return isValid;
}

// Register Validation
function validateRegisterForm() {
  let isValid = true;

  const username = document.getElementById("username").value.trim();
  const fullName = document.getElementById("fullName").value.trim();
  const email = document.getElementById("email").value.trim();
  const password = document.getElementById("password").value.trim();
  const confirmPassword = document.getElementById("confirmPassword").value.trim();
  const contactPhone = document.getElementById("contactPhone").value.trim();

  // Clear all previous error messages
  ['username-err', 'fullName-err', 'email-err', 'password-err', 'confirmPassword-err', 'contactPhone-err'].forEach(id => {
    const el = document.getElementById(id);
    if (el) el.textContent = "";
  });

  if (username === "" || username.length < 3) {
    document.getElementById("username-err").textContent = "Username must be at least 3 characters long.";
    isValid = false;
  }

  if (fullName === "" || fullName.length < 3) {
    document.getElementById("fullName-err").textContent = "Full name must be at least 3 characters long.";
    isValid = false;
  } else if (!/^[a-zA-Z\s]+$/.test(fullName)) {
    document.getElementById("fullName-err").textContent = "Full name can only contain letters and spaces.";
    isValid = false;
  }

  const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  if (email === "" || !emailPattern.test(email)) {
    document.getElementById("email-err").textContent = "Please enter a valid email address.";
    isValid = false;
  }

  const passwordPattern = /^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$/;
  if (password === "" || password.length < 8 || !passwordPattern.test(password)) {
    document.getElementById("password-err").textContent = "Password must be at least 8 characters long and contain both letters and numbers.";
    isValid = false;
  }

  if (confirmPassword !== password) {
    document.getElementById("confirmPassword-err").textContent = "Passwords do not match.";
    isValid = false;
  }

  const phonePattern = /^[0-9]{7,15}$/; // Allows 7 to 15 digits
  if (contactPhone === "" || !phonePattern.test(contactPhone)) {
    document.getElementById("contactPhone-err").textContent = "Please enter a valid contact phone number (7-15 digits).";
    isValid = false;
  }

  // RegisterServlet reads a single "phoneNumber" parameter, but the form
  // collects country code + phone number separately for a better UX.
  // Combine them into the hidden field right before submitting.
  if (isValid) {
    const countryCode = document.getElementById("countryCode").value;
    document.getElementById("phoneNumberCombined").value = countryCode + contactPhone;
  }

  return isValid;
}

// Contact Form Validation
function validateContactForm(event) {
  event.preventDefault();

  let isValid = true;
  const name = document.getElementById('contactName').value.trim();
  const email = document.getElementById('contactEmail').value.trim();
  const subject = document.getElementById('contactSubject').value;
  const message = document.getElementById('contactMessage').value.trim();

  ['contactName-err', 'contactEmail-err', 'contactSubject-err', 'contactMessage-err'].forEach(id => {
    const el = document.getElementById(id);
    if (el) el.textContent = '';
  });

  if (name === '' || name.length < 3) {
    document.getElementById('contactName-err').textContent = "Please enter your full name.";
    isValid = false;
  }

  const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  if (email === '' || !emailPattern.test(email)) {
    document.getElementById('contactEmail-err').textContent = "Please enter a valid email address.";
    isValid = false;
  }

  if (subject === '') {
    document.getElementById('contactSubject-err').textContent = "Please choose a subject.";
    isValid = false;
  }

  if (message === '' || message.length < 10) {
    document.getElementById('contactMessage-err').textContent = "Message must be at least 10 characters.";
    isValid = false;
  }

  if (isValid) {
    document.getElementById('contactSuccessAlert').classList.remove('d-none');
    document.getElementById('contactForm').reset();
    document.getElementById('contactSuccessAlert').scrollIntoView({ behavior: 'smooth', block: 'center' });
  }

  return false;
}

// Item detail page: +/- buttons for the quantity stepper
function stepQuantity(button, delta) {
    const stepper = button.closest('.qty-stepper');
    if (!stepper) return;
    const input = stepper.querySelector('.item-quantity');
    if (!input) return;

    let qty = parseInt(input.value, 10);
    if (isNaN(qty)) qty = 1;
    qty += delta;
    if (qty < 1) qty = 1;
    if (qty > 20) qty = 20;
    input.value = qty;

    const feedback = button.closest('form').querySelector('.qty-feedback');
    if (feedback) feedback.textContent = '';
}

// Checkout Form Validation (validates all .item-quantity inputs within a given form)
function validateCheckoutForm(formElement) {
  let isValid = true;
  const quantityInputs = formElement.querySelectorAll(".item-quantity");

  quantityInputs.forEach(input => {
    const qty = parseInt(input.value, 10);
    const itemId = input.dataset.itemId;
    const errorElement = document.getElementById(`qty-error-${itemId}`);

    if (errorElement) errorElement.textContent = ""; // Clear previous error messages

    if (isNaN(qty) || qty <= 0) {
      if (errorElement) errorElement.textContent = "Quantity must be a positive number.";
      isValid = false;
    }
  });
  return isValid;
}

// Menu: combine checked add-ons into the hidden field before Add to Cart
function prepareAddToCart(form) {
    const checked = form.querySelectorAll('.addon-checkbox:checked');
    const addOnsValue = Array.from(checked).map(cb => cb.value).join(', ');
    form.querySelector('.addons-hidden-input').value = addOnsValue;

    const qtyInput = form.querySelector('.item-quantity');
    const feedback = form.querySelector('.qty-feedback');
    const qty = parseInt(qtyInput.value, 10);

    if (feedback) feedback.textContent = '';

    if (isNaN(qty) || qty <= 0) {
        if (feedback) feedback.textContent = 'Quantity must be a positive number.';
        return false;
    }
    if (qty > 20) {
        if (feedback) feedback.textContent = 'Maximum quantity is 20 per item.';
        return false;
    }
    return true;
}

// Cart: single-line quantity update validation
function validateCartQuantityForm(form) {
    const input = form.querySelector('.item-quantity');
    const itemId = input.dataset.itemId;
    const errorEl = document.getElementById('qty-error-' + itemId);
    const qty = parseInt(input.value, 10);

    if (errorEl) errorEl.textContent = '';

    if (isNaN(qty) || qty <= 0) {
        if (errorEl) errorEl.textContent = 'Quantity must be a positive number.';
        return false;
    }
    if (qty > 20) {
        if (errorEl) errorEl.textContent = 'Maximum quantity is 20 per item.';
        return false;
    }
    return true;
}

// Checkout: order type + delivery address validation
function validateOrderForm() {
    let isValid = true;

    const orderType = document.querySelector('input[name="orderType"]:checked');
    const orderTypeError = document.getElementById('orderTypeError');
    orderTypeError.textContent = '';

    if (!orderType) {
        orderTypeError.textContent = 'Please select an order type.';
        isValid = false;
    } else if (orderType.value === 'Delivery') {
        const address = document.getElementById('deliveryAddress').value.trim();
        const addressError = document.getElementById('deliveryAddressError');
        addressError.textContent = '';

        if (address === '' || address.length < 10) {
            addressError.textContent = 'Please enter a complete delivery address.';
            isValid = false;
        }
    }

    return isValid;
}

// Toggle delivery address field based on order type
function setupOrderTypeToggle() {
    const radios = document.querySelectorAll('input[name="orderType"]');
    const addressGroup = document.getElementById('deliveryAddressGroup');
    const pickupNote = document.getElementById('pickupNote');
    if (!radios.length || !addressGroup) return;

    radios.forEach(radio => {
        radio.addEventListener('change', function () {
            if (this.value === 'Delivery' && this.checked) {
                addressGroup.classList.remove('d-none');
                if (pickupNote) pickupNote.classList.add('d-none');
            } else if (this.value === 'Pickup' && this.checked) {
                addressGroup.classList.add('d-none');
                if (pickupNote) pickupNote.classList.remove('d-none');
            }
        });
    });
}

// Live cart subtotal update (optional nice-to-have)
function updateQuantity(itemId, newQty) {
  const qty = parseInt(newQty, 10);
  if (isNaN(qty) || qty <= 0) {
    alert("Quantity must be a positive number.");
    return;
  }

  const priceElement = document.getElementById(`item-price-${itemId}`);
  const subtotalElement = document.getElementById(`item-subtotal-${itemId}`);
  if (!priceElement || !subtotalElement) return;

  const unitPrice = parseFloat(priceElement.textContent.replace(/[^0-9.-]+/g, ""));
  subtotalElement.textContent = (unitPrice * qty).toFixed(2);
}

// Password show/hide toggle
function setupPasswordToggle(toggleId, inputId) {
  const toggle = document.getElementById(toggleId);
  const input = document.getElementById(inputId);
  if (!toggle || !input) return;

  toggle.addEventListener('click', function () {
    const isHidden = input.type === "password";
    input.type = isHidden ? "text" : "password";
    toggle.classList.toggle('bi-eye-slash', !isHidden);
    toggle.classList.toggle('bi-eye', isHidden);
  });
}

// Setup on page load
document.addEventListener('DOMContentLoaded', function () {

  // Password toggle (in both login.jsp and register.jsp)
  setupPasswordToggle('togglePassword', 'password');

  // Order type radio -> delivery address show/hide (cart.jsp)
  setupOrderTypeToggle();

  // Contact form (contact.html)
  const contactForm = document.getElementById('contactForm');
  if (contactForm) {
    contactForm.addEventListener('submit', validateContactForm);
  }

  // FAQ accordion toggle
  document.querySelectorAll('.faq-question').forEach(question => {
    question.addEventListener('click', function () {
      const answer = question.nextElementSibling;
      const isOpen = answer.classList.contains('open');

      document.querySelectorAll('.faq-answer.open').forEach(open => open.classList.remove('open'));
      document.querySelectorAll('.faq-question.active').forEach(active => active.classList.remove('active'));

      if (!isOpen) {
        answer.classList.add('open');
        question.classList.add('active');
      }
    });
  });

  // FAQ live search — filters items within each category, hides empty
  // categories entirely, and shows a "no results" message if nothing matches.
  const faqSearchInput = document.getElementById('faqSearch');
  const faqGroups = document.querySelectorAll('.faq-group');
  if (faqSearchInput && faqGroups.length) {
    faqSearchInput.addEventListener('input', function () {
      const term = this.value.trim().toLowerCase();
      let anyVisibleOverall = false;

      faqGroups.forEach(group => {
        let groupHasMatch = false;

        group.querySelectorAll('.faq-item').forEach(item => {
          const questionText = item.querySelector('.faq-question span').textContent.toLowerCase();
          const answerText = item.querySelector('.faq-answer').textContent.toLowerCase();
          const matches = term === '' || questionText.includes(term) || answerText.includes(term);

          item.classList.toggle('d-none', !matches);
          if (matches) groupHasMatch = true;
        });

        group.classList.toggle('d-none', !groupHasMatch);

        const header = group.previousElementSibling;
        if (header && header.classList.contains('faq-category-header')) {
          header.classList.toggle('d-none', !groupHasMatch);
        }

        if (groupHasMatch) anyVisibleOverall = true;
      });

      const noResults = document.getElementById('faqNoResults');
      if (noResults) noResults.classList.toggle('d-none', anyVisibleOverall || term === '');
    });
  }
});