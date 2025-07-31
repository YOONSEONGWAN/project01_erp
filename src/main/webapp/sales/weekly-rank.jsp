<%@page import="java.text.NumberFormat"%>
<%@page import="dao.SalesDao"%>
<%@page import="dto.SalesDto"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    List<SalesDto> list = SalesDao.getInstance().getWeeklySalesRanking(); 
    NumberFormat nf = NumberFormat.getInstance();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/sales/weekly-rank.jsp</title>
</head>
<body>
	    <h1>지점별 주간 매출 순위</h1>
	 <table border="1">
	        <tr>
	            <th>순위</th>
	            <th>주차</th>
	            <th>지점명</th>
	            <th>총 매출액</th>
	        </tr>
	        <%
	            for (SalesDto dto : list) {
	        %>
	        <tr>
	            <td><%=dto.getRank()%></td>
	            <td><%=dto.getPeriod()%></td>
	            <td><%=dto.getBranch_name()%></td>
	            <td><%=nf.format(dto.getTotalSales())%></td>
	        </tr>
	        <% } %>
    </table>
</body>
</html>