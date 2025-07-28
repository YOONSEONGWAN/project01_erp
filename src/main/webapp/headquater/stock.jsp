<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>메인 페이지</title>
</head>
<body>
    <h1>재고 관리 시스템</h1>

    <ul>
        <li><a href="${pageContext.request.contextPath}/stock/stock.jsp">재고 페이지</a></li>
        <li><a href="${pageContext.request.contextPath}/stock/orderList.jsp">발주 페이지</a></li>
    </ul>
</body>
</html>