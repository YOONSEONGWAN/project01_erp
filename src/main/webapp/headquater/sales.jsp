<%@page import="java.text.NumberFormat"%>
<%@page import="dao.SalesDao"%>
<%@page import="dto.SalesDto"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	//출력해줄 매출 목록 불러오기
	List<SalesDto> list = SalesDao.getInstance().selectAll();

	NumberFormat nf = NumberFormat.getInstance();
%>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/headquater/sales.jsp</title>
</head>
<body>
	<h1>매출 통계조회</h1>
	<div class="container">
		<li>
			<a href="${pageContext.request.contextPath }/sales/weekly.jsp">주간 총 매출</a>
		</li>
		
		<li>
			<a href="${pageContext.request.contextPath }/sales/monthly.jsp">월간 총 매출</a>
		</li>
		<li>
		
			<a href="${pageContext.request.contextPath }/sales/annual.jsp">연간 총 매출</a>
		</li>
		
		<br />
		<li>
		
			<a href="${pageContext.request.contextPath }/sales/monthly-avg.jsp">월 평균 매출</a>
		</li>
		<li>
		
			<a href="${pageContext.request.contextPath }/sales/weekly-avg.jsp">주간 평균 매출</a>
		</li>
		<li>
		
			<a href="${pageContext.request.contextPath }/sales/daily-avg.jsp">일 평균 매출</a>
		</li>
		
		<br />
		<li>
		
			<a href="${pageContext.request.contextPath }/sales/weekly-max.jsp">주간 최고 매출일</a>
		</li>
		<li>
		
			<a href="${pageContext.request.contextPath }/sales/monthly-max.jsp">월간 최고 매출일</a>
		</li>						
				
						
		<h1>전체 매출 목록</h1>
		<table border = "1">
			<tr>
				<th>매출 번호</th>
				<th>지점 이름</th>
				<th>매출 날짜</th>
				<th>총 매출 액</th>
			</tr>
			 <tbody>
			 	<%for(SalesDto tmp:list) {%>
			 		<tr>
			 			<td><%=tmp.getSales_id() %></td>
			 			<td><%=tmp.getBranch() %></td>
			 			<td><%=tmp.getCreated_at() %></td>
			 			<td><%= nf.format(tmp.getTotalamount()) %></td>
			 		</tr>
			 	<%} %>
			 </tbody>
		</table>
	</div>
</body>
</html>