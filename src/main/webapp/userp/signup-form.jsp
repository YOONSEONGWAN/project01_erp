<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/userp/signup-form.jsp</title>
</head>
<body>
	<div class="container">
		<h1>회원가입 양식</h1>
		<form action="signup.jsp" method="post">
			<div>
				<label for="branchId">지점 번호</label>
				<input type="text" name="branchId" id="branchId"/>
			</div>
			<div>
				<label for="userId">아이디</label>
				<input type="text" name="userId" id="userId"/>
			</div>
			<div>
				<label for="password">비밀번호</label>
				<input type="text" name="password" id="password"/>
			</div>
			<div>
				<label for="userName">이름</label>
				<input type="text" name="userName" id="userName"/>
			</div>
			<button type="submit">가입</button>
		</form>
	</div>
</body>
</html>