<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
%>
<meta charset="UTF-8">
<title>Add Table</title>

</head>
<body>
<form method="post" action="AddTableServlet">
	<label>Enter Total Tables Capacity:</label>
    <input type="number" name="table_capacity" required min="2">
    <label>Enter Total Tables with given Capacity:</label>
    <input type="number" name="totalTables" required min="1">
    <button type="submit">Add Tables</button>
</form>
</body>
</html>