<%@page import="org.mindrot.jbcrypt.BCrypt"%>
<%@page import="dao.UserDao"%>
<%@page import="dto.UserDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String userId = request.getParameter("userId");
	String password = request.getParameter("password");
	
	boolean isValid = false;
	UserDto dto = UserDao.getInstance().getByUserId(userId);
	if(dto != null) {
		isValid = BCrypt.checkpw(password, dto.getPassword());
	}
	
	if(isValid) {
		session.setAttribute("userId", userId);
		session.setMaxInactiveInterval(60*60);
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/userp/hqlogin.jsp</title>
</head>
<body>
	<div class="container">
		<%if(isValid) {%>
			<div>
				<strong><%=userId %> 님 로그인에 성공했습니다.</strong>
				<a href="${pageContext.request.contextPath }/index/headquaterindex.jsp">이동</a>
			</div>
		<%} else{ %>
			<div>
				아이디 혹은 비밀번호가 잘못되었습니다. <br>
				<a href="loginform.jsp"></a>
			</div>
		<%} %>
	</div>
</body>
</html>