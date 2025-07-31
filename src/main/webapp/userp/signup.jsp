<%@page import="dao.UserDao"%>
<%@page import="dto.UserDto"%>
<%@page import="org.mindrot.jbcrypt.BCrypt"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	// 폼 전송되는 정보 추출
	String branchId = request.getParameter("branchId");
	String userId = request.getParameter("userId");
	String password = request.getParameter("password");
	String userName = request.getParameter("userName");
	
	// 비밀번호 암호화
	String hashed = BCrypt.hashpw(password, BCrypt.gensalt());
	System.out.println("비밀번호 암호화 : " + hashed);
	
	UserDto dto = new UserDto();
	dto.setBranch_id(branchId);
	dto.setUser_id(userId);
	dto.setPassword(hashed);
	dto.setUser_name(userName);
	
	boolean isSuccess = UserDao.getInstance().insert(dto);
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/userp/signup.jsp</title>
</head>
<body>
	<div class="container">
		<%if(isSuccess) {%>
			<p>
				<strong><%=userId %>님 <%=branchId %> 지점 회원가입 되었습니다.</strong>
				<a href="loginform.jsp">로그인 하러가기</a>
			</p>
		<%} else{ %>
			<p>
				가입실패
				<a href="signup-form.jsp">다시 회원가입</a>
			</p>
		<%} %>
	</div>
</body>
</html>