<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>본사 로그인</title>
<style>
	body {
		margin: 0;
		height: 100vh;
		background-color: #f0f2f5;
		display: flex;
		justify-content: center;
		align-items: center;
		font-family: 'Noto Sans KR', sans-serif;
	}

	.container {
		background-color: white;
		padding: 40px 50px;
		border-radius: 12px;
		box-shadow: 0 6px 25px rgba(0, 40, 85, 0.2);
		width: 380px;
		box-sizing: border-box;
	}

	h1 {
		text-align: center;
		color: #002855;
		margin-bottom: 30px;
		font-weight: 700;
		font-size: 28px;
		letter-spacing: 1.2px;
	}

	form div {
		display: flex;
		flex-direction: column;
		margin-bottom: 20px;
		width: 100%;              /* 부모 div 너비 100% */
		box-sizing: border-box;   /* 패딩, 테두리 포함해서 크기 계산 */
	}

	label.form-label {
		margin-bottom: 8px;
		font-weight: 600;
		color: #001f3f;
		font-size: 16px;
		width: 100%;              /* 라벨도 부모 너비 꽉 채우기 */
		box-sizing: border-box;
	}

	input.form-control {
		width: 100%;              /* input 너비 꽉 채우기 */
		padding: 12px 15px;
		border: 1.5px solid #cbd5e1;
		border-radius: 8px;
		font-size: 16px;
		transition: border-color 0.3s ease;
		box-sizing: border-box;   /* 패딩, 테두리 포함해서 크기 계산 */
	}

	input.form-control:focus {
		border-color: #0056b3;
		outline: none;
		box-shadow: 0 0 6px #0056b3;
	}

	button {
		width: 100%;
		padding: 14px 0;
		background-color: #002855;
		color: white;
		border: none;
		border-radius: 10px;
		font-size: 18px;
		font-weight: 700;
		cursor: pointer;
		transition: background-color 0.3s ease, box-shadow 0.3s ease;
		box-sizing: border-box;
	}

	button:hover {
		background-color: #001f3f;
		box-shadow: 0 0 12px #001f3f;
	}
</style>
</head>
<body>
	<div class="container">
		<h1>본사 로그인 양식</h1>
		<form action="hqlogin.jsp" method="post">
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
