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
</head>
<body>
	<h1>지점 인덱스</h1>
	<a href="${pageContext.request.contextPath}/order/list.jsp">발주 관리 페이지</a>
	<a href="${pageContext.request.contextPath }/board/list.jsp">게시판</a>
	<a href="${pageContext.request.contextPath }/branch-sales/list.jsp">매출 통계</a>
	<a href="${pageContext.request.contextPath }/work-log/work-log.jsp">출근/퇴근</a>
</body>
</html>