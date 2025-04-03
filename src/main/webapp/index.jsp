<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.*" %>
<%
    // Get employee name and role from session
    String empname = (String) session.getAttribute("emp_name");
    String role = (String) session.getAttribute("role_name");
    System.out.println(role);
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
    <title>Dashboard</title>
</head>
<body>
<%
    if (successMessage != null) { %>
    <script>
    alert("<%= successMessage %>");
	</script>

<%  session.removeAttribute("successMessage");
    }

    if (errorMessage != null) { %>
    <script>
    alert("<%= errorMessage %>");
	</script>

<%  session.removeAttribute("errorMessage");
    }
%>
<% if ("Waiter".equals(role)) { %>
    <h1>Waiter Dashboard</h1>
    <h3>Welcome, <%= empname %></h3>
    <ul>
        <li><a href="table.jsp">Take Order</a></li>
        <li><a href="editOrder.jsp">View and Edit Orders</a></li>
        <li><a href="menu.jsp">Menu</a></li>
        <li><a href="logout.jsp">Logout</a></li>  
    </ul>
<% } else if ("admin".equals(role)) { %>
    <h1>Admin Dashboard</h1>
    <h3>Welcome, <%= empname %></h3>
    <nav id="navbar">
        <div class="nav-items"><a href="total_sales.jsp">Total Sales</a></div>
        <div class="nav-items"><a href="add_employee.jsp">Add Employee</a></div>
        <div class="nav-items"><a href="add_menu.jsp">Add Menu Item</a></div>
        <div class="nav-items"><a href="add_table.jsp">Add Table</a></div>
        
        <div class="nav-items"><a href="logout.jsp">Logout</a></div> 
    </nav>
<% } else if ("Manager".equals(role)) { %>
    <h1>Manager Dashboard</h1>
    <h3>Welcome, <%= empname %></h3>
    <nav id="navbar">
        <div class="nav-items"><a href="total_sales.jsp">Total Sales</a></div>
        <li><a href="table.jsp">Take Order</a></li>
    
        <li><a href="menu.jsp">Menu</a></li>
        
            <li><a href="editOrder.jsp">View and Edit Orders</a></li>
        <li><a href="logout.jsp">Logout</a></li>
                    <li><a href="editOrder.jsp">View and Edit Orders</a></li>
    </nav>
    <% } else if ("Cashier".equals(role)) { %>
    <h1>Cashier Dashboard</h1>
    <h3>Welcome, <%= empname %></h3>
    <nav id="navbar">
        <div class="nav-items"><a href="todaySales.jsp">Todays' Sales</a></div>
        <div class="nav-items"><a href="payment.jsp">Make Payment</a></div>
        
        
    </nav>
<% } else { %>
    <h1>Unauthorized Access</h1>
    <p>You do not have permission to view this page.</p>
    <a href="login.jsp">Go to Login</a>
<% } %>

</body>
</html>
