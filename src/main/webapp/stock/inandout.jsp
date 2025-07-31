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

    <!-- 입고 처리 내역 (최근 10건) -->
    <h2>입고 처리 내역 (최근 10건)</h2>
    <table>
        <thead>
        	<tr>
        		<th>입고 ID</th> 
        		<th>입고 날짜</th>
        		<th>담당자</th>
        		<th>상세보기</th>
        		
        	</tr>
        </thead>
        <tbody>
        <% if (processedInbounds.isEmpty()) { %>
            <tr><td colspan="6">-</td></tr>
        <% } else {
            for (InboundOrdersDto dto : processedInbounds) { %>
                <tr>
                    <td><%= dto.getOrder_id() %></td>
                    <td><%= dto.getIn_date() != null ? dto.getIn_date() : "-" %></td>
                    <td><%= dto.getManager() != null ? dto.getManager() : "-" %></td>
                    <td>
                    	<a href="inbound_detail.jsp?order_id=<%= dto.getOrder_id() %>">상세보기</a>
                	</td>
                </tr> 
        <% } } %>
        </tbody>
    </table>
    <a href="inbound_list.jsp" class="button-link">전체 입고 내역 보기</a>

    <!-- 출고 처리 내역 (최근 10건) -->
    <h2>출고 처리 내역 (최근 10건)</h2>
    <table>
        <thead>
        	<tr>
        		<th>출고 ID</th>
        		<th>승인 상태</th>
        		<th>출고 날짜</th>
        		<th>담당자</th>
        	</tr>
        </thead>
        <tbody>
        <% if (processedOutbounds.isEmpty()) { %>
            <tr><td colspan="6">-</td></tr>
        <% } else {
            for (OutboundOrdersDto dto : processedOutbounds) { %>
                <tr>
                    <td><%= dto.getOrder_id() %></td>
                    <td><%= dto.getApproval() != null ? dto.getApproval() : "-" %></td>
                    <td><%= dto.getOut_date() != null ? dto.getOut_date() : "-" %></td>
                    <td><%= dto.getManager() != null ? dto.getManager() : "-" %></td>
                </tr>
        <% } } %>
        </tbody>
    </table>
    <a href="outbound_list.jsp" class="button-link">전체 출고 내역 보기</a>
	
</div>
</body>
</html>