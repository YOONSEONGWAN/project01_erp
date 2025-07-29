<%@page import="java.text.NumberFormat"%>
<%@page import="dao.SalesDao"%>
<%@page import="dto.SalesDto"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    // 월간 매출 통계 데이터 가져오기
    List<SalesDto> list = SalesDao.getInstance().getMonthlyStats();

	NumberFormat nf = NumberFormat.getInstance();

    // 총합 계산
    int totalSum = 0;
    for(SalesDto dto : list){
        totalSum += dto.getTotalSales();
    }
%>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/sales/monthly.jsp</title>
</head>
<body>
    <h1>월간 매출 통계</h1>

    <p>총 매출 합계: <%= nf.format(totalSum) %> 원</p>

    <table border="1">
        <thead>
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
                    <td><%= dto.getBranch() %></td>
                    <td><%= nf.format(dto.getTotalSales()) %></td>
                </tr>
            <% } %>
        </tbody>
    </table>
</body>
</html>