<%@page import="dao.BranchDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String branchId=BranchDao.getInstance().generate();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/branch-admin/update.jsp</title>
<jsp:include page="/WEB-INF/include/resource.jsp"></jsp:include>
</head>
<body>
	<div class="container">
		<nav aria-label="breadcrumb">
		  <ol class="breadcrumb">
		    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath }/index/headquaterindex.jsp">Home</a></li>
		    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath }/branch-admin/main.jsp">지점 관리</a></li>
		    <li class="breadcrumb-item active" aria-current="page">지점 등록</li>
		  </ol>
		</nav>
	
		<div class="row d-flex align-self-center align-items-center justify-content-center" style="min-height: 100vh;">
			<div class="col col-lg-5 col-md-6 mx-auto">
				<h1 class="text-center mb-5">지점 등록 양식</h1>
				<form action="insert.jsp" method="post">
				<div class="mb-3">
					<label class="form-label" for="branchId">지점 아이디</label>
					<input class="form-control" type="text" name="branchId" id="branchId" value="<%=branchId%>" readonly />
					<div id="branchIdHelp" class="form-text text-muted" style="font-size: 0.75rem;">지점 아이디는 수정할 수 없습니다</div>
				</div>
				<div>
					<label class="form-label" for="name">지점 이름</label>
					<input class="form-control" type="text" name="name" id="name" />
				</div>
				<div class="mb-3">
					<label class="form-label" for="address">지점 주소</label>
					<input class="form-control" type="text" name="address" id="address" />
				</div>
				<div class="mb-3">
					<label class="form-label" for="phone">지점 연락처</label>
					<input class="form-control" type="text" name="phone" id="phone" />
				</div>
				<div class="text-end mt-2">
					<button class="btn btn-primary btn-sm" type="submit">등록</button>
				</div>
				
			</div>
		</div>
		
	</div>
</body>
</html>