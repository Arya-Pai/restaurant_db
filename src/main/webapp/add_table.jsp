<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.restaurantdb.dao.TableDAO" %>
<%@ page import="com.restaurantdb.model.Table" %>
<!DOCTYPE html>
<html>
<head>
<%
    String empname = (String) session.getAttribute("emp_name");
    String role = (String) session.getAttribute("role_name");
    Integer employeeId = (Integer) session.getAttribute("employee_id");
    System.out.println(role);

    if (empname == null || role == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    List<Table> tablesList = null;
    try {
        TableDAO tableDAO = new TableDAO();
        tablesList = tableDAO.getAllTables();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
<meta charset="UTF-8">
<title>Add Table</title>
 <link rel="stylesheet" href="css/navbar.css">
<style>
   
    .container {
        padding: 40px;
        max-width: 800px;
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

    form {
        display: flex;
        flex-direction: column;
        gap: 20px;
    }

    label {
        color: #333;
        font-weight: bold;
        text-transform: uppercase;
        letter-spacing: 1px;
    }

    input[type="number"] {
        padding: 15px;
        border: 1px solid #ddd;
        border-radius: 5px;
        width: calc(100% - 32px);
        box-sizing: border-box;
        font-size: 16px;
    }

    button {
        padding: 15px 20px;
        cursor: pointer;
        background-color: #28a745;
        color: #fff;
        border: none;
        border-radius: 5px;
        transition: background-color 0.3s ease, transform 0.3s ease;
        font-size: 16px;
        font-weight: bold;
    }

    button:hover {
        background-color: #218838;
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

    .total {
        font-weight: bold;
    }
</style>
</head>
<body>
    <div class="navbar">
        <h1><a href="index.jsp"><%= role %> Dashboard</a></h1>
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
        <h2>Add Table</h2>
        <form method="post" action="AddTableServlet">
            <label>Enter Total Tables Capacity:</label>
            <input type="number" name="table_capacity" required min="2">
            <label>Enter Total Tables with given Capacity:</label>
            <input type="number" name="totalTables" required min="1">
            <button type="submit">Add Tables</button>
        </form>

        <h2>Existing Tables</h2>
        <table>
            <thead>
                <tr>
                    <th>Table ID</th>
                    <th>Table Number</th>
                    <th>Capacity</th>
                </tr>
            </thead>
            <tbody>
                <% if (tablesList != null && !tablesList.isEmpty()) {
                    for (Table table : tablesList) { %>
                    <tr>
                        <td><%= table.getTableId() %></td>
                        <td><%= table.getTableNumber() %></td>
                        <td><%= table.getCapacity() %></td>
                    </tr>
                <% }
                } else { %>
                    <tr>
                        <td colspan="3" class="text-center">No tables found.</td>
                    </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</body>
</html>