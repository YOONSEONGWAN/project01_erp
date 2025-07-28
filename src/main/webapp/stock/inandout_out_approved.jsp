<%@page import="java.util.List"%>
<%@page import="dao.stock.InAndOutDao"%>
<%@page import="dto.stock.InAndOutDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
    List<InAndOutDto> list = InAndOutDao.getInstance().selectAll();
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>출고 승인된 전체 목록</title>
</head>
<body>
    <h2>출고 승인된 전체 목록</h2>
    <table border="1" cellpadding="5" cellspacing="0">
        <thead>
            <tr>
                <th>주문ID</th>
                <th>출고 여부</th>
                <th>출고 날짜</th>
                <th>담당자</th>
            </tr>
        </thead>
        <tbody>
            <% for (InAndOutDto dto : list) {
                if (!"승인".equals(dto.getOutApproval())) continue;
            %>
            <tr>
                <td><%= dto.getOrderId() %></td>
                <td><%= dto.isOutOrder() ? "YES" : "NO" %></td>
                <td><%= dto.getOut_date() != null ? dto.getOut_date() : "-" %></td>
                <td><%= dto.getManager() != null ? dto.getManager() : "-" %></td>
            </tr>
            <% } %>
        </tbody>
    </table>
    <div style="margin-top:10px;">
        <a href="inandout_out.jsp">돌아가기</a>
    </div>
</body>
</html>