<%@page import="java.text.NumberFormat"%>
<%@page import="dao.SalesDao"%>
<%@page import="dto.SalesDto"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    request.setCharacterEncoding("UTF-8");
    String start = request.getParameter("start");
    String end = request.getParameter("end");

    List<SalesDto> list;
    if (start != null && end != null && !start.isEmpty() && !end.isEmpty()) {
        list = SalesDao.getInstance().getYearlyStatsBetween(start, end);
    } else {
        list = SalesDao.getInstance().getYearlyStatsBetween("2000-01-01", "2099-12-31");
    }

    NumberFormat nf = NumberFormat.getInstance();
    int totalSum = 0;
    for (SalesDto dto : list) {
        totalSum += dto.getTotalSales();
    }
%>
<h2>연간 매출 통계</h2>
<p>총 매출 합계: <%= nf.format(totalSum) %> 원</p>
<table border="1">
    <tr><th>연도</th><th>지점</th><th>매출 합계</th></tr>
    <% for (SalesDto dto : list) { %>
        <tr>
            <td><%= dto.getPeriod() %></td>
            <td><%= dto.getBranch_name() %></td>
            <td><%= nf.format(dto.getTotalSales()) %></td>
        </tr>
    <% } %>
</table>
