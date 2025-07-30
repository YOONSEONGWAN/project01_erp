<%@page import="java.util.List"%>
<%@page import="dto.StockRequestDto"%>
<%@page import="dao.StockRequestDao"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	// 로그인된 지점 ID
	String branchId = (String)session.getAttribute("branchId");
	// 해당 지점의 발주 요청 목록 불러오기
	List<StockRequestDto> requestList = StockRequestDao.getInstance().selectByBranch(branchId);
	
%>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>발주 요청 목록</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-4">
	<h2>발주 요청 목록</h2>
	<div class="mb-3 text-end">
		<a href="insert.jsp" class="btn btn-primary">새 발주 요청</a>
	</div>
	<table class="table table-bordered table-hover">
		<thead class="table-light">
			<tr>
				<th>#</th>
				<th>재료명</th>
				<th>요청 수량</th>
				<th>상태</th>
				<th>요청일</th>
				<th>처리일</th>
			</tr>
		</thead>
		<tbody>
			<% if (requestList.isEmpty()) { %>
				<tr>
					<td colspan="6" class="text-center">발주 요청 내역이 없습니다.</td>
				</tr>
			<% } else { 
				for (StockRequestDto dto : requestList) { %>
				<tr>
					<td><%=dto.getRequestId() %></td>
					<td><%=dto.getIngredientName() %></td>
					<td><%=dto.getQuantity() %></td>
					<td><%=dto.getStatus() %></td>
					<td><%=dto.getRequestedAt() == null ? "-" : dto.getRequestedAt().substring(0, 10) %></td>
					<td><%=dto.getUpdatedAt() == null ? "-" : dto.getUpdatedAt().substring(0, 10) %></td>
				</tr>
			<% } } %>
		</tbody>
	</table>
</div>
</body>
</html>