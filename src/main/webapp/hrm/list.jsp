<%@page import="dao.HrmDao"%>
<%@page import="dto.HrmDto"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%
	// 출력해줄 상품 목록 얻어오기
	List<HrmDto> list = new HrmDao().selectAll();
%>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/hrm/list.jsp</title>
</head>
<body>
	<div class="container">
		<h1>본사 직원 목록</h1>
		<table>
			<thead>
				<tr>
					<th>번호</th>
					<th>이름</th>
					<th>직급</th>
				</tr>
			</thead>
			<tbody>
			<%for(HrmDto dto : list){ %>
				<tr>
					<td><%=dto.getNum() %></td>
					<td><%=dto.getName()%></td>
					<td><%=dto.getGrade() %></td>
				</tr>
			<%} %>
			</tbody>
		</table>
	</div>
</body>
</html>