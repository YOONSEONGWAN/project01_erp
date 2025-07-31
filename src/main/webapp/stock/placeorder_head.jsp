<%@page import="dto.stock.PlaceOrderHeadDto"%>
<%@page import="dao.stock.PlaceOrderHeadDao"%>
<%@page import="dto.stock.InventoryDto"%>
<%@page import="dao.stock.InventoryDao"%>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    List<InventoryDto> list = InventoryDao.getInstance().selectAll();
    List<PlaceOrderHeadDto> list2 = PlaceOrderHeadDao.getInstance().getRecentOrders();
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>발주 신청 내역</title>
</head>
<body>
    <h2>발주 신청 내역</h2>
    <form action="placeorder_head_confirm.jsp" method="post">
        <table border="1" cellpadding="5" cellspacing="0">
            <thead>
                <tr>
                    <th>상품명</th>
                    <th>현재 수량</th>
                    <th>발주 수량</th>
                    <th>발주 상태</th>
                </tr>
            </thead>
            <tbody>
                <%
                    for (InventoryDto dto : list) {
                        if (!dto.isPlaceOrder()) {
                            continue;
                        }
                %>
                <tr>
                    <td><%= dto.getProduct() %></td>
                    <td><%= dto.getQuantity() %></td>
                    <td>
                        <input type="number" name="amount_<%= dto.getNum() %>" min="1" value="1" required>
                    </td>
                    <td>
                        <select name="approval_<%= dto.getNum() %>">
                            <option value="NO">반려</option>
                            <option value="YES">승인</option>
                        </select>
                    </td>
                </tr>
                <% } %>
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
                for (PlaceOrderHeadDto order : list2) {
            %>
            <tr>
                <td><%= order.getOrder_id() %></td>
                <td><%= order.getOrder_date() %></td>
                <td><%= order.getManager() %></td>
                <td>
                    <a href="placeorder_head_detail.jsp?order_id=<%= order.getOrder_id() %>">상세 보기</a>
                </td>
            </tr>
            <% } %>
        </tbody>
    </table>

    <br>
    <a href="placeorder_head_all.jsp">전체 발주 내역 보기</a>
    <br>
    <a href="placeorder.jsp">돌아가기</a>
</body>
</html>