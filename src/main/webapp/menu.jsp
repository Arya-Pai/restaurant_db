<%@ page import="java.util.List" %>
<%@ page import="com.restaurantdb.model.Category, com.restaurantdb.model.Menu" %>
<%@ page import="com.restaurantdb.dao.CategoryDAO, com.restaurantdb.dao.MenuItems" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<html>
<head>
    <title>Menu</title>
</head>
<body>

<h2>Categories</h2>
<form method="get" action="menu.jsp">
    <%
        List<Category> categories = CategoryDAO.getAllCategories();
        for (Category category : categories) {
    %>
        <button type="submit" name="categoryId" value="<%= category.getCategoryId() %>">
            <%= category.getCategoryName() %> (<%= category.getType() %>)
        </button>
    <%
        }
    %>
</form>

<h2>Menu Items</h2>
<form action="OrderServlet" method="post">
    <div id="menu-container">
        <%
            String categoryIdParam = request.getParameter("categoryId");
            if (categoryIdParam != null) {
                int categoryId = Integer.parseInt(categoryIdParam);
                List<Menu> menuItems = MenuItems.getMenuItemsByCategory(categoryId);

                if (!menuItems.isEmpty()) {
                    for (Menu item : menuItems) {
                    	System.out.println(item.getItem_name()+" "+item.getPrice()+" "+item.getType()+" "+ item.getItem_Id());
        %>
                        <div>
                            <span><%= item.getItem_name() %> - ₹<%= item.getPrice() %> (<%= item.getType() %>)</span>
                            <input type="hidden" name="itemId" value="<%= item.getItem_Id() %>">
                            <input type="hidden" name="price" value="<%= item.getPrice() %>">
                            <input type="number" name="quantity" value="1" min="1">
                            <button type="submit">Add</button>
                        </div>
        <%
                    }
                } else {
        %>
                    <p>No items available in this category.</p>
        <%
                }
            } else {
        %>
                <p>Please select a category to see items.</p>
        <%
            }
        %>
    </div>
</form>

</body>
</html>
