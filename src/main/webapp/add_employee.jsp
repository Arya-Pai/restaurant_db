<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.restaurantdb.model.Employee" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Add Employee</title>
<style>
    /* Styles for the modal */
    .modal {
        display: none; 
        position: fixed; 
        z-index: 1000; 
        left: 0;
        top: 0;
        width: 100%; 
        height: 100%; 
        background-color: rgba(0,0,0,0.5); 
    }

    .modal-content {
        background-color: white;
        margin: 15% auto; 
        padding: 20px;
        border: 1px solid #888;
        width: 30%;
        text-align: center;
        border-radius: 10px;
    }

    .modal button {
        margin: 10px;
        padding: 10px 20px;
        border: none;
        cursor: pointer;
    }

    .btn-yes {
        background-color: green;
        color: white;
    }

    .btn-no {
        background-color: red;
        color: white;
    }
</style>

<script>
    function openModal() {
        document.getElementById("roleModal").style.display = "block";
    }

    function closeModal() {
        document.getElementById("roleModal").style.display = "none";
    }

    function confirmCreateRole() {
        document.getElementById("confirmCreateRole").value = "yes";
        document.getElementById("employeeForm").submit();
    }
</script>
</head>
<body>

<h2>Add Employee</h2>

<%
    String successMessage = (String) session.getAttribute("successMessage");
    String errorMessage = (String) session.getAttribute("errorMessage");
    String newRoleMessage = (String) session.getAttribute("newRoleMessage");
    Employee pendingEmployee = (Employee) session.getAttribute("pendingEmployee");

    if (successMessage != null) {
%>
    <p style="color: green;"><%= successMessage %></p>
<%
        session.removeAttribute("successMessage");
    }
    if (errorMessage != null) {
%>
    <p style="color: red;"><%= errorMessage %></p>
<%
        session.removeAttribute("errorMessage");
    }
%>

<form method="post" action="AddEmployeeServlet" id="employeeForm">
    <label>Name:</label>
    <input type="text" name="emp_name" required><br>

    <label>Email:</label>
    <input type="email" name="emp_email" required><br>

    <label>Password:</label>
    <input type="password" name="emp_password" required><br>

    <label>Role:</label>
    <input type="text" name="role" required><br>

    <label>Active:</label>
    <input type="checkbox" name="is_active"><br>

    <input type="hidden" name="confirmCreateRole" id="confirmCreateRole" value="no">
    <button type="submit">Add Employee</button>
</form>

<!-- Modal for role confirmation -->
<div id="roleModal" class="modal">
    <div class="modal-content">
        <p id="roleMessage"></p>
        <button class="btn-yes" onclick="confirmCreateRole()">Yes, Create Role</button>
        <button class="btn-no" onclick="closeModal()">No, Cancel</button>
    </div>
</div>

<!-- Show modal if role does not exist -->
<%
    if (newRoleMessage != null && pendingEmployee != null) {
%>
    <script>
        document.getElementById("roleMessage").innerText = "<%= newRoleMessage %>";
        openModal();
    </script>
<%
        session.removeAttribute("newRoleMessage");
        session.removeAttribute("pendingEmployee");
    }
%>

</body>
</html>
