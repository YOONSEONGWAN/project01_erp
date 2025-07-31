<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/branch-admin/update.jsp</title>
</head>
<body>
	<div class="container">
		<h1>지점 등록 양식</h1>
		<form action="insert.jsp" method="post">
			<div>
				<label for="branchId">아이디</label>
				<input type="text" name="branchId" id="branchId" />
			</div>
			<div>
				<label for="name">지점 이름</label>
				<input type="text" name="name" id="name" />
			</div>
			<div>
				<label for="address">지점 주소</label>
				<input type="text" name="address" id="address" />
			</div>
			<div>
				<label for="phone">지점 연락처</label>
				<input type="text" name="phone" id="phone" />
			</div>
			<button type="submit">등록</button>
	</div>
</body>
</html>