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

    List<Table> tables = (List<Table>) request.getAttribute("tables");
%>

<!DOCTYPE html>
<html>
<head>
    <title>Available Tables</title>
    <style>
        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 10px; border: 1px solid black; text-align: center; }
        th { background-color: #f2f2f2; }
        .popup { display: none; position: fixed; top: 50%; left: 50%; transform: translate(-50%, -50%);
                 padding: 20px; background: white; border: 1px solid black; z-index: 10; }
        .hidden { display: none; }
    </style>
    <script>
    <button onclick="location.href='table'">Load Available Tables</button>

        function openPopup(tableId) {
            document.getElementById("popup").style.display = "block";
            document.getElementById("table_id").value = tableId;
        }

        function closePopup() {
            document.getElementById("popup").style.display = "none";
        }

        function checkCustomer() {
            let phone = document.getElementById("phone_number").value;
            let tableId = document.getElementById("table_id").value;

            fetch("CheckCustomerServlet", {
                method: "POST",
                headers: { "Content-Type": "application/x-www-form-urlencoded" },
                body: "phone_number=" + phone + "&table_id=" + tableId
            })
            .then(response => response.json())
            .then(data => {
                if (data.exists) {
                    window.location.href = "order.jsp";
                } else {
                    closePopup();
                    document.getElementById("phone-" + tableId).value = phone;
                    document.getElementById("customer-form-" + tableId).classList.remove("hidden");
                }
            });
        }
    </script>
</head>
<body>
    <h2>Available Tables</h2>
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
            <td><button onclick="openPopup('<%= table.getTableNumber() %>')">Assign</button></td>
        </tr>
        <tr id="customer-form-<%= table.getTableNumber() %>" class="hidden">
            <td colspan="4">
                <form action="AssignCustomerServlet" method="post">
                    <input type="hidden" name="table_id" value="<%= table.getTableNumber() %>">
                    <input type="text" name="customer_phone" id="phone-<%= table.getTableNumber() %>" placeholder="Enter Customer Phone">
                    <button type="submit">Assign Customer</button>
                </form>
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
        <form id="phoneForm">
            <input type="hidden" name="table_id" id="table_id">
            <input type="text" name="phone_number" id="phone_number" placeholder="Enter Phone Number" required>
            <button type="button" onclick="checkCustomer()">Check</button>
            <button type="button" onclick="closePopup()">Cancel</button>
        </form>
    </div>
</body>
</html>


