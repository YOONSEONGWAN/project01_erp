
<%@page import="dto.UserDto"%>
<%@page import="dao.UserDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	//세션에 저장된 userName 을 읽어온다. (이미 로그인된 상태이기 때문에)
	 String userId=(String)session.getAttribute("userId");
	
	//DB 에서 사용자 정보를 읽어온다.
	UserDto dto=UserDao.getInstance().getByUserId(userId);
%> 



<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/userp/userpinfo.jsp</title>
</head>
<body>
	<div class="container">
		<h1>회원 가입 정보</h1>
		<table class="table table-bordered table-striped">
			<tr>
				<th>프로필 이미지</th>
				<td>
					<%if(dto.getProfile_image() == null){ %>
						<i style="font-size:100px;" class="bi bi-person-circle"></i>
					<%}else{ %>
						<img src="${pageContext.request.contextPath }/upload/<%=dto.getProfile_image() %>" 
							style="width:100px;height:100px;border-radius:50%;"/>
					<%} %>
				</td>
			</tr>
			<tr>
				<th>지점장이름</th>
				<td><%=dto.getUser_name() %></td>
			</tr>
			<tr>
				<th>비밀번호</th>
				<td>
					<a href="edit-password.jsp">수정하기</a>
				</td>
			</tr>
			<tr>
				<th>회원 주소</th>
				<td><%=dto.getLocation() %></td>
			</tr> 
			
			<tr>
				<th>전화번호</th>
				<td><%=dto.getPhone() %></td>
			</tr>
			<tr>
				<th>직급</th>
				<td><%=dto.getRole() %></td>
			</tr>
			<tr>
				<th>가입 날짜</th>
				<td><%=dto.getCreated_at() %></td>
			</tr>
		</table>
		<a href="edit.jsp">개인 정보 수정</a>
	</div>
</body>
</html>