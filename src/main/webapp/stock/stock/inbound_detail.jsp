<%@page import="java.util.List"%>
<%@page import="dto.stock.PlaceOrderHeadDetailDto"%>
<%@page import="dao.stock.PlaceOrderHeadDetailDao"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    String orderIdStr = request.getParameter("order_id");
    int orderId = 0;
    try {
        orderId = Integer.parseInt(orderIdStr);
    } catch (Exception e) {
        out.println("<script>alert('잘못된 접근입니다.'); history.back();</script>");
        return;
    }

    List<PlaceOrderHeadDetailDto> list = PlaceOrderHeadDetailDao.getInstance().getDetailsByOrderId(orderId);
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>입고 상세 내역</title>
</head>
<body>
    <h2>입고 상세 내역 (Order ID: <%= orderId %>)</h2>
    <table border="1" cellpadding="5" cellspacing="0">
        <tr>
            <th>상품명</th>
            <th>현재 수량</th>
            <th>신청 수량</th>
            <th>승인 여부</th>
            <th>담당자</th>
            
        </tr>
        <%
            for (PlaceOrderHeadDetailDto dto : list) {
        %>
        <tr>
            <td><%= dto.getProduct() %></td>
            <td><%= dto.getCurrent_quantity() %></td>
            <td><%= dto.getRequest_quantity() %></td>
            <td><%= dto.getApproval_status() %></td>
            <td><%= dto.getManager() %></td>
            
        </tr>
        <% } %>
    </table>
    <br>
    <a href="inandout.jsp">돌아가기</a>
</body>
</html>