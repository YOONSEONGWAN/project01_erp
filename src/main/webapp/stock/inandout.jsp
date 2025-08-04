<%@page import="java.util.List"%>
<%@page import="dao.stock.InboundOrdersDao"%>
<%@page import="dao.stock.OutboundOrdersDao"%>
<%@page import="dto.stock.InboundOrdersDto"%>
<%@page import="dto.stock.OutboundOrdersDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    // 최근 10건 조회
    List<InboundOrdersDto> processedInbounds = InboundOrdersDao.getInstance().selectProcessedWithKeyword(10);
    List<OutboundOrdersDto> processedOutbounds = OutboundOrdersDao.getInstance().selectProcessedWithKeyword(10);
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>입고/출고 관리</title>

    <!-- 부트스트랩 CSS/JS가 포함되어 있다고 가정 -->
    <jsp:include page="/WEB-INF/include/resource.jsp"/>
    <style>
        /* 재고 목록과 동일한 헤더 색상 적용 */
        table thead th {
            background-color: #007bff !important;
            color: white !important;
        }
    </style>
</head>
<body>
<div class="container my-4">

    <!-- 입고 처리 내역 -->
    <h2 class="mb-3">입고 처리 내역 (최근 10건)</h2>
    <table class="table table-bordered text-center align-middle">
        <thead>
            <tr>
                <th>입고 ID</th>
                <th>입고 날짜</th>
                <th>담당자</th>
                <th>상세보기</th>
            </tr>
        </thead>
        <tbody>
        <% if (processedInbounds == null || processedInbounds.isEmpty()) { %>
            <tr><td colspan="4">-</td></tr>
        <% } else {
            for (InboundOrdersDto dto : processedInbounds) { %>
                <tr>
                    <td><%= dto.getOrder_id() %></td>
                    <td><%= dto.getIn_date() != null ? dto.getIn_date() : "-" %></td>
                    <td><%= dto.getManager() != null ? dto.getManager() : "-" %></td>
                    <td>
                        <a href="inbound_detail.jsp?order_id=<%= dto.getOrder_id() %>" class="btn btn-sm btn-primary">상세보기</a>
                    </td>
                </tr>
        <% } } %>
        </tbody>
    </table>
    <a href="inbound_list.jsp" class="btn btn-link mb-4">전체 입고 내역 보기</a>

    <!-- 출고 처리 내역 -->
    <h2 class="mb-3">출고 처리 내역 (최근 10건)</h2>
    <table class="table table-bordered text-center align-middle">
        <thead>
            <tr>
                <th>출고 ID</th>
                <th>출고 날짜</th>
                <th>담당자</th>
                <th>상세보기</th>
            </tr>
        </thead>
        <tbody>
        <% if (processedOutbounds == null || processedOutbounds.isEmpty()) { %>
            <tr><td colspan="4">-</td></tr>
        <% } else {
            for (OutboundOrdersDto dto : processedOutbounds) { %>
                <tr>
                    <td><%= dto.getOrder_id() %></td>
                    <td><%= dto.getOut_date() != null ? dto.getOut_date() : "-" %></td>
                    <td><%= dto.getManager() != null ? dto.getManager() : "-" %></td>
                    <td>
                        <a href="outbound_detail.jsp?order_id=<%= dto.getOrder_id() %>" class="btn btn-sm btn-primary">상세보기</a>
                    </td>
                </tr>
        <% } } %>
        </tbody>
    </table>
    <a href="outbound_list.jsp" class="btn btn-link">전체 출고 내역 보기</a>

</div>
</body>
</html>