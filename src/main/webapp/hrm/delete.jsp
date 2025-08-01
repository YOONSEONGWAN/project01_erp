
<%@page import="dao.HrmDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%
	// 삭제할 번호
	int num = Integer.parseInt(request.getParameter("num"));
	// DB 에서 삭제하고
	new HrmDao().deleteByNum(num);
	// 새로운 경로로 요청을 다시 하라고 응답
	String cPath=request.getContextPath();
	// HttpServletResponse 객체의 메소드를 이용해서 책 목록 페이지를 다시 요청하도록 한다 (페이지 refresh 효과)
	response.sendRedirect(cPath+"/hrm/list.jsp");
%>    
