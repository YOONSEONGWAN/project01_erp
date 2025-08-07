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
</head>
<body>
	<div class="container mt-1 position-relative">
		<nav aria-label="breadcrumb">
		  <ol class="breadcrumb">
		    <li class="breadcrumb-item"><a href="<%=request.getContextPath()%>/headquater.jsp">Home</a></li>
		    <li class="breadcrumb-item"><a href="<%=request.getContextPath()%>/headquater.jsp?page=branch-admin/main.jsp">지점 관리</a></li>
			<li class="breadcrumb-item"><a href="<%=request.getContextPath()%>/headquater.jsp?page=branch-admin/list.jsp">지점 목록</a></li>
			<li class="breadcrumb-item"><a href="<%=request.getContextPath()%>/headquater.jsp?page=branch-admin/detail.jsp?num=<%=dto.getBranch_num()%>">지점 상세보기</a></li>
		    <li class="breadcrumb-item active" aria-current="page">직원 상세정보</li>
		  </ol>
		</nav>
	
		<h1 class="mb-4 text-center">회원 상세 정보</h1>
		<form action="${pageContext.request.contextPath }/branch-admin/roleupdate.jsp" method="get">
			<input type="hidden" name="returnUrl" value="<%=request.getContextPath()%>/headquater.jsp?page=branch-admin/detail.jsp?num=<%=dto.getBranch_num()%>">
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
							<td><%= dto.getUpdated_at()==null?"":dto.getUpdated_at() %></td>
						</tr>
					</table>	
				</div>
				
			</div>
			<button class="btn btn-sm btn-primary position-absolute" style="right:12.5%;" type="submit">수정</button>
		</form>		
	</div>	
</body>
</html>