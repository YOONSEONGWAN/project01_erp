
<%@page import="dao.SalesDao"%>
<%@page import="dto.SalesDto"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	//출력해줄 매출 목록 불러오기
	List<SalesDto> list = SalesDao.getInstance().selectAll();
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
			<a href="${pageContext.request.contextPath }/sales/weekly.jsp">주간 통계</a>
		</li>
		
		<li>
			<a href="${pageContext.request.contextPath }/sales/monthly.jsp">월간 통계</a>
		</li>
		<li>
		
			<a href="${pageContext.request.contextPath }/sales/annual.jsp">연간 통계</a>
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
			 			<td><%=tmp.getTotalamount() %></td>
			 		</tr>
			 	<%} %>
			 </tbody>
		</table>
	</div>
</body>
</html>







