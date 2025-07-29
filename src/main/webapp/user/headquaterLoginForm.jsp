<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String url = request.getParameter("url");

	if(url==null){
	
	String cPath = request.getContextPath();
	url=cPath+"/index/headquaterindex.jsp";
}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>headquaterLoginForm.jsp</title>
</head>
<body>
	<div class="container">
		<h1>로그인 양식</h1>
		<form action="headquaterLogin.jsp" method="post">
			<input type="hidden" name="url" value="<%=url %>" />
			<div>
				<label for="userId">아이디</label>
				<input type="text" name="userId" id="userId" />
			</div>
			<div>
				<label for="password">비밀번호</label>
				<input type="password" name="password" id="password" />
			</div>
			<button type="submit">로그인</button>
		</form>
	</div>
</body>
</html>