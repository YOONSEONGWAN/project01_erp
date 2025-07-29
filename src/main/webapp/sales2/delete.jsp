<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="test.dao.SalesDao" %>
<%
    request.setCharacterEncoding("UTF-8");
    int salesId = Integer.parseInt(request.getParameter("salesId"));
    String branch = request.getParameter("branch");

    SalesDao dao = new SalesDao();
    boolean isSuccess = dao.delete(salesId);

    if (isSuccess) {
%>
    <script>
        alert("삭제 성공");
        location.href = "detail.jsp?branch=<%= branch %>";
    </script>
<%
    } else {
%>
    <script>
        alert("삭제 실패");
        history.back();
    </script>
<%
    }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/sales2/delete.jsp</title>
</head>
<body>
	
</body>
</html>