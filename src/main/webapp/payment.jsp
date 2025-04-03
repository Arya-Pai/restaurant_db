<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.restaurantdb.model.Bill" %>
<%@ page import="com.restaurantdb.dao.BillDAO" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Pending Payments</title>
    <link href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <h2>Pending Payments</h2>
        <%
            String billIdParam = request.getParameter("billId");
            Integer billId = billIdParam != null ? Integer.parseInt(billIdParam) : null;
            Bill selectedBill = null;
            if (billId != null) {
                try {
                    BillDAO billDAO = new BillDAO();
                    selectedBill = billDAO.getBill(billId);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
            if (billId == null) {
        %>
        <table class="table table-bordered">
            <thead>
                <tr>
                    <th>Bill ID</th>
                    <th>Table ID</th>
                    <th>Total Amount</th>
                    <th>Status</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <%
                    try {
                        BillDAO billDAO = new BillDAO();
                        List<Bill> pendingBills = billDAO.getPendingBills();
                        if (pendingBills != null && !pendingBills.isEmpty()) {
                            for (Bill bill : pendingBills) {
                %>
                <tr>
                    <td><%= bill.getBillId() %></td>
                    <td><%= bill.getTableId() %></td>
                    <td><%= bill.getTotalAmount() %></td>
                    <td><%= bill.getBillStatus() %></td>
                    <td>
                        <form action="payment.jsp" method="get">
                            <input type="hidden" name="billId" value="<%= bill.getBillId() %>">
                            <input type="submit" value="Process Payment" class="btn btn-primary">
                        </form>
                    </td>
                </tr>
                <%
                            }
                        } else {
                %>
                <tr>
                    <td colspan="5" class="text-center">No pending payments.</td>
                </tr>
                <%
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                %>
            </tbody>
        </table>
        <% } else { %>
        <h2>Process Payment for Bill ID: <%= billId %></h2>
        <form action="PaymentServlet" method="post">
            <input type="hidden" name="billId" value="<%= billId %>">
            <label for="amount">Amount:</label>
            <input type="text" id="amount" name="amount" value="<%= selectedBill != null ? selectedBill.getTotalAmount() : "" %>" readonly><br>
            <label for="paymentMode">Payment Mode:</label>
            <select id="paymentMode" name="paymentMode" required>
                <option value="Cash">Cash</option>
                <option value="Card">Card</option>
                <option value="UPI">UPI</option>
            </select><br>
            <label for="paymentStatus">Payment Status:</label>
            <select id="paymentStatus" name="paymentStatus" required>
                <option value="Completed">Completed</option>
                <option value="Failed">Failed</option>
                <option value="Refunded">Refunded</option>
            </select><br>
            <input type="submit" value="Process Payment">
        </form>
        <% } %>
    </div>
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.4/dist/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>