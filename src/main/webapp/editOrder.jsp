<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%@ page import="java.util.List" %>
<%@ page import="com.restaurantdb.model.Order" %>
<%@ page import="com.restaurantdb.model.OrderItem" %>
<%@ page import="com.restaurantdb.model.Table" %>
<%@ page import="com.restaurantdb.model.Menu" %>
<%@ page import="com.restaurantdb.dao.OrderDAO" %>
<%@ page import="com.restaurantdb.dao.OrderItemsDAO" %>
<%@ page import="com.restaurantdb.dao.TableDAO" %>
<%@ page import="com.restaurantdb.dao.MenuItems" %>

<%

String empname = (String) session.getAttribute("emp_name");
String role = (String) session.getAttribute("role_name");
Integer employeeId = (Integer) session.getAttribute("emp_id");
String successMessage = (String) session.getAttribute("successMessage");
String errorMessage = (String) session.getAttribute("errorMessage");

if (empname == null || role == null) {
    response.sendRedirect("login.jsp");
    return;
}
    String tableIdParam = request.getParameter("tableId");
    String orderIdParam = request.getParameter("orderId");
    Integer tableId = tableIdParam != null ? Integer.parseInt(tableIdParam) : null;
    Integer selectedOrderId = orderIdParam != null ? Integer.parseInt(orderIdParam) : null;
    List<Table> assignedTables = null;
    List<Order> ongoingOrders = null;
    List<OrderItem> orderList = null;
    List<Menu> menuItems = null;

    try {
        TableDAO tableDAO = new TableDAO();
        OrderDAO orderDAO = new OrderDAO();
        OrderItemsDAO orderItemsDAO = new OrderItemsDAO();
        MenuItems menuDAO = new MenuItems();
        assignedTables = tableDAO.getTablesByEmployeeId(employeeId);
        menuItems = menuDAO.getMenuItemsByCategory(1); // Fetch menu items for a specific category

        if (tableId != null) {
            ongoingOrders = orderDAO.getOngoingOrdersByTableId(tableId);

            if (selectedOrderId != null) {
                orderList = orderItemsDAO.getAllOrderItems(selectedOrderId);
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Order</title>
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

        ul.list-group {
            list-style: none;
            padding: 0;
            margin: 0;
        }

        ul.list-group li {
            padding: 15px;
            background-color: #fff;
            border: 1px solid #ddd;
            margin-bottom: 10px;
            border-radius: 5px;
            transition: background-color 0.3s ease, transform 0.3s ease;
        }

        ul.list-group li:hover {
            background-color: #f1f1f1;
            transform: scale(1.02);
        }

        .list-group-item a {
            text-decoration: none;
            color: #007bff;
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

        button, input[type="submit"] {
            padding: 10px 20px;
            cursor: pointer;
            background-color: #28a745;
            color: #fff;
            border: none;
            border-radius: 5px;
            transition: background-color 0.3s ease, transform 0.3s ease;
        }

        button:hover, input[type="submit"]:hover {
            background-color: #218838;
            transform: scale(1.05);
        }

        .form-group {
            margin-bottom: 20px;
            display: flex;
            flex-direction: column;
            align-items: flex-start;
        }

        label {
            margin-bottom: 5px;
            color: #333;
            font-weight: bold;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        input[type="number"], select {
            width: 100%;
            padding: 15px;
            border: 1px solid #ddd;
            border-radius: 5px;
            box-sizing: border-box;
            font-size: 16px;
        }

        .btn-success {
            background-color: #007bff;
        }

        .btn-success:hover {
            background-color: #0056b3;
        }
    </style>
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

    <div class="container mt-5">
        <h2>Tables Assigned to Employee</h2>
        <ul class="list-group">
            <% if (assignedTables != null) {
                for (Table table : assignedTables) { %>
                <li class="list-group-item">
                    <a href="editOrder.jsp?tableId=<%= table.getTableId() %>">Table ID: <%= table.getTableId() %></a>
                </li>
            <% }
            } %>
        </ul>

        <% if (tableId != null) { %>
        <h2>Ongoing Orders for Table <%= tableId %></h2>
        <form action="editOrder.jsp" method="get">
            <input type="hidden" name="tableId" value="<%= tableId %>">
            <div class="form-group">
                <label for="orderSelect">Select Order:</label>
                <select name="orderId" id="orderSelect" class="form-control" onchange="this.form.submit()">
                    <option value="">-- Select an Order --</option>
                    <% if (ongoingOrders != null) {
                        for (Order order : ongoingOrders) { %>
                        <option value="<%= order.getOrderId() %>"
                                <%= (selectedOrderId != null && order.getOrderId() == selectedOrderId) ? "selected" : "" %>>
                            Order ID: <%= order.getOrderId() %>, Bill ID: <%= order.getBillId() %>, Employee ID: <%= order.getEmployeeId() %>
                        </option>
                    <% }
                    } %>
                </select>
            </div>
        </form>

        <% if (selectedOrderId != null) { %>
        <h2>Edit Order ID: <%= selectedOrderId %></h2>
        <form action="editOrderServlet" method="post">
            <input type="hidden" name="order_id" value="<%= selectedOrderId %>">
            <input type="hidden" name="table_id" value="<%= tableId %>">
            <table class="table table-bordered">
                <thead>
                    <tr>
                        <th>Item Name</th>
                        <th>Price</th>
                        <th>Quantity</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (orderList != null && !orderList.isEmpty()) {
                        for (OrderItem item : orderList) { %>
                        <tr>
                            <td><%= item.getItemName() %></td>
                            <td>₹<%= item.getPrice() %></td>
                            <td>
                                <input type="number" name="quantities" value="<%= item.getQuantity() %>" min="1" class="form-control">
                                <input type="hidden" name="item_ids" value="<%= item.getItemId() %>">
                                <input type="hidden" name="prices" value="<%= item.getPrice() %>">
                            </td>
                            <td>
                                <button type="submit" name="action" value="remove_<%= item.getItemId() %>" class="btn btn-danger">Remove</button>
                            </td>
                        </tr>
                    <% }
                    } else { %>
                        <tr>
                            <td colspan="4" class="text-center">No items in the order.</td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
            <button type="submit" name="action" value="update" class="btn btn-primary">Update Order</button>
        </form>
        <hr>
        <h3>Add New Item</h3>
        <form action="editOrderServlet" method="post" class="form-inline">
            <input type="hidden" name="order_id" value="<%= selectedOrderId %>">
            <input type="hidden" name="table_id" value="<%= tableId %>">
            <div class="form-group mb-2">
                <label for="menu_item" class="sr-only">Menu Item</label>
                <select name="item_id" class="form-control" required>
                    <option value="">-- Select Menu Item --</option>
                    <% if (menuItems != null) {
                        for (Menu menuItem : menuItems) { %>
                        <option value="<%= menuItem.getItem_Id() %>"><%= menuItem.getItem_name() %> - ₹<%= menuItem.getPrice() %></option>
                    <% }
                    } %>
                </select>
            </div>
            <div class="form-group mx-sm-3 mb-2">
                <label for="quantity" class="sr-only">Quantity</label>
                <input type="number" name="quantity" placeholder="Quantity" required class="form-control">
            </div>
            <button type="submit" name="action" value="add" class="btn btn-success mb-2">Add Item</button>
        
        <% } %>
        <% } %>
    </div>
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.4/dist/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>