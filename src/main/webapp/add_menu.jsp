<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="com.restaurantdb.model.Menu" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Add Menu Item</title>

<%
   
    String successMessage = (String) session.getAttribute("successMessage");
    String errorMessage = (String) session.getAttribute("errorMessage");
    String newRoleMessage = (String) session.getAttribute("newCategoryMessage");
    Menu pendingMenu = (Menu) session.getAttribute("pendingItem"); // Fix this line

    if (successMessage != null) { %>
    <script>
    alert("<%= successMessage %>");
	</script>
<%  
    session.removeAttribute("successMessage");
    }

    if (errorMessage != null) { %>
    <script>
    alert("<%= errorMessage %>");
	</script>
<%  
    session.removeAttribute("errorMessage");
    }
%>
</head>
<body>
	<h2>Add Menu Item</h2>
<form action="AddMenuServlet" method="post">
   Item Name: <input type="text" name="item_name" required><br>
   Category Name: <input type="text" name="category_name" required><br>
   Price: <input type="number" name="price" required><br>

   <label for="type">Select Type:</label>
   <select id="type" name="type" required>
       <option value="" disabled selected>Choose a type</option>
       <option value="veg">Vegetarian</option>
       <option value="nonveg">Non-Vegetarian</option>
       <option value="vegan">Vegan</option>
   </select>
   
   <button type="submit">Add</button>
</form>

<% if (newRoleMessage != null && pendingMenu != null) { %>
    <div id="roleConfirmModal" class="modal">
        <div class="modal-content">
            <p><%= newRoleMessage %></p>
            <form action="AddMenuServlet" method="post">
                <input type="hidden" name="item_name" value="<%= pendingMenu.getItem_name() %>">
                <input type="hidden" name="category_name" value="<%= pendingMenu.getCategoryName() %>">
                <input type="hidden" name="price" value="<%= pendingMenu.getPrice() %>">
                <input type="hidden" name="type" value="<%= pendingMenu.getType() %>">
                <input type="hidden" name="confirmCreateCategory" value="yes">
                <button type="submit">Yes, Add Menu Item</button>
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
<% } %>

</body>
</html>

