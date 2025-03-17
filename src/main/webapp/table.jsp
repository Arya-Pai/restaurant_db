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

    List<Table> tables = (List<Table>) userSession.getAttribute("tables");
    String error = (String) userSession.getAttribute("errorMessage");
    String customerNotFound = (String) userSession.getAttribute("customerNotFound");
    String phoneNumber = (String) userSession.getAttribute("phone");
    String tableId = (String) userSession.getAttribute("table_id");
%>

<!DOCTYPE html>
<html>
<head>
    <title>Available Tables</title>
    <style>
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { padding: 10px; border: 1px solid black; text-align: center; }
        th { background-color: #f2f2f2; }
        .popup { display: none; position: fixed; top: 50%; left: 50%; transform: translate(-50%, -50%);
                 padding: 20px; background: white; border: 1px solid black; z-index: 10; }
        .hidden { display: none; }
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
    <h2>Available Tables</h2>

    <% if (error != null) { %>
        <p style="color: red;"><%= error %></p>
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
        <% if (tables != null && !tables.isEmpty()) { %>
            <% for (Table table : tables) { %>
                <tr>
                    <td><%= table.getTableNumber() %></td>
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
            <input type="hidden" name="table_id" id="table_id">
            <input type="text" name="phone" id="phone_number" placeholder="Enter Phone Number" required>
            <button type="submit">Check</button>
            <button type="button" onclick="closePopup()">Cancel</button>
        </form>
    </div>

    <% if (phoneNumber != null && customerNotFound != null) { %>
        <h3>New Customer</h3>
        <form action="AssignTableServlet" method="post">
            <input type="hidden" name="table_id" value="<%= tableId %>">
            <input type="hidden" name="phone" value="<%= phoneNumber %>">
            <label>Enter Customer Name:</label>
            <input type="text" name="name" required>
            <button type="submit">Assign Table</button>
        </form>
    <% } %>
</body>
</html>




