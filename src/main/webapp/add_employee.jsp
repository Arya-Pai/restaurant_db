<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%@ page import="com.restaurantdb.model.Employee" %>
<%@ page import="com.restaurantdb.dao.EmployeeDAO" %>
<%@ page import="java.util.List" %>

<%
    HttpSession sessionObj = request.getSession();
    String successMessage = (String) sessionObj.getAttribute("successMessage");
    String errorMessage = (String) sessionObj.getAttribute("errorMessage");
    String newRoleMessage = (String) sessionObj.getAttribute("newRoleMessage");
    Employee pendingEmployee = (Employee) sessionObj.getAttribute("pendingEmployee");
    List<Employee> employees =  EmployeeDAO.getAllEmployees();
    String empname = (String) session.getAttribute("emp_name");
    String role = (String) session.getAttribute("role_name");
    Integer employeeId = (Integer) session.getAttribute("emp_id");
   

    if (empname == null || role == null) {
        response.sendRedirect("login.jsp");
        return;
    }

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
        body {
            background-color: #f0f2f5;
            font-family: 'Arial', sans-serif;
            margin: 0;
            padding: 0;
        }

        .navbar {
            background-color: #333;
            padding: 15px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            color: #fff;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
        }

        .navbar h1 {
            margin: 0;
            font-size: 24px;
            font-weight: bold;
        }

        .navbar .nav-items {
            display: flex;
            gap: 15px;
        }

        .nav-items a {
            padding: 10px 20px;
            background-color: #007bff;
            color: #fff;
            text-decoration: none;
            border-radius: 5px;
            transition: background-color 0.3s ease, transform 0.3s ease;
        }

        .nav-items a:hover {
            background-color: #0056b3;
            transform: scale(1.05);
        }

        .container {
            padding: 40px;
            max-width: 1000px;
            margin: 40px auto;
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        h2 {
            text-align: center;
            color: #333;
            margin-bottom: 40px;
            font-size: 28px;
            font-weight: bold;
            text-transform: uppercase;
        }

        .form-group {
            margin-bottom: 20px;
        }

        label {
            display: block;
            margin-bottom: 5px;
            color: #333;
            font-weight: bold;
        }

        input[type="text"],
        input[type="tel"],
        input[type="password"] {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            box-sizing: border-box;
            font-size: 16px;
        }

        .invalid-feedback {
            color: red;
            font-size: 12px;
        }

        .btn {
            padding: 10px 20px;
            cursor: pointer;
            background-color: #007bff;
            color: #fff;
            border: none;
            border-radius: 5px;
            transition: background-color 0.3s ease, transform 0.3s ease;
        }

        .btn:hover {
            background-color: #0056b3;
            transform: scale(1.05);
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        th, td {
            padding: 15px;
            border-bottom: 1px solid #ddd;
            text-align: center;
            font-size: 16px;
        }

        th {
            background-color: #007bff;
            color: #fff;
            text-transform: uppercase;
            font-weight: bold;
        }

        tr:nth-child(even) {
            background-color: #f9f9f9;
        }

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

        .alert {
            color: red;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <!-- Navbar -->
     <div class="navbar">
        <h1><%= role %> Dashboard</h1>
        <div class="nav-items">
            <% if ("Waiter".equals(role)) { %>
                <a href="table.jsp">Take Order</a>
                <a href="editOrder.jsp">View and Edit Orders</a>
                <a href="menu.jsp">Menu</a>
                <a href="LogoutServlet">Logout</a>
            <% } else if ("admin".equals(role)) { %>
                <a href="total_sales.jsp">Total Sales</a>
                <a href="add_employee.jsp">Add Employee</a>
                <a href="add_menu.jsp">Add Menu Item</a>
                <a href="add_table.jsp">Add Table</a>
              <a href="LogoutServlet">Logout</a>
            <% } else if ("Manager".equals(role)) { %>
                <a href="total_sales.jsp">Total Sales</a>
                <a href="table.jsp">Take Order</a>
                <a href="menu.jsp">Menu</a>
                <a href="editOrder.jsp">View and Edit Orders</a>
                <a href="LogoutServlet">Logout</a>
            <% } else if ("Cashier".equals(role)) { %>
                <a href="todaySales.jsp">Today's Sales</a>
                <a href="payment.jsp">Make Payment</a>
                <a href="LogoutServlet">Logout</a>
            <% } %>
        </div>
    </div>

    <div class="container">
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

        <h2 class="mt-5">Manage Employees</h2>
        <table class="table table-striped">
            <thead>
                <tr>
                    <th>Name</th>
                    <th>Phone</th>
                    <th>Role</th>
                    <th>Status</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <% if (employees != null) {
                    for (Employee employee : employees) { %>
                        <tr>
                            <td><%= employee.getEmp_name() %></td>
                            <td><%= employee.getPhone() %></td>
                            <td><%= employee.getRoleName() %></td>
                            <td><%= employee.isActive() ? "Active" : "Inactive" %></td>
                            <td>
                                <form action="UpdateEmployeeServlet" method="post" style="display:inline;">
                                    <input type="hidden" name="employeeId" value="<%= employee.getId() %>">
                                    <input type="hidden" name="status" value="<%= employee.isActive() ? "inactive" : "active" %>">
                                    <button type="submit" class="btn btn-<%= employee.isActive() ? "danger" : "success" %>">
                                        <%= employee.isActive() ? "Set Inactive" : "Set Active" %>
                                    </button>
                                </form>
                            </td>
                        </tr>
                <%  } 
                } %>
            </tbody>
        </table>

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

    </div>

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

