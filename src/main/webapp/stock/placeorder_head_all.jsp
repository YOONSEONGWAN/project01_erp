<%@page import="java.util.List"%>
<%@page import="dto.stock.PlaceOrderHeadDto"%>
<%@page import="dao.stock.PlaceOrderHeadDao"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    List<PlaceOrderHeadDto> list = PlaceOrderHeadDao.getInstance().getAllOrders();
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>전체 발주 내역</title>
</head>
<body>
    <h2>전체 발주 내역</h2>
    <table border="1" cellpadding="5" cellspacing="0">
        <tr>
            <th>Order ID</th>
            <th>발주일</th>
            <th>담당자</th>
        </tr>
        <%
            for (PlaceOrderHeadDto dto : list) {
        %>
        <tr>
            <td><a href="placeorder_head_detail.jsp?order_id=<%= dto.getOrder_id() %>">
                <%= dto.getOrder_id() %>
            </a></td>
            <td><%= dto.getDate() %></td>
            <td><%= dto.getManager() %></td>
        </tr>
        <% } %>
    </table>
    <br>
    <a href="placeorder_head.jsp">돌아가기</a>
</body>
</html>