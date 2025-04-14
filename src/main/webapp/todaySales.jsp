<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.restaurantdb.dao.SalesDAO" %>
<%@ page import="com.restaurantdb.model.Sale" %>

<%
String empname = (String) session.getAttribute("emp_name");
String role = (String) session.getAttribute("role_name");
Integer employeeId = (Integer) session.getAttribute("emp_id");
String successMessage = (String) session.getAttribute("successMessage");
String errorMessage = (String) session.getAttribute("errorMessage");

if (empname == null || role == null) {
    response.sendRedirect("login.jsp");
    return;
}
List<Sale> todaysSales = null;
double totalAmount = 0;
try {
    SalesDAO salesDAO = new SalesDAO();
    todaysSales = salesDAO.getTodaySales();
    if (todaysSales != null) {
        for (Sale sale : todaysSales) {
            totalAmount += sale.getAmount();
        }
    }
} catch (Exception e) {
    e.printStackTrace();
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Today's Sales</title>
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f0f2f5;
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
    </style>
</head>
<body>
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
        <h2>Today's Sales</h2>
        <table>
            <thead>
                <tr>
                	<th>Payment ID</th>
                	<th>Bill ID</th>
                    <th>Order ID</th>
                    <th>Table Number</th>
                    <th>Employee Name</th>
                    <th>Amount</th>
                    <th>Payment Mode</th>
                </tr>
            </thead>
            <tbody>
                <% if (todaysSales != null && !todaysSales.isEmpty()) {
                    for (Sale sale : todaysSales) { %>
                    <tr>
                        <td><%= sale.getPaymentId() %></td>
                        <td><%= sale.getBillId() %></td>
                        <td><%= sale.getOrderId() %></td>
                        <td><%= sale.getTableNumber() %></td>
     
                        <td><%= sale.getEmployeeName() %></td>
                        <td>₹<%= sale.getAmount() %></td>
                        <td><%= sale.getPaymentMode() %></td>
                    </tr>
                <% }
                } else { %>
                    <tr>
                        <td colspan="8" class="text-center">No sales found for today.</td>
                    </tr>
                <% } %>
                <tr class="total">
                    <td colspan="6" class="text-right">Total Amount:</td>
                    <td colspan="2">₹<%= totalAmount %></td>
                </tr>
            </tbody>
        </table>
    </div>
</body>
</html>