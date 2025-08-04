<%@page import="java.text.NumberFormat"%>
<%@page import="dao.SalesDao"%>
<%@page import="dto.SalesDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    request.setCharacterEncoding("utf-8");
    String start = request.getParameter("start");
    String end = request.getParameter("end");

    NumberFormat nf = NumberFormat.getInstance();
    SalesDto dto = null;

    if (start != null && end != null && !start.isEmpty() && !end.isEmpty()) {
        dto = SalesDao.getInstance().getStatsBetweenDates(start, end);
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>기간별 매출 통계</title>
</head>
<body>
    <h1>📆 날짜 범위 기반 매출 통계</h1>

   	<form method="get" action="<%= request.getContextPath() %>/sales/sales-range.jsp">


        <label>시작일: </label>
        <input type="date" name="start" value="<%= start != null ? start : "" %>">
        <label>종료일: </label>
        <input type="date" name="end" value="<%= end != null ? end : "" %>">
        <button type="submit">조회</button>
    </form>

    <hr />

    <% if (dto != null) { %>
        <% if (dto.getTotalSales() == 0) { %>
            <p>해당 기간에 매출 데이터가 없습니다.</p>
        <% } else { %>
            <h2><%= start %> ~ <%= end %> 매출 통계</h2>
            <ul>
                <li>총 일수: <%= dto.getDayCount() %>일</li>
                <li>총 매출: <%= nf.format(dto.getTotalSales()) %>원</li>
                <li>일 평균 매출: <%= nf.format(dto.getAverageSales()) %>원</li>
                <li>🏆 최고 매출 지점: <%= dto.getTopBranchName() %> (<%= nf.format(dto.getTopBranchSales()) %>원)</li>
            </ul>
        <% } %>
    <% } %>
</body>
</html>
