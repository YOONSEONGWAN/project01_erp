<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%-- /WEB-INF/include/branchnavbar.jsp --%>
<% 
	String thisPage = request.getParameter("thisPage");
	String userId = (String)session.getAttribute("userId");
%>