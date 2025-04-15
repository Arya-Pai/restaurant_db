<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.restaurantdb.model.Bill" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>

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
    HttpSession userSession = request.getSession(false);
    if (userSession == null || userSession.getAttribute("emp_id") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Bill List</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
        }

        .container {
            padding: 20px;
        }

        table { 
            width: 100%; 
            border-collapse: collapse; 
            margin-top: 20px; 
        }
        
        th, td { 
            padding: 10px; 
            border: 1px solid black; 
            text-align: center; 
        }
        
        th { 
            background-color: #f2f2f2; 
        }

        button, input[type="submit"] { 
            padding: 5px 10px; 
            cursor: pointer; 
            background-color: #007bff; 
            color: #fff; 
            border: none; 
            border-radius: 5px; 
            transition: background-color 0.3s ease; 
        }

        button:hover, input[type="submit"]:hover { 
            background-color: #0056b3; 
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
        <h2>Bill List</h2>
        <table>
            <tr>
                <th>Bill ID</th>
                <th>Table ID</th>
                <th>Total Amount</th>
                <th>Bill Status</th>
                <th>Bill Time</th>
                <th>Action</th>
            </tr>
            <%
                List<Bill> billList = (List<Bill>) request.getAttribute("billList");
                if (billList != null) {
                    for (Bill bill : billList) {
            %>
            <tr>
                <td><%= bill.getBillId() %></td>
                <td><%= bill.getTableId() %></td>
                <td>₹<%= bill.getTotalAmount() %></td>
                <td><%= bill.getBillStatus() %></td>
                <td><%= bill.getBillTime() %></td>
                <td>
                    <form action="payment.jsp" method="get">
                        <input type="hidden" name="billId" value="<%= bill.getBillId() %>">
                        <input type="submit" value="Process Payment">
                    </form>
                </td>
            </tr>
            <%
                    }
                }
            %>
        </table>
    </div>
</body>
</html>
