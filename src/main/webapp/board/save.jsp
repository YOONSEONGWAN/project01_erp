<%@page import="dao.BoardDao"%>
<%@page import="dto.BoardDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
System.out.println("✅ 세션 userId: " + session.getAttribute("userId"));
System.out.println("✅ 세션 branchId: " + session.getAttribute("branchId"));
%>
<%
	String title = request.getParameter("title");
	String content = request.getParameter("content");
	String writer = (String)session.getAttribute("userId");
	String branchId = (String)session.getAttribute("branchId");
	String board_type = request.getParameter("board_type");
	
	// 지점 회원인지 확인
	if (branchId == null || branchId.trim().isEmpty()) {
		board_type = "QNA";
%>
	<script>
	 alert("지점 회원만 글을 작성할 수 있습니다.");
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
	
	int num=BoardDao.getInstance().getSequence();
	dto.setNum(num);
	
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
			location.href="view.jsp?num=<%=dto.getNum()%>&board_type=<%=dto.getBoard_type()%>";
		</script>
	<%}else{%>
		<p>글 저장실패! <a href="new-form.jsp">다시작성</a></p>
	<%}%>
</div>
</body>
</html>