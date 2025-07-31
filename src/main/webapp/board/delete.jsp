<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="dao.BoardDao" %>
<%
	int num = Integer.parseInt(request.getParameter("num"));
	String writer = BoardDao.getInstance().getData(num).getWriter();
	String userName = (String) session.getAttribute("userName");

	if (!writer.equals(userName)) {
		response.sendError(HttpServletResponse.SC_FORBIDDEN, "남의 글 지우려고 하면 혼난다!");
		return;
	}

	boolean isDeleted = BoardDao.getInstance().deleteByNum(num);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/board/delete.jsp</title>
</head>
<body>
<% if (isDeleted) { %>
	<script>
		alert("삭제되었습니다.");
		location.href = "list.jsp?boardType=qna";
	</script>
<% } else { %>
	<p>삭제 실패. <a href="view.jsp?num=<%=num%>">돌아가기</a></p>
<% } %>
</body>
</html>