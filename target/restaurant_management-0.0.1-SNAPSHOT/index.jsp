<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@page import= "java.util.*" %>
    <%	String empname=(String)session.getAttribute("emp_name");
    	if(empname==null) response.sendRedirect("login.jsp");
    %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Dashboard</title>
</head>
<body>
	<%	String role=(String)session.getAttribute("role_name");
		if("Waiter".equals(role)){
	%>
	<h1>Waiter Dashboard</h1>
	<h3><%= empname %></h3>
	<ul>
		<li><a href="take_order.jsp">Take Order</a></li>
		<li><a href="view_orders.jsp">View Orders</a></li>
		<li><a href="menu.jsp">Menu</a></li>
	</ul>
	<% } %>
	
	<%if ("Admin".equals(role)){%>
	<h1>Admin Dashboard</h1>
	<h3><%=empname %></h3>
	<nav id="navbar">
		<div class="nav-items">Total Sales</div>
		<div class="nav-items">Add Employee</div>
		<div class="nav-items">Add Menu Item</div>
		<div class="nav-items"></div>
	</nav>
	<%} %>
	
	
</body>
</html>