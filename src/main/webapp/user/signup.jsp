<%@page import="dao.UserDao"%>
<%@page import="dto.UserDto"%>
<%@page import="org.mindrot.jbcrypt.BCrypt"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	// 폼 데이터 받기
	String userId = request.getParameter("user_id");
	String userName = request.getParameter("user_name");
	String password = request.getParameter("password");
	String branchId = request.getParameter("branch_id");
	String myLocation = request.getParameter("myLocation");
	String phoneNum = request.getParameter("phoneNum");
	String grade = request.getParameter("grade");
	String profileImage = request.getParameter("profileImage");
	
	//사용자가 입력한 비밀 번호를 암호화한 비밀번호를 얻어낸다.
	String hashed=BCrypt.hashpw(password, BCrypt.gensalt());
	System.out.println("암호화된 비밀번호:"+hashed);
	
	// DTO에 담기
	UserDto dto = new UserDto();
	dto.setUserId(userId);
	dto.setUserName(userName);
	dto.setPassword(hashed);
	dto.setBranchId(branchId);
	dto.setMyLocation(myLocation);
	dto.setPhoneNum(phoneNum);
	dto.setGrade(grade);
	dto.setProfileImage(profileImage);
	
	// DAO로 회원가입 처리
	boolean isSuccess = UserDao.getInstance().insert(dto);
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<div class="container">
		<%if(isSuccess){ %>
			<p>
				 <strong><%=userName %></strong> 님 회원가입 되었습니다.
				 <a href="loginform.jsp">로그인 하러가기</a>
			</p>
		<%}else{ %>
			<p>
				가입 실패!
				<a href="signup-form.jsp">다시 가입</a>
			</p>
		<%} %>
	</div>
</body>
</html>