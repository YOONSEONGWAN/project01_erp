<%@page import="java.text.NumberFormat"%>
<%@page import="dao.SalesDao"%>
<%@page import="dto.SalesDto"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
    request.setCharacterEncoding("utf-8");

    String start = request.getParameter("start");
    String end = request.getParameter("end");

    List<SalesDto> list;
    if (start != null && end != null && !start.isEmpty() && !end.isEmpty()) {
        list = SalesDao.getInstance().getMonthlyMaxSalesDatesBetween(start, end);
    } else {
        list = SalesDao.getInstance().getMonthlyMaxSalesDates();
    }

    NumberFormat nf = NumberFormat.getInstance();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>/sales/monthly-max.jsp</title>
</head>
<body class="container mt-4">
    <h2 class="mb-4">지점별 월간 최고 매출일</h2>
    <table class="table table-bordered">
    <thead class="table-light">
        <tr>
            <th>번호</th>
            <th>월간</th>
            <th>지점</th>
            <th>최고 매출일</th>
            <th>매출액</th>
        </tr>
        </thead>

        <%
            int index = 1;
            for(SalesDto dto : list) {
        %>
        <tr>
            <td><%= index++ %></td>
            <td><%= dto.getPeriod() %></td>
            <td><%= dto.getBranch_name() %></td>
            <td><%= dto.getMaxSalesDate() %></td>
            <td><%= nf.format(dto.getTotalSales()) %> 원</td>
        </tr>
        <% } %>
    </table>
</body>
</html>
