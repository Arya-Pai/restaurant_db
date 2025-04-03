<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Today's Sales</title>
    <link rel="stylesheet" type="text/css" href="styles.css">
</head>
<body>
    <h1>Today's Sales</h1>
    <table border="1">
        <thead>
            <tr>
                <th>Order ID</th>
                <th>Table Number</th>
                <th>Customer Name</th>
                <th>Employee Name</th>
                <th>Payment ID</th>
                <th>Bill ID</th>
                <th>Payment Mode</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="sale" items="${sales}">
                <tr>
                    <td>${sale.orderId}</td>
                    <td>${sale.tableNumber}</td>
                    <td>${sale.customerName}</td>
                    <td>${sale.employeeName}</td>
                    <td>${sale.paymentId}</td>
                    <td>${sale.billId}</td>
                    <td>${sale.paymentMode}</td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</body>
</html>