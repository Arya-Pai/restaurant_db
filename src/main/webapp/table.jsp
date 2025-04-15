<%@ page import="java.util.List" %>
<%@ page import="com.restaurantdb.dao.TableDAO" %>
<%@ page import="com.restaurantdb.model.Table" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>

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

    List<Table> tables = (List<Table>) userSession.getAttribute("tables");
    String error = (String) userSession.getAttribute("errorMessage");
    String customerNotFound = (String) userSession.getAttribute("customerNotFound");
    String phoneNumber = (String) userSession.getAttribute("phone");
    Integer tableId = (Integer) userSession.getAttribute("table_id");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Available Tables</title>
     <link rel="stylesheet" href="css/navbar.css">
    <style>
        

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

        input[type="text"] {
            width: 100%;
            padding: 15px;
            border: 1px solid #ddd;
            border-radius: 5px;
            box-sizing: border-box;
            font-size: 16px;
        }

        .popup { 
            display: none; 
            position: fixed; 
            top: 50%; 
            left: 50%; 
            transform: translate(-50%, -50%);
            padding: 20px; 
            background: white; 
            border: 1px solid #ddd;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            z-index: 10; 
        }

        .alert {
            color: red;
            margin-bottom: 20px;
        }
    </style>
    <script>
        function openPopup(tableId) {
            document.getElementById("popup").style.display = "block";
            document.getElementById("table_id").value = tableId;
        }

        function closePopup() {
            document.getElementById("popup").style.display = "none";
        }
    </script>
</head>
<body>
    <div class="navbar">
        <h1><a href="index.jsp"><%= role %> Dashboard</a></h1>
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
        <h2>Available Tables</h2>

        <% if (error != null) { %>
            <p class="alert"><%= error %></p>
        <% } %>

        <form action="table" method="GET">
            <button type="submit">Load Available Tables</button>
        </form>

        <table>
            <tr>
                <th>Table Number</th>
                <th>Capacity</th>
                <th>Status</th>
                <th>Assign</th>
            </tr>
            <% if (tables != null && !tables.isEmpty()) {  %>
                <% for (Table table : tables) {System.out.println(table.getTableId()); %>
                    <tr>
                        <td><%= table.getTableNumber()%9+1 %></td>
                        <td><%= table.getCapacity() %></td>
                        <td><%= table.getStatus() %></td>
                        <td>
                            <button type="button" onclick="openPopup('<%= table.getTableNumber() %>')">Assign</button>
                        </td>
                    </tr>
                <% } %>
            <% } else { %>
                <tr>
                    <td colspan="4">No Available Tables</td>
                </tr>
            <% } %>
        </table>

        <div id="popup" class="popup">
            <h3>Enter Customer Phone Number</h3>
            <form action="CheckCustomerServlet" method="post">
                <input type="hidden" name="table_number" id="table_id">
                <input type="text" name="phone" id="phone_number" placeholder="Enter Phone Number" required>
                <input type="submit" value="Check">
                <input type="button" value="Cancel" onclick="closePopup()">
            </form>
        </div>

        <% if (phoneNumber != null && customerNotFound != null) { 
        	
        System.out.println("table "+tableId);%>
            <h3>New Customer</h3>
            <form action="AssignTableServlet" method="post">
                <input type="hidden" name="table_id" value="<%= tableId %>">
                <input type="hidden" name="phone" value="<%= phoneNumber %>">
                <label>Enter Customer Name:</label>
                <input type="text" name="name" required>
                <input type="submit" value="Assign Table" class="btn btn-primary">
            </form>
        <% } %>
    </div>
</body>
</html>




