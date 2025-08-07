<%@page import="dao.CommentDao"%>
<%@page import="dto.CommentDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	// 폼 전송되는 수정할 댓글의 정보를 얻어온다
	int num=Integer.parseInt(request.getParameter("num"));
	String content=request.getParameter("content");
	
	// 원글의 번호
	String boardNum=request.getParameter("board_num");
	
	String boardType = request.getParameter("board_type");
	
	
	CommentDto dto=new CommentDto();
	dto.setNum(num);
	dto.setContent(content);
	
	boolean isSuccess=CommentDao.getInstance().update(dto);
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/board/comment-update.jsp</title>
</head>
<body>
	<script>
		<%if(isSuccess) {%>
			alert("수정했습니다")
			 location.href = "<%= "HQ".equalsIgnoreCase((String)session.getAttribute("branchId")) 
						        ? request.getContextPath() + "/headquater.jsp?page=board/view.jsp&num=" + boardNum + "&board_type=" + boardType 
						        : request.getContextPath() + "/branch.jsp?page=board/view.jsp&num=" + boardNum + "&board_type=" + boardType 
  							  %>";
		<%}else{%>
			alert("수정실패!")
			location.href = "<%= "HQ".equalsIgnoreCase((String)session.getAttribute("branchId")) 
						        ? request.getContextPath() + "/headquater.jsp?page=board/view.jsp&num=" + boardNum + "&board_type=" + boardType 
						        : request.getContextPath() + "/branch.jsp?page=board/view.jsp&num=" + boardNum + "&board_type=" + boardType 
  							  %>";
		<%} %>
	</script>
</body>
</html>