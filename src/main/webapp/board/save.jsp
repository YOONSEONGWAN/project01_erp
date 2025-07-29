<%@page import="dao.BoardDao"%>
<%@page import="dto.BoardDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String title = request.getParameter("title");
	String content = request.getParameter("content");
	String writer = (String)session.getAttribute("userName");
	String boardType = request.getParameter("boardType");
	
	// 로그인 여부 확인
		if (writer == null || writer.isEmpty()) {
	%>
		<script>
			alert("로그인이 필요합니다.");
			location.href = "<%=request.getContextPath()%>/user/loginform.jsp";
		</script>
	<%
			return;
		}
	// 먼저 DTO 객체 생성
	BoardDto dto=new BoardDto();
	dto.setWriter(writer);
	dto.setTitle(title);
	dto.setContent(content);
	dto.setBoardType(boardType); 
	
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
			location.href="view.jsp?num=<%= dto.getNum() %>";
		</script>
	<%}else{%>
		<p>
			글 저장실패!
			<a href="new-form.jsp">다시작성</a>
		</p>
	<%}%>
</div>
</body>
</html>