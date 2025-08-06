<%@page import="dto.UserDtoAdmin"%>
<%@page import="dao.UserDaoAdmin"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String returnUrl = request.getParameter("returnUrl");
	String role=request.getParameter("role");
	Long num=Long.parseLong(request.getParameter("num"));
	UserDtoAdmin dto = UserDaoAdmin.getInstance().getByNum(num);
	dto.setRole(role);
	
	boolean isSuccess = UserDaoAdmin.getInstance().update(dto);
	String msg = isSuccess ?
		      "등급 변경 성공" : "등급 변경 실패";
	session.setAttribute("alertMsg", msg);
	
	if (returnUrl == null || returnUrl.isEmpty()) {
	      returnUrl = "user-list.jsp"; // 기본 fallback
	}

	response.sendRedirect(returnUrl);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/branch-admin/roleupdate.jsp</title>
</head>
<body>

</body>
</html>