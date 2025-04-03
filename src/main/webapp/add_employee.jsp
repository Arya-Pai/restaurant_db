<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%@ page import="com.restaurantdb.model.Employee" %>

<%
    HttpSession sessionObj = request.getSession();
    String successMessage = (String) sessionObj.getAttribute("successMessage");
    String errorMessage = (String) sessionObj.getAttribute("errorMessage");
    String newRoleMessage = (String) sessionObj.getAttribute("newRoleMessage");
    Employee pendingEmployee = (Employee) sessionObj.getAttribute("pendingEmployee");

    if (successMessage != null) { %>
    <script>
        alert("<%= successMessage %>");
    </script>
<%  sessionObj.removeAttribute("successMessage");
    }

    if (errorMessage != null) { %>
    <script>
        alert("<%= errorMessage %>");
    </script>
<%  sessionObj.removeAttribute("errorMessage");
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Employee</title>
    <link href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .modal {
            display: none;
            position: fixed;
            z-index: 1;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow: auto;
            background-color: rgb(0, 0, 0);
            background-color: rgba(0, 0, 0, 0.4);
        }
        .modal-content {
            background-color: #fefefe;
            margin: 15% auto;
            padding: 20px;
            border: 1px solid #888;
            width: 80%;
            max-width: 500px;
            border-radius: 10px;
        }
        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .modal-header h5 {
            margin: 0;
        }
    </style>
</head>
<body>
    <div class="container mt-5">
        <h2>Add Employee</h2>
        <form action="AddEmployeeServlet" method="post" class="needs-validation" novalidate>
            <div class="form-group">
                <label for="name">Name:</label>
                <input type="text" class="form-control" id="name" name="name" required>
                <div class="invalid-feedback">Please enter a name.</div>
            </div>
            <div class="form-group">
                <label for="phone">Phone:</label>
                <input type="tel" class="form-control" id="phone" name="phone" required>
                <div class="invalid-feedback">Please enter a phone number.</div>
            </div>
            <div class="form-group">
                <label for="password">Password:</label>
                <input type="password" class="form-control" id="password" name="password" required>
                <div class="invalid-feedback">Please enter a password.</div>
            </div>
            <div class="form-group">
                <label for="role_name">Role:</label>
                <input type="text" class="form-control" id="role_name" name="role_name" required>
                <div class="invalid-feedback">Please enter a role.</div>
            </div>
            <button type="submit" class="btn btn-primary">Add Employee</button>
        </form>
    </div>

    <% if (newRoleMessage != null) { %>
        <div id="roleConfirmModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Confirm Role Creation</h5>
                    <button type="button" class="close" onclick="closeModal()">&times;</button>
                </div>
                <div class="modal-body">
                    <p><%= newRoleMessage %></p>
                    <form action="AddEmployeeServlet" method="post">
                        <input type="hidden" name="name" value="<%= pendingEmployee.getEmp_name() %>">
                        <input type="hidden" name="phone" value="<%= pendingEmployee.getPhone() %>">
                        <input type="hidden" name="password" value="<%= pendingEmployee.getPassword() %>">
                        <input type="hidden" name="role_name" value="<%= pendingEmployee.getRoleName() %>">
                        <input type="hidden" name="confirmCreateRole" value="yes">
                        <button type="submit" class="btn btn-success">Yes, Create Role and Add Employee</button>
                    </form>
                    <button class="btn btn-danger" onclick="closeModal()">No, Cancel</button>
                </div>
            </div>
        </div>
        <script>
            document.getElementById("roleConfirmModal").style.display = "block";
            function closeModal() {
                document.getElementById("roleConfirmModal").style.display = "none";
            }
        </script>
    <% sessionObj.removeAttribute("newRoleMessage"); 
       sessionObj.removeAttribute("pendingEmployee");
    } %>

    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.4/dist/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <script>
        // Bootstrap form validation
        (function() {
            'use strict';
            window.addEventListener('load', function() {
                var forms = document.getElementsByClassName('needs-validation');
                var validation = Array.prototype.filter.call(forms, function(form) {
                    form.addEventListener('submit', function(event) {
                        if (form.checkValidity() === false) {
                            event.preventDefault();
                            event.stopPropagation();
                        }
                        form.classList.add('was-validated');
                    }, false);
                });
            }, false);
        })();
    </script>
</body>
</html>

