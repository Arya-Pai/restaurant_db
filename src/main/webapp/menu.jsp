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
    String empname = (String) session.getAttribute("emp_name");
    String role = (String) session.getAttribute("role_name");
    Integer employeeId = (Integer) session.getAttribute("emp_id");
    String successMessage = (String) session.getAttribute("successMessage");
    String errorMessage = (String) session.getAttribute("errorMessage");

    if (empname == null || role == null) {
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
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f0f2f5;
            margin: 0;
            padding: 0;
        }

        .navbar {
            background-color: #333;
            padding: 15px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            color: #fff;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
        }

        .navbar h1 {
            margin: 0;
            font-size: 24px;
            font-weight: bold;
        }

        .navbar .nav-items {
            display: flex;
            gap: 15px;
        }

        .nav-items a {
            padding: 10px 20px;
            background-color: #007bff;
            color: #fff;
            text-decoration: none;
            border-radius: 5px;
            transition: background-color 0.3s ease, transform 0.3s ease;
        }

        .nav-items a:hover {
            background-color: #0056b3;
            transform: scale(1.05);
        }

        .container {
            padding: 40px;
            max-width: 1000px;
            margin: 40px auto;
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        h2 {
            text-align: center;
            color: #333;
            margin-bottom: 40px;
            font-size: 28px;
            font-weight: bold;
            text-transform: uppercase;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
        
        th, td {
            padding: 15px;
            border-bottom: 1px solid #ddd;
            text-align: center;
            font-size: 16px;
        }
        
        th {
            background-color: #007bff;
            color: #fff;
            text-transform: uppercase;
            font-weight: bold;
        }

        tr:nth-child(even) {
            background-color: #f9f9f9;
        }

        button, input[type="submit"], input[type="button"] {
            padding: 10px 20px;
            cursor: pointer;
            background-color: #28a745;
            color: #fff;
            border: none;
            border-radius: 5px;
            transition: background-color 0.3s ease, transform 0.3s ease;
        }

        button:hover, input[type="submit"]:hover, input[type="button"]:hover {
            background-color: #218838;
            transform: scale(1.05);
        }

        input[type="text"], input[type="number"] {
            padding: 15px;
            border: 1px solid #ddd;
            border-radius: 5px;
            width: calc(100% - 30px);
            margin-bottom: 20px;
            box-sizing: border-box;
        }

        .btn-success {
            background-color: #007bff;
        }

        .btn-success:hover {
            background-color: #0056b3;
        }
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
<div class="navbar">
    <h1><%= role %> Dashboard</h1>
    <div class="nav-items">
        <% if ("Waiter".equals(role)) { %>
            <a href="table.jsp">Take Order</a>
            <a href="editOrder.jsp">View and Edit Orders</a>
            <a href="menu.jsp">Menu</a>
            <a href="LogoutServlet">Logout</a>
        <% } else if ("admin".equals(role)) { %>
            <a href="total_sales.jsp">Total Sales</a>
            <a href="add_employee.jsp">Add Employee</a>
            <a href="add_menu.jsp">Add Menu Item</a>
            <a href="add_table.jsp">Add Table</a>
           <a href="LogoutServlet">Logout</a>
        <% } else if ("Manager".equals(role)) { %>
            <a href="total_sales.jsp">Total Sales</a>
            <a href="table.jsp">Take Order</a>
            <a href="menu.jsp">Menu</a>
            <a href="editOrder.jsp">View and Edit Orders</a>
            <a href="LogoutServlet">Logout</a>
        <% } else if ("Cashier".equals(role)) { %>
            <a href="todaySales.jsp">Today's Sales</a>
            <a href="payment.jsp">Make Payment</a>
           <a href="LogoutServlet">Logout</a>
        <% } %>
    </div>
</div>

<div class="container">
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

