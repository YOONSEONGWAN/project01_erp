<%@page import="dao.CommentDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	// 삭제할 댓글번호
	int num=Integer.parseInt(request.getParameter("num"));
	
	// 리다일렉트 이동할때 필요한 원글의 글번호
	String parentNum=request.getParameter("parent_num");
	
	// dao 객체를 이용해서 삭제하고
	CommentDao.getInstance().delete(num);
	
	// 리다일렉트 이동 (절대경로로 이동하기에 cPath)
	String cPath=request.getContextPath(); // getContextPath( ): context 경로를 얻어냄 
	// board_type 파라미터 같이 넘겨주기
	String boardType = request.getParameter("board_type");
	response.sendRedirect(cPath + "/board/view.jsp?num=" + parentNum + "&board_type=" + boardType);
%> 
