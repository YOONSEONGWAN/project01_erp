<%@ page import="java.util.List" %>
<%@ page import="dto.stock.PlaceOrderBranchDto" %>
<%@ page import="dao.stock.PlaceOrderBranchDao" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>발주 내역 보기</title>
</head>
<body>

<%
    // DAO에서 최근 10건 발주 내역 불러오기
    List<PlaceOrderBranchDto> list = PlaceOrderBranchDao.getInstance().getRecentOrders();
%>

<h2>최근 10건 발주 내역</h2>
<table border="1" cellpadding="5" cellspacing="0">
    <thead>
        <tr>
            <th>Order ID</th>
            <th>발주일</th>
            <th>담당자</th>
            <th>상세 보기</th>
        </tr>
    </thead>
    <tbody>
        <%
            for (PlaceOrderBranchDto dto : list) {
        %>
        <tr>
            <td><%= dto.getOrder_id() %></td>
            <td><%= dto.getDate() %></td>
            <td><%= dto.getManager() %></td>
            <td>
                <a href="placeorder_branch_detail.jsp?order_id=<%= dto.getOrder_id() %>">상세 보기</a>
            </td>
        </tr>
        <%
            }
        %>
    </tbody>
</table>

<br>
<a href="placeorder_branch_all.jsp">전체 발주 내역 보기</a>
<br>
<a href="placeorder.jsp">돌아가기</a>

</body>
</html>