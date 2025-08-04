<%@page import="org.mindrot.jbcrypt.BCrypt"%>
<%@page import="dao.UserDao"%>
<%@page import="dto.UserDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String branchId = request.getParameter("branchId");
	String userId = request.getParameter("userId");
	String password = request.getParameter("password");
	
	boolean isValid = false;
	UserDto dto = UserDao.getInstance().getByBIandUI(branchId, userId);
	if(dto != null) {
		isValid = BCrypt.checkpw(password, dto.getPassword());
	}
	
	if(isValid) {
		session.setAttribute("userId", userId);
		session.setAttribute("branch_id", branchId);
		session.setMaxInactiveInterval(60*60);
		// 로그인 성공 -> /index/headquaterindex.jsp 로 이동
		response.sendRedirect(request.getContextPath()+ "/index/headquaterindex.jsp");
	} else{
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/userp/hqlogin.jsp</title>
</head>
<body>
	<script>
		alert("아이디 혹은 비밀번호가 잘못되었습니다.");
		location.href="${pageContext.request.contextPath }/userp/hqlogin-form.jsp"
	</script>
	<%} %>
</body>
</html>