<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인 선택 페이지</title>
<style>
	body {
		margin: 0;
		height: 100vh;
		display: flex;
		justify-content: center;
		align-items: center;
		background-color: #f0f2f5;
		font-family: 'Noto Sans KR', sans-serif;
	}

	.container {
		display: flex;
		gap: 40px;
	}

	.box {
	background-color: #002855; /* 진한 네이비 */
	padding: 60px 60px; /* 위아래 크게 */
	border-radius: 12px;
	box-shadow: 0 4px 15px rgba(0, 40, 85, 0.4);
	width: 200px;
	text-align: center;
	font-weight: 700;
	font-size: 20px;
	color: white;
	text-decoration: none;
	transition: background-color 0.3s ease, box-shadow 0.3s ease;
	display: flex;
	justify-content: center;
	align-items: center;
}

.box:hover {
	background-color: #001f3f; /* 더 진한 네이비 */
	box-shadow: 0 6px 25px rgba(0, 31, 63, 0.7);
	cursor: pointer;
	color: white;
}

</style>
</head>
<body>

	<div class="container">
		<a href="${pageContext.request.contextPath}/userp/hqlogin-form.jsp" class="box">본사 페이지</a>
		<a href="${pageContext.request.contextPath}/userp/branchlogin-form.jsp" class="box">지점 페이지</a>
	</div>

</body>
</html>
