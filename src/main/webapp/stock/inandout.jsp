<%@page import="java.util.List"%>
<%@page import="dao.stock.InboundOrdersDao"%>
<%@page import="dao.stock.OutboundOrdersDao"%>
<%@page import="dto.stock.InboundOrdersDto"%>
<%@page import="dto.stock.OutboundOrdersDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // 입고/출고 승인 대기 및 처리된 데이터 조회
    List<InboundOrdersDto> pendingInbounds = InboundOrdersDao.getInstance().selectByApproval("대기");
    List<OutboundOrdersDto> pendingOutbounds = OutboundOrdersDao.getInstance().selectByApproval("대기");
    List<InboundOrdersDto> processedInbounds = InboundOrdersDao.getInstance().selectProcessed(10);
    List<OutboundOrdersDto> processedOutbounds = OutboundOrdersDao.getInstance().selectProcessed(10);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>입고/출고 관리</title>
    <style>
        table { border-collapse: collapse; margin-bottom: 20px; width: 100%; }
        th, td { border: 1px solid #ccc; padding: 8px; text-align: center; }
        th { background-color: #f0f0f0; }
        .container { width: 90%; margin: 0 auto; }
        a.button-link { margin-right: 15px; text-decoration: none; color: blue; }
    </style>
</head>
<body>
<div class="container">

    <!-- 입고 승인 대기 목록 -->
    <h2>입고 승인 대기 목록</h2>
    <table>
        <thead><tr><th>입고 ID</th><th>재고 ID</th><th>입고 날짜</th><th>담당자</th><th>승인 처리</th></tr></thead>
        <tbody>
        <% if (pendingInbounds.isEmpty()) { %>
            <tr><td colspan="5">-</td></tr>
        <% } else {
            for (InboundOrdersDto dto : pendingInbounds) { %>
                <tr>
                    <td><%= dto.getOrder_id() %></td>
                    <td><%= dto.getInventory_id() %></td>
                    <td><%= dto.getIn_date() != null ? dto.getIn_date() : "-" %></td>
                    <td><%= dto.getManager() != null ? dto.getManager() : "-" %></td>
                    <td>
                        <form method="post" action="inandout_approval_update.jsp">
                            <input type="hidden" name="type" value="inbound">
                            <input type="hidden" name="order_id" value="<%= dto.getOrder_id() %>">
                            <select name="approval">
                                <option value="승인">승인</option>
                                <option value="반려">반려</option>
                            </select>
                            <button type="submit">처리</button>
                        </form>
                    </td>
                </tr>
        <% } } %>
        </tbody>
    </table>

    <!-- 출고 승인 대기 목록 -->
    <h2>출고 승인 대기 목록</h2>
    <table>
        <thead><tr><th>출고 ID</th><th>재고 ID</th><th>출고 날짜</th><th>담당자</th><th>승인 처리</th></tr></thead>
        <tbody>
        <% if (pendingOutbounds.isEmpty()) { %>
            <tr><td colspan="5">-</td></tr>
        <% } else {
            for (OutboundOrdersDto dto : pendingOutbounds) { %>
                <tr>
                    <td><%= dto.getOrder_id() %></td>
                    <td><%= dto.getInventory_id() %></td>
                    <td><%= dto.getOut_date() != null ? dto.getOut_date() : "-" %></td>
                    <td><%= dto.getManager() != null ? dto.getManager() : "-" %></td>
                    <td>
                        <form method="post" action="inandout_approval_update.jsp">
                            <input type="hidden" name="type" value="outbound">
                            <input type="hidden" name="order_id" value="<%= dto.getOrder_id() %>">
                            <select name="approval">
                                <option value="승인">승인</option>
                                <option value="반려">반려</option>
                            </select>
                            <button type="submit">처리</button>
                        </form>
                    </td>
                </tr>
        <% } } %>
        </tbody>
    </table>

    <!-- 입고 처리 내역 (최근 10건) -->
    <h2>입고 처리 내역 (최근 10건)</h2>
    <table>
        <thead><tr><th>입고 ID</th><th>재고 ID</th><th>승인 상태</th><th>입고 날짜</th><th>담당자</th><th>관리</th></tr></thead>
        <tbody>
        <% if (processedInbounds.isEmpty()) { %>
            <tr><td colspan="6">-</td></tr>
        <% } else {
            for (InboundOrdersDto dto : processedInbounds) { %>
                <tr>
                    <td><%= dto.getOrder_id() %></td>
                    <td><%= dto.getInventory_id() %></td>
                    <td><%= dto.getApproval() != null ? dto.getApproval() : "-" %></td>
                    <td><%= dto.getIn_date() != null ? dto.getIn_date() : "-" %></td>
                    <td><%= dto.getManager() != null ? dto.getManager() : "-" %></td>
                    <td><a href="inbound_edit.jsp?order_id=<%= dto.getOrder_id() %>">수정</a></td>
                </tr>
        <% } } %>
        </tbody>
    </table>
    <a href="inbound_list.jsp" class="button-link">전체 입고 내역 보기</a>

    <!-- 출고 처리 내역 (최근 10건) -->
    <h2>출고 처리 내역 (최근 10건)</h2>
    <table>
        <thead><tr><th>출고 ID</th><th>재고 ID</th><th>승인 상태</th><th>출고 날짜</th><th>담당자</th><th>관리</th></tr></thead>
        <tbody>
        <% if (processedOutbounds.isEmpty()) { %>
            <tr><td colspan="6">-</td></tr>
        <% } else {
            for (OutboundOrdersDto dto : processedOutbounds) { %>
                <tr>
                    <td><%= dto.getOrder_id() %></td>
                    <td><%= dto.getInventory_id() %></td>
                    <td><%= dto.getApproval() != null ? dto.getApproval() : "-" %></td>
                    <td><%= dto.getOut_date() != null ? dto.getOut_date() : "-" %></td>
                    <td><%= dto.getManager() != null ? dto.getManager() : "-" %></td>
                    <td><a href="outbound_edit.jsp?order_id=<%= dto.getOrder_id() %>">수정</a></td>
                </tr>
        <% } } %>
        </tbody>
    </table>
    <a href="outbound_list.jsp" class="button-link">전체 출고 내역 보기</a>

</div>
</body>
</html>