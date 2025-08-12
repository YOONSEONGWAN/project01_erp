<%@page import="dao.BoardDao"%>
<%@page import="dto.BoardDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
	String title = request.getParameter("title");
	String content = request.getParameter("content");
	String writer = (String)session.getAttribute("userId");
	String branchId = (String)session.getAttribute("branchId");
	String board_type = request.getParameter("board_type");

	// 접근 제한 로직: board_type에 따라 작성자 권한 제한
	if ("NOTICE".equalsIgnoreCase(board_type)) {
	    if (!"HQ".equalsIgnoreCase(branchId)) {
%>
			<script>
			  alert("공지사항은 본사 회원만 작성할 수 있습니다.");
			  history.back();
			</script>
<%
			return;
	    }
	} else if ("QNA".equalsIgnoreCase(board_type)) {
	    if ("HQ".equalsIgnoreCase(branchId)) {
%>
			<script>
			  alert("문의사항은 지점 회원만 작성할 수 있습니다.");
			  history.back();
			</script>
<%
			return;
	    }
	} else {
%>
		<script>
		  alert("잘못된 게시판 유형입니다.");
		  history.back();
		</script>
<%
		return;
	}
%>
<% 
	// 먼저 DTO 객체 생성
	BoardDto dto=new BoardDto();
	dto.setWriter(writer);
	dto.setTitle(title);
	dto.setContent(content);
	dto.setBoard_type(board_type); 
	dto.setBranch_id(branchId);
	dto.setUser_id(writer);

	int num = BoardDao.getInstance().getSequence(board_type); // 시퀀스 호출
	dto.setNum(num); // 글 번호 설정
	boolean isSuccess=BoardDao.getInstance().insert(dto);
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/board/save.jsp</title>
</head>
<body>
<div class="container">
	<%if(isSuccess){%>
		<script>
			alert("저장했습니다");
			location.href="<%= 
			    request.getContextPath() + (
			        "HQ".equalsIgnoreCase((String)session.getAttribute("branchId")) 
			        ? "/headquater.jsp?page=board/view.jsp&num=" + num + "&board_type=" + board_type
			        : "/branch.jsp?page=board/view.jsp&num=" + num + "&board_type=" + board_type
			    )
			%>";
		</script>
	<%}else{%>
		<p>글 저장실패! <a href="new-form.jsp">다시작성</a></p>
	<%}%>
</div>
</body>
</html>