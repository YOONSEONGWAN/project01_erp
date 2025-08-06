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
        list = SalesDao.getInstance().getMonthlyStatsBetween(start, end);
    } else {
        list = SalesDao.getInstance().getMonthlyStatsBetween("2000-01-01", "2099-12-31");
    }

    NumberFormat nf = NumberFormat.getInstance();
    int totalSum = 0;
    for (SalesDto dto : list) {
        totalSum += dto.getTotalSales();
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>월간 매출 통계</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="container mt-4">
    <h2 class="mb-4">월간 매출 통계</h2>
    <table class="table table-bordered">
        <thead class="table-light">
            <tr>
                <th>월</th>
                <th>지점</th>
                <th>매출 합계</th>
            </tr>
        </thead>
        <tbody>
            <% for(SalesDto dto : list) { %>
                <tr>
                    <td><%= dto.getPeriod() %></td>
                    <td><%= dto.getBranch_name() %></td>
                    <td><%= nf.format(dto.getTotalSales()) %> 원</td>
                </tr>
            <% } %>
        </tbody>
    </table>
</body>
</html>
