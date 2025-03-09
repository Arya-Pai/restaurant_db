<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<form action="AddEmployeeServlet" method="post">
		<label for="name">Employee Name:</label>
		<input type="text" name="name">
		<label for="phone">Phone:</label>
		<input type="text" name="phone">
		<label for="role_name">Employee Role:</label>
		<input type="text" name="role_name">
		<label for="password">Password:</label>
		<input type="password" name="password">
		<input type="submit" value="Submit">
		
	</form>
</body>
</html>