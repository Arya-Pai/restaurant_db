<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.restaurantdb.model.Sale" %>
<%@ page import="com.restaurantdb.dao.SalesDAO" %>
<%@ page import="java.text.DecimalFormat" %>

<%
    String empname = (String) session.getAttribute("emp_name");
    String role = (String) session.getAttribute("role_name");
    if (empname == null || role == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    List<Sale> totalSales = null;
    double totalAmount = 0.0;

    try {
        SalesDAO salesDAO = new SalesDAO();
        totalSales = salesDAO.getAllCompletedSales();
        for (Sale sale : totalSales) {
            totalAmount += sale.getAmount();
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
    <title>Total Sales</title>
	<link rel="stylesheet" href="css/navbar.css">
<link rel="stylesheet" href="css/sales.css">
    <style>
        
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

    <div class="container mt-5">
        <h2>Total Sales</h2>
        <div class="total-amount">
            Total Amount: ₹<%= new DecimalFormat("#0.00").format(totalAmount) %>
        </div>
        <table class="table table-bordered">
            <thead>
                <tr>
                    <th>Order ID</th>
                    <th>Payment Time</th>
                    <th>Payment ID</th>
                    <th>Payment Mode</th>
                    <th>Employee Name</th>
                    <th>Bill ID</th>
                    <th>Total Amount</th>
                </tr>
            </thead>
            <tbody>
                <% if (totalSales != null && !totalSales.isEmpty()) {
                    for (Sale sale : totalSales) { %>
                    <tr>
                        <td><%= sale.getOrderId() %></td>
                        <td><%= sale.getPaymentTime() %></td>
                        <td><%= sale.getPaymentId() %></td>
                        <td><%= sale.getPaymentMode() %></td>
                        <td><%= sale.getEmployeeName() %></td>
                        <td><%= sale.getBillId() %></td>
                        <td>₹<%= new DecimalFormat("#0.00").format(sale.getAmount()) %></td>
                    </tr>
                <% }
                } else { %>
                    <tr>
                        <td colspan="7" class="text-center">No sales data available.</td>
                    </tr>
                <% } %>
            </tbody>
        </table>
    </div>
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.4/dist/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>