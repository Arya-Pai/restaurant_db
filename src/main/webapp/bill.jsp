<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Bill List</title>
</head>
<body>
    <h2>Bill List</h2>
    <table border="1">
        <tr>
            <th>Bill ID</th>
            <th>Table ID</th>
            <th>Total Amount</th>
            <th>Bill Status</th>
            <th>Bill Time</th>
            <th>Action</th>
        </tr>
        <%
            List<Bill> billList = (List<Bill>) request.getAttribute("billList");
            if (billList != null) {
                for (Bill bill : billList) {
        %>
        <tr>
            <td><%= bill.getBillId() %></td>
            <td><%= bill.getTableId() %></td>
            <td><%= bill.getTotalAmount() %></td>
            <td><%= bill.getBillStatus() %></td>
            <td><%= bill.getBillTime() %></td>
            <td>
                <form action="payment.jsp" method="get">
                    <input type="hidden" name="billId" value="<%= bill.getBillId() %>">
                    <input type="submit" value="Process Payment">
                </form>
            </td>
        </tr>
        <%
                }
            }
        %>
    </table>
</body>
</html>
