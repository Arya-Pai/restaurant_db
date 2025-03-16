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
<form method="post" action="AddTableServlet">
    <label>Enter Total Tables:</label>
    <input type="number" name="totalTables" required min="1">
    <button type="submit">Add Tables</button>
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