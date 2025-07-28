<%@page import="branch.dao.UserDao"%>
<%@page import="branch.dto.UserDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	//세션에 저장된 userName 을 읽어온다. (이미 로그인된 상태이기 때문에)
	String userName=(String)session.getAttribute("userName");
	//DB 에서 사용자 정보를 읽어온다.
	UserDto dto=UserDao.getInstance().getByName(userName);
%> 



<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>info2</title>
<jsp:include page="/WEB-INF/include/resource.jsp"></jsp:include>
</head>
<body>
		<div class="container">
		<h1> 정보</h1>
		<table class="table table-bordered table-striped">
		
			<tr>
				<th>프로필 이미지</th>
				<td>
				<%if(dto != null && dto.getProfileImage() != null){ %>
    				<img src="<%= request.getContextPath() %>/upload2/<%=dto.getProfileImage() %>" alt="Profile Image" width="150">
			<%}else{ %>
    				<i style="font-size:100px;" class="bi bi-person-circle"></i>
			<%} %>
				
				</td>
			</tr>
			
			<tr>
				<th>이름</th>
				<td><%=dto.getName() %></td>
			</tr>
			<tr>
				<th>비밀번호</th>
				<td>
					<a href="edit-password2.jsp">수정하기</a>
				</td>
			</tr>
			<tr>
				<th>지점 주소</th>
				<td><%=dto.getBranchLocation() %></td>
			</tr> 
				
			<tr>
				<th>지점 번호</th>
				<td><%=dto.getBranchNum() %></td>
				
			</tr>
			<tr>
				<th>직급</th>
				<td><%=dto.getGrade() %></td>
				
			</tr>
			

			
			<tr>
				<th>최종 수정 날짜</th>
				<td><%=dto.getUpdatedAt() %></td>
			</tr>
			
			
		</table>
		<a href="edit2.jsp">개인정보 수정</a>
	</div>
</body>
</html>