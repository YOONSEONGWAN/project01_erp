<%@page import="test.dao.SalesDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    request.setCharacterEncoding("UTF-8");

    int salesId = Integer.parseInt(request.getParameter("salesId"));
    boolean isSuccess = SalesDao.getInstance().delete(salesId);

    String cpath = request.getContextPath();  // context path 미리 담기
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/branch-sales/delete.jsp</title>
</head>
<body>
    <script>
        alert("<%= isSuccess ? "삭제 성공!" : "삭제 실패!" %>");
        location.href = "<%= cpath %>/branch-sales/list.jsp";
    </script>
</body>
</html>