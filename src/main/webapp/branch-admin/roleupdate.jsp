<%@page import="dto.UserDtoAdmin"%>
<%@page import="dao.UserDaoAdmin"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String role=request.getParameter("role");
	Long num=Long.parseLong(request.getParameter("num"));
	UserDtoAdmin dto = UserDaoAdmin.getInstance().getByNum(num);
	dto.setRole(role);
	
	boolean isSuccess = UserDaoAdmin.getInstance().update(dto);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/branch-admin/roleupdate.jsp</title>
</head>
<body>
	<div class="container">
		<%if(isSuccess){%>
			<p>
				<strong><%=dto.getUser_name() %></strong> 님의 등급이 <%=dto.getRole() %> (으)로 수정되었습니다
				<a href="detail.jsp?num=<%=dto.getBranch_num()%>">돌아가기</a>
			</p>
		<%}else{ %>
			<p>
				수정 실패
				<a href="roleupdate-form.jsp?num=<%=dto.getNum()%>">돌아가기</a>
			</p>
		<%} %>
	</div>	
</body>
</html>