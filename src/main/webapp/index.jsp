<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.*" %>
<%@ page import="com.restaurantdb.model.Bill,com.restaurantdb.dao.BillDAO" %>
<%@ page import="com.restaurantdb.model.OrderItem,com.restaurantdb.dao.OrderItemsDAO" %>
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
    
    List<Bill> pendingBills = null;
    try {
        BillDAO billDAO = new BillDAO();
        pendingBills = billDAO.getPendingBills();
    } catch (Exception e) {
        e.printStackTrace();
    }
    
    List<OrderItem> pendingOrderItems = null;
    try {
        OrderItemsDAO orderItemsDAO = new OrderItemsDAO();
        pendingOrderItems = orderItemsDAO.getPendingOrderItems();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Dashboard</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
        }

        .navbar {
            background-color: #333;
            padding: 10px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            color: #fff;
        }

        .navbar h1 {
            margin: 0;
            font-size: 24px;
        }

        .navbar .nav-items {
            display: flex;
            gap: 10px;
        }

        .nav-items a {
            padding: 10px 20px;
            background-color: #007bff;
            color: #fff;
            text-decoration: none;
            border-radius: 5px;
            transition: background-color 0.3s ease;
        }

        .nav-items a:hover {
            background-color: #0056b3;
        }

        .container {
            padding: 20px;
        }

        .alert {
            color: red;
            margin-bottom: 20px;
        }
        
        
        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
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

        button {
            padding: 10px 20px;
            cursor: pointer;
            background-color: #28a745;
            color: #fff;
            border: none;
            border-radius: 5px;
            transition: background-color 0.3s ease, transform 0.3s ease;
        }

        button:hover {
            background-color: #218838;
            transform: scale(1.05);
        }

        .text-center {
            text-align: center;
            font-size: 18px;
            color: #666;
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
        <h3>Welcome, <%= empname %></h3>
        <% if (successMessage != null) { %>
            <div class="alert"><%= successMessage %></div>
            <% session.removeAttribute("successMessage");
        } %>

        <% if (errorMessage != null) { %>
            <div class="alert"><%= errorMessage %></div>
            <% session.removeAttribute("errorMessage");
        } %>
    </div>
    <% if("Manager".equals(role)||"Cashier".equals(role)){%>
    
    <div class="container"></div>
    	 <div class="container">
        <h2>Pending Bills</h2>
        <% if (pendingBills != null && !pendingBills.isEmpty()) { %>
            <table>
                <thead>
                    <tr>
                        <th>Bill ID</th>
                        <th>Table ID</th>
                        <th>Total Amount</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Bill bill : pendingBills) { %>
                        <tr>
                            <td><%= bill.getBillId() %></td>
                            <td><%= bill.getTableId() %></td>
             
                            <td>₹<%= bill.getTotalAmount() %></td>
                            <td><%= bill.getBillStatus() %></td>
                            <td>
                                <form action="UpdateBillStatusServlet" method="post">
                                    <input type="hidden" name="bill_id" value="<%= bill.getBillId() %>">
                                    <input type="hidden" name="bill_status" value="<%= bill.getBillStatus() %>">
                                    <button type="submit">Mark as Paid</button>
                                </form>
                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        <% } else { %>
            <p class="text-center">No pending bills available.</p>
        <% } %>
    </div>
    <%} %>
    
    <%if("Waiter".equals(role)){ %>
    	 <div class="container">
        <h2>Pending Order Items</h2>
        <% if (pendingOrderItems != null && !pendingOrderItems.isEmpty()) { %>
            <table>
                <thead>
                    <tr>
                        <th>Order Item ID</th>
                        <th>Order ID</th>
                        <th>Item Name</th>
                        <th>Quantity</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (OrderItem orderItem : pendingOrderItems) { %>
                        <tr>
                            <td><%= orderItem.getItemId() %></td>
                            <td><%= orderItem.getOrderId() %></td>
                            <td><%= orderItem.getItemName() %></td>
                            <td><%= orderItem.getQuantity() %></td>
                            <td><%= orderItem.getStatus() %></td>
                            <td>
                                <form action="UpdateOrderItemStatusServlet" method="post">
                                    <input type="hidden" name="itemId" value="<%= orderItem.getItemId() %>">
                                    <input type="hidden" name="orderId" value="<%= orderItem.getOrderId() %>">
                                    <button type="submit">Mark as Done</button>
                                </form>
                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        <% } else { %>
            <p class="text-center">No pending order items available.</p>
        <% } %>
    </div>
    <%} %>
</body>
</html>
