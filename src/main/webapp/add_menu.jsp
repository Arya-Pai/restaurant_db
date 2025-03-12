<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page import="com.restaurantdb.model.Menu" %>
    

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<%
    HttpSession sessionObj = request.getSession();
    String successMessage = (String) sessionObj.getAttribute("successMessage");
    String errorMessage = (String) sessionObj.getAttribute("errorMessage");
    String newRoleMessage = (String) sessionObj.getAttribute("newCategoryMessage");
    Menu pendingItem = (Menu) sessionObj.getAttribute("pendingItem");

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

<% if (newRoleMessage != null) { %>
    <div id="roleConfirmModal" class="modal">
        <div class="modal-content">
            <p><%= newRoleMessage %></p>
            <form action="AddMenuServlet" method="post">
                <input type="hidden" name="item_name" value="<%= pendingItem.getItem_name() %>">
                <input type="hidden" name="category_name" value="<%= pendingItem.getCategoryName() %>">
                <input type="hidden" name="price" value="<%=pendingItem.getPrice() %>">
                 <input type="hidden" name="type" value="<%=pendingItem.getType()%>">
                <input type="hidden" name="confirmCreateCategory" value="yes">
                <button type="submit">Yes, Create Category and Add Item</button>
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
    <% sessionObj.removeAttribute("newCategoryMessage"); 
   sessionObj.removeAttribute("pendingItem");
} %>
</body>
</html>