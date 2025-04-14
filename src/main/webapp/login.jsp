<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login - Restaurant Management System</title>

    <!-- Bootstrap 5 CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        body {
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            font-family: 'Segoe UI', sans-serif;
            margin: 0;
        }

        .login-card {
            background-color: #ffffff;
            border-radius: 15px;
            padding: 40px;
            box-shadow: 0px 8px 20px rgba(0, 0, 0, 0.15);
            width: 100%;
            max-width: 400px;
        }

        .login-title {
            font-size: 28px;
            font-weight: 600;
            margin-bottom: 10px;
            color: #333;
        }

        .login-subtitle {
            font-size: 16px;
            color: #666;
            margin-bottom: 30px;
        }

        .form-label {
            font-weight: 500;
        }

        .form-control {
            border-radius: 8px;
            font-size: 15px;
        }

        .btn-login {
            background-color: #007bff;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            padding: 10px;
            width: 100%;
            color: #fff;
            transition: background-color 0.3s ease-in-out;
        }

        .btn-login:hover {
            background-color: #0056b3;
        }

        .alert {
            margin-top: 15px;
        }
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

