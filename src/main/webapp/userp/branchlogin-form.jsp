<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/userp/branchlogin-form.jsp</title>
</head>
<body>
	<div class="container">
		<h1>로그인</h1>
		<form action="branchlogin.jsp" method="post">
			<div>
				<label for="branchId" class="form-label">지점 코드</label>
				<input type="text" name="branchId" id="branchId" class="form-control" required/>
			</div>
			<div>
				<label for="userId" class="form-label">아이디</label>
				<input type="text" name="userId" id="userId" class="form-control" required/>
			</div>
			<div>
				<label for="password" class="form-label">비밀번호</label>
				<input type="password" name="password" id="password" class="form-control" required/>
			</div>
			<button type="submit">로그인</button>
		</form>
	</div>
	
</body>
</html>