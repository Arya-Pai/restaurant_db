<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.*" %>
<%@ page import="com.restaurantdb.model.Bill,com.restaurantdb.dao.BillDAO" %>
<%@ page import="com.restaurantdb.model.OrderItem,com.restaurantdb.dao.OrderItemsDAO" %>
<%@ page import="com.restaurantdb.dao.SalesDAO" %>
<%@ page import="com.restaurantdb.model.Sale" %>
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
<html>
<head>
    <meta charset="UTF-8">
    <title>Dashboard</title>
     <link rel="stylesheet" href="css/navbar.css">
  <link rel="stylesheet" href="css/style.css">
    <style>

     
    </style>
</head>
<body>
    <div class="navbar">
        <h1><a href="index.jsp" > <%= role %> Dashboard </a></h1>
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
    
    
    <%if("admin".equals(role)){%>
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
    
    <%} %>
</body>
</html>
