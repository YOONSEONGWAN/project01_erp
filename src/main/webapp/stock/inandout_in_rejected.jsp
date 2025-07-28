<%@page import="java.util.List"%>
<%@page import="dao.stock.InAndOutDao"%>
<%@page import="dto.stock.InAndOutDto"%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
    List<InAndOutDto> list = InAndOutDao.getInstance().selectAll();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>입고 반려 전체 목록</title>
</head>
<body>
<h2>입고 반려된 전체 목록</h2>
<table border="1" cellpadding="5" cellspacing="0">
    <thead>
        <tr>
            <th>주문ID</th>
            <th>입고 여부</th>
            <th>입고 날짜</th>
            <th>담당자</th>
        </tr>
    </thead>
    <tbody>
        <% for (InAndOutDto dto : list) {
            if (!"반려".equals(dto.getInApproval())) continue;
        %>
        <tr>
            <td><%= dto.getOrderId() %></td>
            <td><%= dto.isInOrder() ? "YES" : "NO" %></td>
            <td><%= dto.getIn_date() != null ? dto.getIn_date() : "-" %></td>
            <td><%= dto.getManager() != null ? dto.getManager() : "-" %></td>
        </tr>
        <% } %>
    </tbody>
</table>
<div style="margin-top:20px;">
    <a href="inandout_in.jsp">돌아가기</a>
</div>
</body>
</html>