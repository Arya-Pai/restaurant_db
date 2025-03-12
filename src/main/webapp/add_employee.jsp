<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%@ page import="com.restaurantdb.model.Employee" %>

<%
    HttpSession sessionObj = request.getSession();
    String successMessage = (String) sessionObj.getAttribute("successMessage");
    String errorMessage = (String) sessionObj.getAttribute("errorMessage");
    String newRoleMessage = (String) sessionObj.getAttribute("newRoleMessage");
    Employee pendingEmployee = (Employee) sessionObj.getAttribute("pendingEmployee");

    if (successMessage != null) { %>
    <script>
    alert("<%= successMessage %>");
	</script>

<%  sessionObj.removeAttribute("successMessage");
    }

    if (errorMessage != null) { %>
    <script>
    alert("<%= errorMessage %>");
	</script>

<%  sessionObj.removeAttribute("errorMessage");
    }
%>

<h2>Add Employee</h2>
<form action="AddEmployeeServlet" method="post">
    Name: <input type="text" name="name" required><br>
    Phone: <input type="tel" name="phone" required><br>
    Password: <input type="password" name="password" required><br>
    Role: <input type="text" name="role_name" required><br>
    <button type="submit">Add Employee</button>
</form>

<% if (newRoleMessage != null) { %>
    <div id="roleConfirmModal" class="modal">
        <div class="modal-content">
            <p><%= newRoleMessage %></p>
            <form action="AddEmployeeServlet" method="post">
                <input type="hidden" name="name" value="<%= pendingEmployee.getEmp_name() %>">
                <input type="hidden" name="phone" value="<%= pendingEmployee.getPhone() %>">
                <input type="hidden" name="password" value="<%= pendingEmployee.getPassword() %>">
                <input type="hidden" name="role_name" value="<%= pendingEmployee.getRoleName() %>">
                <input type="hidden" name="confirmCreateRole" value="yes">
                <button type="submit">Yes, Create Role and Add Employee</button>
            </form>
            <button onclick="closeModal()">No, Cancel</button>
        </div>
    </div>
    <script>
        document.getElementById("roleConfirmModal").style.display = "block";
        function closeModal() {
            document.getElementById("roleConfirmModal").style.display = "none";
        }
    </script>
<% sessionObj.removeAttribute("newRoleMessage"); 
   sessionObj.removeAttribute("pendingEmployee");
} %>

