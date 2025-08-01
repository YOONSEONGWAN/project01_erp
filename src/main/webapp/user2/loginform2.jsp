<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	//GET 형식파라미터 url 이라는 이름으로 전달 되는 값이 있는지 읽어와 본다
	String url = request.getParameter("url");
	if(url == null){
		url = request.getContextPath() + "/index.jsp"; // 기본 이동 경로
	}
		
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>loginform.jsp</title>
</head>
<body>

	<div class="container">
		<h1>로그인 양식</h1>
		<form action="login2.jsp" method="post">
			<%-- 로그인 성공후에 이동할 url 정보를 추가로 form 전송되도록 한다 --%>
			<input type="hidden" name="url" value="<%=url%>"/>
			<div class="col-auto">
				<label for="userName" class="form-label">이름</label>
				<input type="text" name="userName" id="userName" class="form-control"/>
			</div>
			
			<div class="col-auto">
				<label for="password" class="form-label">비밀번호</label>
				<input type="password" name="password" id="password" class="form-control"/>
			</div>
			<button type="submit" class="btn btn-primary">로그인</button>
		</form>	
	</div>
	
</body>
</html>