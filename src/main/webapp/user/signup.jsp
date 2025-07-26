<%@page import="org.mindrot.jbcrypt.BCrypt"%>
<%@page import="dao.UserDao"%>
<%@page import="dto.UserDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String name = request.getParameter("name");
	String password = request.getParameter("password");
	String branchLocation = request.getParameter("branchLocation");
	String myLocation = request.getParameter("myLocation");
	String phoneNum = request.getParameter("phoneNum");
	
	String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
	
	UserDto dto = new UserDto();
	dto.setName(name);
	dto.setPassword(hashedPassword);
	dto.setBranchLocation(branchLocation);
	dto.setMyLocation(myLocation);
	dto.setPhoneNum(phoneNum);
	
	boolean isSuccess = UserDao.getInstance().insert(dto);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<%if(isSuccess){ %>
		<script>
			alert("회원가입 되었습니다.")
			location.href="${pageContext.request.contextPath }/"
		</script>
	<%}else{ %>
		<script>
			alert("다시 입력하세요")
			location.href="signup-form.jsp"
		</script>
	<%} %>
</body>
</html>