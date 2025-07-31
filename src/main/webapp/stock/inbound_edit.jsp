<%@ page import="dao.stock.InboundOrdersDao" %>
<%@ page import="dto.stock.InboundOrdersDto" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    request.setCharacterEncoding("UTF-8");
    String orderIdParam = request.getParameter("order_id");
    InboundOrdersDto dto = null;

    if (orderIdParam != null) {
        int orderId = Integer.parseInt(orderIdParam);
        dto = InboundOrdersDao.getInstance().select(orderId);
    }

    if (dto == null) {
%>
    <p>해당 입고 정보를 찾을 수 없습니다.</p>
<%
    } else {
        String currentApproval = dto.getApproval();
        String newApproval = "승인".equals(currentApproval) ? "반려" : "승인";
%>
    <h2>입고 승인 상태 변경</h2>
    <p>입고 ID: <%= dto.getOrder_id() %></p>
    <p>현재 승인 상태: <%= currentApproval %></p>
    <form method="post" action="inandout_approval_update.jsp">
        <input type="hidden" name="type" value="inbound">
        <input type="hidden" name="order_id" value="<%= dto.getOrder_id() %>">
        <input type="hidden" name="approval" value="<%= newApproval %>">
        <p>새 승인 상태: <strong><%= newApproval %></strong></p>
        <button type="submit">변경 적용</button>
    </form>
<%
    }
%>