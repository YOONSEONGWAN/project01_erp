<%@page import="java.text.NumberFormat"%>
<%@page import="dao.SalesDao"%>
<%@page import="dto.SalesDto"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    request.setCharacterEncoding("utf-8");

    String start = request.getParameter("start");
    String end = request.getParameter("end");

    List<SalesDto> list;
    if (start != null && end != null && !start.isEmpty() && !end.isEmpty()) {
        list = SalesDao.getInstance().getDailyAvgSalesBetween(start, end);
    } else {
        list = SalesDao.getInstance().getDailyAvgSales();
    }

    NumberFormat nf = NumberFormat.getInstance();
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>일 평균 매출 (지점별)</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="container-fluid px-0">
    <h2 class="mb-4">일 평균 매출 (지점별)</h2>
    <table class="table table-bordered">
        <thead class="table-light">
            <tr>
                <th>번호</th>
                <th>지점</th>
                <th>총 매출</th>
                <th>활동 일수</th>
                <th>일 평균 매출</th>
            </tr>
        </thead>
        <tbody>
            <%
                int index = 1;
                for (SalesDto dto : list) {
            %>
                <tr>
                    <td><%= index++ %></td>
                    <td><%= dto.getBranch_name() %></td>
                    <td><%= nf.format(dto.getTotalSales()) %> 원</td>
                    <td><%= dto.getDayCount() %> 일</td>
                    <td><%= nf.format(dto.getAverageSalesPerDay()) %> 원</td>
                </tr>
            <% } %>
        </tbody>
    </table>

</body>
</html>


