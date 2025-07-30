<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/user/signup-form2.jsp</title>
</head>
<body>
	<div class="container">
	<h1>회원가입 양식</h1>
	<form action="signup.jsp" method="post">
		<div>
			<label for="user_id">아이디</label>
			<input type="text" name="user_id" id="user_id" required />
		</div>
		<div>
			<label for="user_name">이름</label>
			<input type="text" name="user_name" id="user_name" required />
		</div>
		<div>
			<label for="password">비밀번호</label>
			<input type="password" name="password" id="password" required />
		</div>
		<div>
			<label for="branch_id">지점 번호</label>
			<input type="text" name="branch_id" id="branch_id" placeholder="HQ or BC-001" required />
		</div>
		<div>
			<label for="myLocation">개인 주소</label>
			<input type="text" name="myLocation" id="myLocation" required />
		</div>
		<div>
			<label for="phoneNum">전화번호</label>
			<input type="text" name="phoneNum" id="phoneNum" required />
		</div>
		<div>
			<label for="grade">직급:</label>
		    <select name="grade" id="grade">
		        <option value="본사">본사</option>
		        <option value="지점장">지점장</option>
		    </select>
		</div>
		<button type="submit">가입</button>
	</form>
</div>
</body>
</html>