<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.restaurantdb.model.Menu" %>
<%@ page import="java.util.List,java.util.Map, java.util.HashMap" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%@ page import="com.restaurantdb.model.Category, com.restaurantdb.dao.CategoryDAO" %>
<%@ page import="com.restaurantdb.dao.MenuItems" %>

<%
    // Get employee name and role from session
    String empname = (String) session.getAttribute("emp_name");
    String role = (String) session.getAttribute("role_name");
    Integer employeeId = (Integer) session.getAttribute("emp_id");
    String successMessage = (String) session.getAttribute("successMessage");
    String errorMessage = (String) session.getAttribute("errorMessage");

    if (empname == null || role == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String newRoleMessage = (String) session.getAttribute("newCategoryMessage");
    Menu pendingMenu = (Menu) session.getAttribute("pendingItem");
    
    
    List<Category> categories = null;
    Map<Integer, List<Menu>> categorizedMenuItems = new HashMap<>();

    try {
        CategoryDAO categoryDAO = new CategoryDAO();
        MenuItems menuItemsDAO = new MenuItems();

        // Retrieve all categories
        categories = categoryDAO.getAllCategories();

        // Retrieve menu items for each category
        for (Category category : categories) {
            List<Menu> menuItems = menuItemsDAO.getMenuItemsByCategory(category.getCategoryId());
            categorizedMenuItems.put(category.getCategoryId(), menuItems);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
%>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Add Menu Item</title>
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
    input[type="number"],
    select {
        width: 100%;
        padding: 10px;
        border: 1px solid #ddd;
        border-radius: 5px;
        box-sizing: border-box;
        font-size: 16px;
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
        <h2>Add Menu Item</h2>
        <form action="AddMenuServlet" method="post" class="needs-validation" novalidate>
            <div class="form-group">
                <label for="item_name">Item Name:</label>
                <input type="text" class="form-control" id="item_name" name="item_name" required>
                <div class="invalid-feedback">Please enter an item name.</div>
            </div>
            <div class="form-group">
                <label for="category_name">Category Name:</label>
                <input type="text" class="form-control" id="category_name" name="category_name" required>
                <div class="invalid-feedback">Please enter a category name.</div>
            </div>
            <div class="form-group">
                <label for="price">Price:</label>
                <input type="number" class="form-control" id="price" name="price" required>
                <div class="invalid-feedback">Please enter a price.</div>
            </div>
            
            <button type="submit" class="btn btn-primary">Add</button>
        </form>
		 <div class="container">
        <h2>Menu Items</h2>
        <% if (categories != null && !categories.isEmpty()) { %>
        <br>
            <% for (Category category : categories) { %>
                <div class="category">
                    <h3><%= category.getCategoryName() %> (<%= category.getType() %>)</h3>
                    <% List<Menu> menuItems = categorizedMenuItems.get(category.getCategoryId()); %>
                    <% if (menuItems != null && !menuItems.isEmpty()) { %>
                        <table>
                            <thead>
                                <tr>
                                    <th>Item Name</th>
                                    <th>Price</th>
                          
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Menu menuItem : menuItems) { %>
                                    <tr>
                                        <td><%= menuItem.getItem_name() %></td>
                                        <td>₹<%= menuItem.getPrice() %></td>
                                
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    <% } else { %>
                        <p>No items available in this category.</p>
                    <% } %>
                </div>
                <br>
            <% } %>
        <% } else { %>
            <p>No categories or menu items available.</p>
        <% } %>
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

