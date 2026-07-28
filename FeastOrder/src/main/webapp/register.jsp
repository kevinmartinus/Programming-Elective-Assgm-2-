<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>FeastOrder - Register</title>
    <link  rel="stylesheet" href="css/style.css">
    <link  rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
</head>
<body>
    <header>
        <nav class="navbar">
            <a href="index.html" class="logo">FeastOrder</a>
        </nav>
    </header>

    <main class="auth-page">
        <div class="auth-card">
            <h1>Create an Account</h1>

            <% if(request.getAttribute("error") != null) { %>
                <p class="error-message"><%= request.getAttribute("error") %></p>
            <% } %>

            <form action="register" method="post" onsubmit="return validateRegisterForm()" id="registerForm">
                <!-- RegisterServlet reads a single "phoneNumber" param; main.js combines
                     countryCode + contactPhone into this hidden field right before submit. -->
                <input type="hidden" name="phoneNumber" id="phoneNumberCombined">
                
                 <!-- Username: required, used for login -->
                <div class="form-group">
                    <label for="username"><i class="bi bi-person"></i> Username</label>
                    <input type="text" id="username" name="username" required minlength="3"
                           placeholder="Choose a username"
                           value="${not empty username ? username : ''}">
                    <span class="field-error ${not empty usernameError ? 'show' : ''}" id="username-err">
                        ${usernameError}
                    </span>
                </div>
                
                <!-- Full Name: Only letters and spaces are allowed. -->
                <div class="form-group">
                    <label for="fullName">Full Name</label>
                    <input type="text" id="fullName" name="fullName" required minlength="3"
                           placeholder="Enter your full name"
                           value="${not empty fullName ? fullName : ''}">
                    <span class="field-error ${not empty fullNameError ? 'show' : ''}" id="fullName-err">
                        ${fullNameError}
                    </span>
                </div>

                <!-- Phone -->
                <div class="form-group">
                    <label  for="contactPhone">
                        <i class="bi bi-telephone"></i> Contact Phone
                    </label>
                    <div style="display:flex; gap:8px;">
                    <select id="countryCode" name="countryCode" aria-label="Country code" style="width:140px; flex-shrink:0;">
                            <!-- Southeast Asia -->
                             <option value="+60" ${countryCode == '+60' ? 'selected' : ''}>🇲🇾 +60 MY</option>
                             <option value="+65" ${countryCode == '+65' ? 'selected' : ''}>🇸🇬 +65 SG</option>
                             <option value="+62" ${countryCode == '+62' ? 'selected' : ''}>🇮🇩 +62 ID</option>
                             <option value="+66" ${countryCode == '+66' ? 'selected' : ''}>🇹🇭 +66 TH</option>
                             <option value="+63" ${countryCode == '+63' ? 'selected' : ''}>🇵🇭 +63 PH</option>
                             <option value="+84" ${countryCode == '+84' ? 'selected' : ''}>🇻🇳 +84 VN</option>
                             <option value="+95" ${countryCode == '+95' ? 'selected' : ''}>🇲🇲 +95 MM</option>
                             <option value="+855" ${countryCode == '+855' ? 'selected' : ''}>🇰🇭 +855 KH</option>
                             <option value="+856" ${countryCode == '+856' ? 'selected' : ''}>🇱🇦 +856 LA</option>
                             <option value="+673" ${countryCode == '+673' ? 'selected' : ''}>🇧🇳 +673 BN</option>
                             <option value="+670" ${countryCode == '+670' ? 'selected' : ''}>🇹🇱 +670 TL</option>
                             
                             <!-- East Asia -->
                             <option value="+86" \${countryCode == '+86' ? 'selected' : ''}>🇨🇳 +86 CN</option>
                             <option value="+81" \${countryCode == '+81' ? 'selected' : ''}>🇯🇵 +81 JP</option>
                             <option value="+82" \${countryCode == '+82' ? 'selected' : ''}>🇰🇷 +82 KR</option>
                             <option value="+852" \${countryCode == '+852' ? 'selected' : ''}>🇭🇰 +852 HK</option>
                             <option value="+853" \${countryCode == '+853' ? 'selected' : ''}>🇲🇴 +853 MO</option>
                             <option value="+886" \${countryCode == '+886' ? 'selected' : ''}>🇹🇼 +886 TW</option>

                             <!-- South Asia -->
                             <option value="+91" \${countryCode == '+91' ? 'selected' : ''}>🇮🇳 +91 IN</option>
                             <option value="+92" \${countryCode == '+92' ? 'selected' : ''}>🇵🇰 +92 PK</option>
                             <option value="+94" \${countryCode == '+94' ? 'selected' : ''}>🇱🇰 +94 LK</option>
                             <option value="+880" \${countryCode == '+880' ? 'selected' : ''}>🇧🇩 +880 BD</option>

                            <!-- Middle East -->
                             <option value="+971" \${countryCode == '+971' ? 'selected' : ''}>🇦🇪 +971 AE</option>
                             <option value="+966" \${countryCode == '+966' ? 'selected' : ''}>🇸🇦 +966 SA</option>
                             <option value="+974" \${countryCode == '+974' ? 'selected' : ''}>🇶🇦 +974 QA</option>
                             <option value="+965" \${countryCode == '+965' ? 'selected' : ''}>🇰🇼 +965 KW</option>
                             <option value="+973" \${countryCode == '+973' ? 'selected' : ''}>🇧🇭 +973 BH</option>
                             <option value="+968" \${countryCode == '+968' ? 'selected' : ''}>🇴🇲 +968 OM</option>

                             <!-- Western -->
                              <option value="+44" \${countryCode == '+44' ? 'selected' : ''}>🇬🇧 +44 GB</option>
                              <option value="+1" \${countryCode == '+1' ? 'selected' : ''}>🇺🇸 +1 US</option>
                              <option value="+1" \${countryCode == '+1' ? 'selected' : ''}>🇨🇦 +1 CA</option>
                              <option value="+61" \${countryCode == '+61' ? 'selected' : ''}>🇦🇺 +61 AU</option>
                              <option value="+64" \${countryCode == '+64' ? 'selected' : ''}>🇳🇿 +64 NZ</option>
                              <option value="+33" \${countryCode == '+33' ? 'selected' : ''}>🇫🇷 +33 FR</option>
                              <option value="+49" \${countryCode == '+49' ? 'selected' : ''}>🇩🇪 +49 DE</option>
                        </select> 
                        <input  type="tel" id="contactPhone" name="contactPhone"
                                placeholder="e.g., 12-3456789"
                                style="flex:1;"
                                value="${not empty contactPhone ? contactPhone : ''}">
                    </div>
                        <span   class="field-error ${not empty contactPhoneError ? 'show' : ''}" id="contactPhone-err">
                                ${contactPhoneError}
                        </span>
                </div>

                <!-- Email: Required and must be a valid email format. -->
                <div class="form-group">
                    <label for="email">
                        <i class="bi bi-envelope"></i>Email Address
                    </label>
                    <input type="email" id="email" name="email" required
                           placeholder="abc@example.com"
                           value="${not empty email ? email : ''}">
                    <span class="field-error ${not empty emailError ? 'show' : ''}" id="email-err">
                        ${emailError}
                    </span>
                </div>

                <!-- Password: Required and must be at least 8 characters long. -->
                <div class="form-group">
                    <label for="password">
                        <i class="bi bi-lock"></i> Password
                    </label>
                    <div style="display:flex; align-items:center; gap:6px;">
                        <input type="password" id="password" name="password" required minLength="8">
                        <i class="bi bi-eye-slash" id="togglePassword" style="cursor: pointer;"></i>
                    </div>
                    <span class="field-error" id="password-err"></span>
                </div>

                <!-- Confirm Password: Required and must match the password. -->
                <div class="form-group">
                    <label for="confirmPassword">
                        <i class="bi bi-lock"></i> Confirm Password
                    </label>
                    <input type="password" id="confirmPassword" name="confirmPassword" required minLength="8">
                    <span class="field-error" id="confirmPassword-err"></span>
                </div>

                <button type="submit" class="btn-primary">Register</button>
            </form>

            <p class="auth-switch">Already have an account? <a href="login.jsp">Login here</a></p>
        </div>
    </main>

    <script src="js/main.js"></script>

</body>
</html>
