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

    Integer employeeId = (Integer) session.getAttribute("emp_id");
	if(employeeId==null){
		response.sendRedirect("login.jsp");
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
		System.out.println(tableIdParam+ " "+ selectedOrderId);
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
    <link href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
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
        <form action="OrderItemsServlet" method="post">
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
                            <td><%= item.getPrice() %></td>
                            <td>
                                <input type="number" name="quantities" value="<%= item.getQuantity() %>" min="1" class="form-control">
                                <input type="hidden" name="item_ids" value="<%= item.getItemId() %>">
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
        <form action="OrderItemsServlet" method="post" class="form-inline">
            <input type="hidden" name="order_id" value="<%= selectedOrderId %>">
            <input type="hidden" name="table_id" value="<%= tableId %>">
            <div class="form-group mb-2">
                <label for="menu_item" class="sr-only">Menu Item</label>
                <select name="item_id" class="form-control" required>
                    <option value="">-- Select Menu Item --</option>
                    <% if (menuItems != null) {
                        for (Menu item : menuItems) { %>
                        <option value="<%= item.getItem_Id() %>"><%= item.getItem_name() %> - <%= item.getPrice() %></option>
                    <% }
                    } %>
                </select>
            </div>
            <div class="form-group mx-sm-3 mb-2">
            	
                <label for="quantity" class="sr-only">Quantity</label>
                <input type="number" name="quantity" placeholder="Quantity" required class="form-control">
            </div>
            <button type="submit" name="action" value="add" class="btn btn-success mb-2">Add Item</button>
        </form>
        <% } %>
        <% } %>
    </div>
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.4/dist/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>