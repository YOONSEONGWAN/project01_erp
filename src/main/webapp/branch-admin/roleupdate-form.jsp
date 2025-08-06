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
	<div class="container mt-1">
		<a class="btn btn-outline-primary" href="detail.jsp?num=<%=dto.getBranch_num()%>">지점 정보로 돌아가기</a>
		<h1 class="mb-4 text-center">회원 상세 정보</h1>
		<form action="roleupdate.jsp" method="get">
			<input type="hidden" name="returnUrl" value="detail.jsp?num=<%=dto.getBranch_num()%>">
			<input type="hidden" name="num" value="<%=dto.getNum() %>">
			<div class="row">
				<div class="col">
					<table class="table table-bordered mx-auto w-75">
						<tr>
							<th>회원 아이디</th>
							<td><%= dto.getUser_id() %></td>
						</tr>
						<tr>
							<th>지점명</th>
							<td><%= dto.getBranch_name() %></td>
						</tr>
						<tr>
							<th>이름</th>
							<td><%= dto.getUser_name() %></td>
						</tr>
						<tr>
							<th>등급</th>
							<td>
								<select name="role" id="role">
									<option value="manager" <%= dto.getRole().equals("manager") ? "selected" : "" %>>사장님</option>
									<option value="clerk" <%= dto.getRole().equals("clerk") ? "selected" : "" %>>직원</option>
									<option value="unapproved" <%= dto.getRole().equals("unapproved") ? "selected" : "" %>>미등록</option>
								</select>
							</td>
						</tr>
						<tr>
							<th>연락처</th>
							<td><%= dto.getPhone() %></td>
						</tr>
						<tr>
							<th>주소지</th>
							<td><%= dto.getLocation() %></td>
						</tr>
						<tr>
							<th>등록일</th>
							<td><%= dto.getCreated_at() %></td>
						</tr>
						<tr>
							<th>수정일</th>
							<td><%= dto.getUpdated_at() %></td>
						</tr>
					</table>	
				</div>
				
			</div>
			<button class="btn btn-sm btn-primary" style="right:12.5%;" type="submit">수정</button>
		</form>		
	</div>	
</body>
</html>