<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
String user_name = (String) session.getAttribute("user_name");
if (user_name != null) {
%>	
	<p><%= user_name %>님 안녕하세요!</p>
	
	<ul>
	 	<li><a href="${pageContext.request.contextPath }/user2/logout2.jsp">로그아웃</a></li>
	</ul>
<%} else {%>
	<li >
    <a href="${pageContext.request.contextPath }/user/loginform.jsp">로그인</a>
    </li>
    
    <li>
	<a href="${pageContext.request.contextPath }/user/signup-form.jsp">회원가입</a>
	</li>
    
<%} %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>인덱스페이지</title>
</head>
<body>
	<h1>종복치킨</h1>
	<a href="${pageContext.request.contextPath }/user/signup-form.jsp">회원가입</a>
	<a href="${pageContext.request.contextPath }/user/loginform.jsp">로그인</a>
	<a href="${pageContext.request.contextPath}/board/list.jsp">게시판</a>
</body>
</html>