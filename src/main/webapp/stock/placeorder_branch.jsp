<%@page import="dao.StockRequestDao"%>
<%@page import="dto.StockRequestDto"%>
<%@ page import="java.util.List" %>
<%@ page import="dto.stock.PlaceOrderBranchDto" %>
<%@ page import="dao.stock.PlaceOrderBranchDao" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
    List<StockRequestDto> list2 = new StockRequestDao().selectAll();
    List<PlaceOrderBranchDto> recentList = PlaceOrderBranchDao.getInstance().getRecentOrders();
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>발주 내역 보기</title>
</head>
<body>

<h2>발주 신청 내역</h2>
<form action="placeorder_branch_confirm.jsp" method="post">
    <table border="1" cellpadding="5" cellspacing="0">
        <thead>
            <tr>
                <th>주문번호</th>
                <th>지점명</th>
                <th>상품명</th>
                <th>현재 수량</th>
                <th>발주 수량</th>
                <th>신청일</th>
                <th>발주 상태</th>
            </tr>
        </thead>
        <tbody>
        <%
        for (StockRequestDto reqDto : list2) {
            if (!"yes".equals(reqDto.getIsPlaceOrder())) {
                continue;
            }
        %>
        <tr>
            <td><%= reqDto.getOrderId() %></td>
            <td><%= reqDto.getBranchId() %></td>
            <td><%= reqDto.getProduct() %></td>
            <td><%= reqDto.getCurrentQuantity() %></td>
            <td>
                <input type="number" name="amount_<%= reqDto.getOrderId() %>" min="1" value="<%= reqDto.getRequestQuantity() %>" required>
            </td>
            <td><%= reqDto.getRequestedAt() %></td>
            <td>
                <select name="approval_<%= reqDto.getOrderId() %>">
                    <option value="NO">반려</option>
                    <option value="YES">승인</option>
                </select>
            </td>
        </tr>
        <%
        }
        %>
        </tbody>
    </table>
    <br>
    <input type="submit" value="발주 확정">
</form>

<hr>

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
            for (PlaceOrderBranchDto poDto : recentList) {
        %>
        <tr>
            <td><%= poDto.getOrder_id() %></td>
            <td><%= poDto.getDate() %></td>
            <td><%= poDto.getManager() %></td>
            <td>
                <a href="placeorder_branch_detail.jsp?order_id=<%= poDto.getOrder_id() %>">상세 보기</a>
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