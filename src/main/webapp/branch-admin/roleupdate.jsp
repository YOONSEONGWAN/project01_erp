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
	<script>
	<%if(isSuccess){%>
		alert("<%=dto.getUser_name() %> 님의 등급이 <%=dto.getRole() %>로 변경되었습니다")
		location.href="${pageContext.request.contextPath }/branch-admin/user-list.jsp"
	<%}else{ %>
		alert("<%=dto.getUser_name() %> 님의 등급 변경에 실패하였습니다")
		location.href="${pageContext.request.contextPath }/branch-admin/user-list.jsp"
	<%} %>
	</script>
</body>
</html>