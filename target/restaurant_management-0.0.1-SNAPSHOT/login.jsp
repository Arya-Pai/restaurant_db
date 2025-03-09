<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Login Page</title>
</head>
<body>
	<form action="LoginServlet" method="post">
		<label for="emp_id">Employee ID:</label>
        <input type="text" id="emp_id" name="emp_id"required placeholder="Enter your id">
        <label for="password">Password:</label>
        <input type="password" name="emp_password" id="emp_password" maxlength="6" pattern="[0-9]{6}" required placeholder="Enter your 6 digit numeric-code">
        <input type="submit" value="Login">
	</form>
	<%	String errorMessage=(String)session.getAttribute("errorMessage");
		if(errorMessage!=null){
	%>
<script>
    alert("<%= errorMessage %>");
</script>

	<%	session.removeAttribute("errorMessage");
		} 
	%>
</body>
</html>