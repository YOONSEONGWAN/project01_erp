<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>signup-form.jsp</title>
</head>
<body>
	<div class="container">
	<h1>회원가입 양식</h1>
	<form action="signup.jsp" method="post">
		<div>
			<label for="userId">아이디</label>
			<input type="text" name="userId" id="userId" required />
		</div>
		<div>
			<label for="password">비밀번호</label>
			<input type="password" name="password" id="password" required />
		</div>


		<button type="submit">가입</button>
	</form>
</div>
</body>
</html>