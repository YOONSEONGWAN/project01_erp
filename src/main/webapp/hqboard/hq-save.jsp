<%@page import="dto.HqBoardDto"%>
<%@page import="dao.HqBoardDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	// 폼 전송되는 title 과 content
	String title=request.getParameter("title");
	String content=request.getParameter("content");
	// 글 작성자는 세션 객체로부터 얻어낸다. db에 로그인이 없어서 현재는 작성 불가
	String writer=(String)session.getAttribute("userName");
	HqBoardDto dto=new HqBoardDto();
	// 글 번호를 미리 얻어낸다
	int num=HqBoardDao.getInstance().getSequence();
	// 글 번호도 dto 에 담음
	dto.setNum(num);
	// DB 에 저장하기
	
	dto.setWriter(writer);
	dto.setTitle(title);
	dto.setContent(content);
	boolean isSuccess=HqBoardDao.getInstance().insert(dto);
	// 응답하기
	
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/hqboard/hq-save.jsp</title>
</head>
<body>
<div class="container">
	<%if(isSuccess){ %>
		<script>
			alert("저장했습니다");
			location.href="hq-view.jsp?num=<%=num %>";
		</script>
	<%}else{%>
		<p>
			글 저장 실패!
			<a href="hq-new-form.jsp">다시 작성하기</a>
		</p>
	<%} %>
</div>			
	
</body>
</html>