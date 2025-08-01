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
        list = SalesDao.getInstance().getWeeklyStatsBetween(start, end);
    } else {
        list = SalesDao.getInstance().getWeeklyStats();
    }

    NumberFormat nf = NumberFormat.getInstance();

    int totalSum = 0;
    for(SalesDto dto : list){
        totalSum += dto.getTotalSales();
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>/sales/weekly.jsp</title>
</head>
<body>
    <h1>주간 매출 통계</h1>

    <% if (start != null && end != null && !start.isEmpty() && !end.isEmpty()) { %>
        <p>조회 범위: <%= start %> ~ <%= end %></p>
    <% } else { %>
        <p>전체 기간 매출입니다.</p>
    <% } %>

    <p>총 매출 합계: <%= nf.format(totalSum) %> 원</p>

    <table border="1">
        <thead>
            <tr>
                <th>주차</th>
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
