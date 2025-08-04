<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String thisPage=request.getParameter("thisPage");
	String userId=(String)session.getAttribute("userId");
	String branchId=(String)session.getAttribute("branchId");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/index/branchindex.jsp</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.7/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-LN+7fdVzj6u52u30Kp6M/trliBMCMKTyK833zpbD+pXdCLuTusPj697FH4R/5mcr" crossorigin="anonymous">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.7/dist/js/bootstrap.bundle.min.js" integrity="sha384-ndDqU0Gzau9qJ1lfW4pNLlhNTkCfHzAVBReH9diLvGRem5+R9g2FzA8ZGN954O5Q" crossorigin="anonymous"></script>
</head>
<body>
	<h1>지점 인덱스</h1>
	<nav class="navbar navbar-expand-md bg-success" data-bs-theme="dark">
		<div class="container">
			<a class="navbar-brand" href="${pageContext.request.contextPath }/">종복치킨</a>
			<button class="navbar-toggler" type="button"
				data-bs-toggle="collapse" data-bs-target="#navbarNav">
				<span class="navbar-toggler-icon"></span>
			</button>
			
				
	            <!-- 오른쪽 사용자 메뉴 -->
	            <ul class="navbar-nav">
                <%if (userId == null) {%>
	                <li class="nav-item">
	                    <a class="btn btn-outline-light btn-sm me-2"
	                       href="${pageContext.request.contextPath }/user2/loginform2.jsp">로그인</a>
	                </li>
	                <li class="nav-item">
	                    <a class="btn btn-warning btn-sm"
	                       href="${pageContext.request.contextPath }/user/signup-form.jsp">회원가입</a>
	                </li>
                <%}else {%>
	                <li class="nav-item  me-2">
					    <a class="nav-link  p-0"
					       href="${pageContext.request.contextPath}/user2/info2.jsp">
					        <strong><%= userId %></strong>
					    </a>
					</li>
	                <li class="nav-item me-2">
	                    <span class="navbar-text">Signed in</span>
	                </li>
	                <li class="nav-item">
	                    <a class="btn btn-danger btn-sm"
	                       href="${pageContext.request.contextPath }/user2/logout2.jsp">로그아웃</a>
	                </li>
                <%}%>
                </ul>
			</div>
	</nav>
	<ul>
	<li><a href="${pageContext.request.contextPath }/order/list.jsp">발주 관리 페이지</a></li>
	<li><a href="${pageContext.request.contextPath}/board/list.jsp">통합게시판</a></li>
	</ul>
	
	
	
</body>
</html>