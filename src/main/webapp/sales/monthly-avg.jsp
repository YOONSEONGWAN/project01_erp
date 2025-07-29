<%@page import="java.text.NumberFormat"%>
<%@page import="dao.SalesDao"%>
<%@page import="dto.SalesDto"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	List<SalesDto> list = SalesDao.getInstance().getMonthlyAvgSats();

	NumberFormat nf = NumberFormat.getInstance();
%>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/sales/monthly-avg.jsp</title>
</head>
<body>
	<h1>월 평균 매출 통계</h1>
	<table border = "1">
		<thead>
		<tr>
			<th>번호</th>
			<th>기간</th>
			<th>지점</th>
			<th>총 매출</th>
			<th>평균 매출</th>
		</tr>
		</thead>
        <tbody>
         <%
        	int index = 1;
            for(SalesDto dto : list) 
         { %>  	
                <tr>
                	<td><%= index++ %></td>
                    <td><%= dto.getPeriod() %></td>
                    <td><%= dto.getBranch() %></td>
                    <td><%= nf.format(dto.getTotalSales()) %></td>
                    <td><%= nf.format(dto.getAverageSales()) %></td>
                </tr>
            <% } %>
        </tbody>
	</table>
</body>
</html>