<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%

	//세션에 저장된 갑ㄴㅅ을 삭제하면 로그 아웃이다.
	//"userName" 이라는 키값으로 저장된 값을 삭제
	session.removeAttribute("userName");

	//응답하기
	


%>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/user/logout.jsp</title>
</head>
<body>
	<script>
		alert("로그아웃 되었습니다!");
		location.href = "${pageContext.request.contextPath }/";
		
	</script>
</body>
</html>