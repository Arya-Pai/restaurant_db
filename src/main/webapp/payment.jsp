<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.restaurantdb.model.Bill" %>
<%@ page import="com.restaurantdb.dao.BillDAO" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>

<%
    HttpSession userSession = request.getSession(false);
    if (userSession == null || userSession.getAttribute("emp_id") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String empname = (String) session.getAttribute("emp_name");
    String role = (String) session.getAttribute("role_name");
    Integer employeeId = (Integer) session.getAttribute("emp_id");
    String successMessage = (String) session.getAttribute("successMessage");
    String errorMessage = (String) session.getAttribute("errorMessage");

    if (empname == null || role == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Pending Payments</title>
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

        button, input[type="submit"] {
            padding: 10px 20px;
            cursor: pointer;
            background-color: #28a745;
            color: #fff;
            border: none;
            border-radius: 5px;
            transition: background-color 0.3s ease, transform 0.3s ease;
        }

        button:hover, input[type="submit"]:hover {
            background-color: #218838;
            transform: scale(1.05);
        }

        .form-group {
            margin-bottom: 20px;
            display: flex;
            flex-direction: column;
            align-items: flex-start;
        }

        label {
            margin-bottom: 5px;
            color: #333;
            font-weight: bold;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        input[type="text"], select {
            width: 100%;
            padding: 15px;
            border: 1px solid #ddd;
            border-radius: 5px;
            box-sizing: border-box;
            font-size: 16px;
        }

        .btn-success {
            background-color: #007bff;
        }

        .btn-success:hover {
            background-color: #0056b3;
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
        <h2>Pending Payments</h2>
        <%
            String billIdParam = request.getParameter("billId");
            Integer billId = billIdParam != null ? Integer.parseInt(billIdParam) : null;
            Bill selectedBill = null;
            if (billId != null) {
                try {
                    BillDAO billDAO = new BillDAO();
                    selectedBill = billDAO.getBill(billId);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
            if (billId == null) {
        %>
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
                <%
                    try {
                        BillDAO billDAO = new BillDAO();
                        List<Bill> pendingBills = billDAO.getPendingBills();
                        if (pendingBills != null && !pendingBills.isEmpty()) {
                            for (Bill bill : pendingBills) {
                %>
                <tr>
                    <td><%= bill.getBillId() %></td>
                    <td><%= bill.getTableId() %></td>
                    <td>₹<%= bill.getTotalAmount() %></td>
                    <td><%= bill.getBillStatus() %></td>
                    <td>
                        <form action="payment.jsp" method="get">
                            <input type="hidden" name="billId" value="<%= bill.getBillId() %>">
                            <input type="submit" value="Process Payment" class="btn btn-primary">
                        </form>
                    </td>
                </tr>
                <%
                            }
                        } else {
                %>
                <tr>
                    <td colspan="5" class="text-center">No pending payments.</td>
                </tr>
                <%
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                %>
            </tbody>
        </table>
        <% } else { %>
        <h2>Process Payment for Bill ID: <%= billId %></h2>
        <form action="PaymentServlet" method="post">
            <input type="hidden" name="billId" value="<%= billId %>">
            <div class="form-group">
                <label for="amount">Amount:</label>
                <input type="text" id="amount" name="amount" value="<%= selectedBill != null ? selectedBill.getTotalAmount() : "" %>" >
            </div>
            <div class="form-group">
                <label for="paymentMode">Payment Mode:</label>
                <select id="paymentMode" name="paymentMode" required>
                    <option value="Cash">Cash</option>
                    <option value="Card">Card</option>
                    <option value="UPI">UPI</option>
                </select>
            </div>
            <div class="form-group">
                <label for="paymentStatus">Payment Status:</label>
                <select id="paymentStatus" name="paymentStatus" required>
                    <option value="Completed">Completed</option>
                    <option value="Failed">Failed</option>
                    <option value="Refunded">Refunded</option>
                </select>
            </div>
            <input type="submit" value="Process Payment" class="btn btn-success">
        </form>
        <% } %>
    </div>
</body>
</html>