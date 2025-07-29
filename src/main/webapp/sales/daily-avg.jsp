<%@page import="java.text.NumberFormat"%>
<%@page import="dao.SalesDao"%>
<%@page import="dto.SalesDto"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    List<SalesDto> list = SalesDao.getInstance().getDailyAvgSales();

	NumberFormat nf = NumberFormat.getInstance();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>/sales/daily-avg.jsp</title>
</head>
<body>
    <h1>일 평균 매출 (지점별)</h1>
    <table border="1">
        <thead>
            <tr>
                <th>지점</th>
                <th>총 매출</th>
                <th>활동 일수</th>
                <th>일 평균 매출</th>
            </tr>
        </thead>
        <tbody>
            <% for (SalesDto dto : list) { %>
                <tr>
                    <td><%= dto.getBranch() %></td>
                    <td><%= nf.format(dto.getTotalSales()) %></td>
                    <td><%= dto.getDayCount() %></td>
                    <td><%= nf.format(dto.getAverageSalesPerDay()) %></td>
                </tr>
            <% } %>
        </tbody>
    </table>
</body>
</html>
