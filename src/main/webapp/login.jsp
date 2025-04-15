<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login - Restaurant Management System</title>

    <!-- Bootstrap 5 CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="css/login.css">

    <style>
       
    </style>
</head>
<body>

    <div class="login-card">
        <div class="text-center">
            <div class="login-title">Welcome to RMS</div>
            <div class="login-subtitle">DBMS Mini Project</div>
        </div>

        <form action="LoginServlet" method="post">
            <div class="mb-3">
                <label for="emp_id" class="form-label">Employee ID</label>
                <input type="text" class="form-control" id="emp_id" name="emp_id" required placeholder="Enter your ID">
            </div>

            <div class="mb-4">
                <label for="emp_password" class="form-label">Password</label>
                <input type="password" class="form-control" id="emp_password" name="emp_password" maxlength="6" pattern="[0-9]{6}" required placeholder="Enter 6-digit code">
                <div class="form-text">Must be a 6-digit number</div>
            </div>

            <input type="submit" class="btn btn-login" value="Login">
        </form>

        <% 
            String errorMessage = (String) session.getAttribute("errorMessage");
            if (errorMessage != null) {
        %>
            <div class="alert alert-danger mt-3 text-center" role="alert">
                <%= errorMessage %>
            </div>
        <%
                session.removeAttribute("errorMessage");
            }
        %>
    </div>

    <!-- Bootstrap JS (optional) -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

