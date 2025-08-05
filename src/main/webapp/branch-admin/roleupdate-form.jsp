<%@page import="dao.UserDaoAdmin"%>
<%@page import="dto.UserDtoAdmin"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	Long num=Long.parseLong(request.getParameter("num"));
	UserDtoAdmin dto=UserDaoAdmin.getInstance().getByNum(num);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/branch-admin/roleupdate-form.jsp</title>
<jsp:include page="/WEB-INF/include/resource.jsp"></jsp:include>
</head>
<body>
	<div class="container">
		<form action="roleupdate.jsp" method="get">
			<input type="hidden" name="num" value="<%=dto.getNum() %>">
			<table>
				<tr>
					<th>회원 아이디</th>
					<th>지점명</th>
					<th>이름</th>
					<th>등급</th>
				</tr>
				<tr>					
					<td><%=dto.getUser_id() %></td>
					<td><%=dto.getBranch_name() %></td>
					<td><%=dto.getUser_name() %></td>			
					<td>
						<select name="role" id="role">
							<option value="manager" <%= dto.getRole().equals("manager") ? "selected" : "" %>>사장님</option>
							<option value="clerk" <%= dto.getRole().equals("clerk") ? "selected" : "" %>>직원</option>
							<option value="unapproved" <%= dto.getRole().equals("unapproved") ? "selected" : "" %>>미등록</option>
						</select>
					</td>					
				</tr>
			</table>		
			<button class="btn btn-sm btn-primary" type="submit">수정</button>
		</form>		
	</div>
</body>
</html>