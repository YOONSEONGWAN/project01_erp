<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>ERP 인덱스</title>
<style>
	body {
		background-color: #e9edf0;
		margin: 0;
		font-family: 'Noto Sans KR', sans-serif;
		display: flex;
		justify-content: center;
		align-items: center;
		height: 100vh;
	}

	.container {
		background-color: #ffffff;
		padding: 40px 60px;
		border-radius: 12px;
		box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
		text-align: center;
		width: 400px;
	}

	.logo {
		display: block;
		margin: 0 auto 30px;
		width: 250px;
	}

	.button-group {
		display: flex;
		flex-direction: column;
		gap: 16px;
	}

	.button-group a {
		display: block;
		padding: 14px 0;
		border-radius: 6px;
		background-color: #003366;
		color: white;
		text-decoration: none;
		font-size: 16px;
		font-weight: 500;
		box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
		transition: background-color 0.2s ease;
	}

	.button-group a:hover {
		background-color: #002244;
	}

	.title {
		font-size: 20px;
		font-weight: bold;
		color: #333333;
		margin-bottom: 25px;
	}
</style>
</head>
<body>


	<div class="container">
		<img src="${pageContext.request.contextPath}/images/JB_logo.png" alt="치킨 로고" class="logo">
		<div class="title">ERP 시스템 포털</div>
		<div class="button-group">
			<a href="${pageContext.request.contextPath}/userp/loginform.jsp">로그인</a>
			<a href="${pageContext.request.contextPath}/userp/signup-form.jsp">회원가입</a>
		</div>
	</div>


	<h1>종복치킨</h1>
	<a href="${pageContext.request.contextPath }/userp/signuppath.jsp">회원가입</a>
	<a href="${pageContext.request.contextPath }/userp/loginform.jsp">로그인</a>

</body>
</html>
