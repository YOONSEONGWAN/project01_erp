<%@page import="dao.BranchDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	//GET 방식 파라미터로 전달되는 글번호를 읽어와서
	int num=Integer.parseInt(request.getParameter("num"));

	//DB 에서 해당글을 삭제하고
	boolean isSuccess=BranchDao.getInstance().deleteByNum(num);
	//응답한다
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/branch-admin/delete.jsp</title>
</head>
<body>
	<script>
		<%if(isSuccess){%>
			alert("삭제 했습니다!");
			location.href="<%=request.getContextPath()%>/headquater.jsp?page=branch-admin/list.jsp";
		<%}else{%>
			alert("삭제 실패했습니다!");
			location.href="<%=request.getContextPath()%>/headquater.jsp?page=branch-admin/detail.jsp?num=<%=num%>";
		<%}%>
		
		
		
	</script>
</body>
</html>