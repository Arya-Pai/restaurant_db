<%@ page import="java.util.List" %>
<%@ page import="com.restaurantdb.model.Category, com.restaurantdb.model.Menu, com.restaurantdb.model.OrderItem" %>
<%@ page import="com.restaurantdb.dao.CategoryDAO, com.restaurantdb.dao.MenuItems" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    HttpSession userSession = request.getSession(false);
    if (userSession == null || userSession.getAttribute("emp_id") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    List<OrderItem> orderList = (List<OrderItem>) session.getAttribute("orderList");
%>

<!DOCTYPE html>
<html>
<head>
    <title>Menu</title>
    <style>
        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 10px; border: 1px solid black; text-align: center; }
        th { background-color: #f2f2f2; }
        button { padding: 5px 10px; cursor: pointer; }
    </style>
    <script>
        function updateQuantity(itemId) {
            let qtyInput = document.getElementById("qty-" + itemId);
            let hiddenQty = document.getElementById("hidden-qty-" + itemId);
            hiddenQty.value = qtyInput.value;
        }
    </script>
</head>
<body>
    <h2>Categories</h2>
    <form method="get" action="menu.jsp">
        <% List<Category> categories = CategoryDAO.getAllCategories(); %>
        <% for (Category category : categories) { %>
            <button type="submit" name="categoryId" value="<%= category.getCategoryId() %>">
                <%= category.getCategoryName() %> (<%= category.getType() %>)
            </button>
        <% } %>
    </form>

    <h2>Menu Items</h2>
    <table>
        <tr>
            <th>Item Name</th>
            <th>Price</th>
            <th>Quantity</th>
            <th>Add</th>
        </tr>
        <%
            String categoryIdParam = request.getParameter("categoryId");
            if (categoryIdParam != null) {
                int categoryId = Integer.parseInt(categoryIdParam);
                List<Menu> menuItems = MenuItems.getMenuItemsByCategory(categoryId);
                if (!menuItems.isEmpty()) {
                    for (Menu item : menuItems) { %>
                        <tr>
                            <td><%= item.getItem_name() %></td>
                            <td>₹<%= item.getPrice() %></td>
                            <td><input type="number" id="qty-<%= item.getItem_Id() %>" value="1" min="1" oninput="updateQuantity(<%= item.getItem_Id() %>)"></td>
                            <td>
                                <form action="OrderItemsServlet" method="POST">
                                    <input type="hidden" name="action" value="add">
                                    <input type="hidden" name="item_id" value="<%= item.getItem_Id() %>">
                                    <input type="hidden" name="item_name" value="<%= item.getItem_name() %>">
                                    <input type="hidden" name="price" value="<%= item.getPrice() %>">
                                    <input type="hidden" id="hidden-qty-<%= item.getItem_Id() %>" name="quantity" value="1">
                                    <button type="submit">Add</button>
                                </form>
                            </td>
                        </tr>
        <%          }
                } else { %>
                    <tr><td colspan="4">No items available in this category.</td></tr>
        <%      }
            } else { %>
                <tr><td colspan="4">Please select a category to see items.</td></tr>
        <% } %>
    </table>

    <h2>Current Order</h2>
    <table>
        <tr>
            <th>Item Name</th>
            <th>Price</th>
            <th>Quantity</th>
            <th>Update</th>
            <th>Remove</th>
        </tr>
        <% if (orderList != null && !orderList.isEmpty()) { %>
            <% for (OrderItem item : orderList) { %>
                <tr>
                    <td><%= item.getItemName() %></td>
                    <td>₹<%= item.getPrice() %></td>
                    <td>
                        <form action="OrderItemsServlet" method="POST">
                            <input type="hidden" name="action" value="update">
                            <input type="hidden" name="item_id" value="<%= item.getItemId() %>">
                            <input type="number" name="quantity" value="<%= item.getQuantity() %>" min="1">
                            <button type="submit">Update</button>
                        </form>
                    </td>
                    <td>
                        <form action="OrderItemsServlet" method="POST">
                            <input type="hidden" name="action" value="remove">
                            <input type="hidden" name="item_id" value="<%= item.getItemId() %>">
                            <button type="submit">Remove</button>
                        </form>
                    </td>
                </tr>
            <% } %>
        <% } else { %>
            <tr>
                <td colspan="5">No items in the order.</td>
            </tr>
        <% } %>
    </table>

    <% if (orderList != null && !orderList.isEmpty()) { %>
        <form action="OrderServlet" method="POST">
            <input type="hidden" name="action" value="confirm">
            <button type="submit">Confirm Order</button>
        </form>
    <% } %>
</body>
</html>

