<%@page import="java.util.List"%>
<%@page import="dao.stock.InboundOrdersDao"%>
<%@page import="dto.stock.InboundOrdersDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
    List<InboundOrdersDto> list = InboundOrdersDao.getInstance().selectAll();
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>전체 입고 내역</title>
    <style>
        table { border-collapse: collapse; width: 100%; margin-top: 20px; }
        th, td { border: 1px solid #ccc; padding: 8px; text-align: center; }
        th { background-color: #f2f2f2; }
        .container { width: 90%; margin: auto; }
        h2 { margin-top: 40px; }
        a.button-link { margin-top: 20px; display: inline-block; text-decoration: none; color: blue; }
    </style>
</head>
<body>
<div class="container">
    <h2>전체 입고 내역</h2>

    <table>
        <thead>
            <tr>
                <th>입고 ID</th>
                <th>재고 ID</th>
                <th>승인 상태</th>
                <th>입고 날짜</th>
                <th>담당자</th>
                <th>관리</th>
            </tr>
        </thead>
        <tbody>
            <% if (list.isEmpty()) { %>
                <tr><td colspan="6">입고 내역이 없습니다.</td></tr>
            <% } else {
                for (InboundOrdersDto dto : list) { %>
                    <tr>
                        <td><%= dto.getOrder_id() %></td>
                        <td><%= dto.getInventory_id() %></td>
                        <td><%= dto.getApproval() != null ? dto.getApproval() : "-" %></td>
                        <td><%= dto.getIn_date() != null ? dto.getIn_date() : "-" %></td>
                        <td><%= dto.getManager() != null ? dto.getManager() : "-" %></td>
                        <td><a href="inandout_in_edit.jsp?order_id=<%= dto.getOrder_id() %>">수정</a></td>
                    </tr>
            <%  } } %>
        </tbody>
    </table>

    <a href="inandout.jsp" class="button-link">돌아가기</a>
</div>
</body>
</html>