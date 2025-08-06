<%@page import="dao.HrmDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%
    // 삭제할 번호
    int num = Integer.parseInt(request.getParameter("num"));
    // DB 에서 삭제하고
    new HrmDao().deleteByNum(num);
    // 새로운 경로로 요청을 다시 하라고 응답
    String cPath = request.getContextPath();
    // 사이드바 있는 상태로 리스트 페이지로 리다이렉트
    response.sendRedirect(cPath + "/headquater.jsp?page=hrm/list.jsp");
%>    
