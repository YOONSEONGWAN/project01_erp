<%@page import="org.apache.commons.text.StringEscapeUtils"%>
<%@page import="dto.HqBoardDto"%>
<%@page import="dao.HqBoardDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	// get 방식 파라미터로 전달되는 글 번호 얻어내기
	int num=Integer.parseInt(request.getParameter("num"));
	// DB 에서 해당 글의 자세한 정보를 얻어낸다. 
	HqBoardDto dto=HqBoardDao.getInstance().getByNum(num);
	// 로그인 된 userName (null 가능성 있음)
	String userName=(String)session.getAttribute("userName");
	// 만일 본인 글 자세히 보기가 아니면 조회수를 1 증가시킨다. 
	if(!dto.getWriter().equals(userName)){
		HqBoardDao.getInstance().addViewCount(num);
	}

	//로그인 여부를 알아내기
	boolean isLogin = userName == null ? false : true;
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/hqboard/hq-view.jsp</title>
</head>
<body>
	<div class="container">
		<h1>게시글 상세보기</h1>
		<div class="btn group mb-2">
			<a class=" <%=dto.getPrevNum()==0 ? "disabled":"" %>" href="view.jsp?num=<%=dto.getPrevNum() %>">
				<i class="bi bi-arrow-left"></i>
				Prev
			</a>
			<a class=" <%=dto.getNextNum()==0 ? "disabled":"" %>" href="view.jsp?num=<%=dto.getNextNum() %>">
				Next
				<i class="bi bi-arrow-right"></i>
			</a>
		</div>
		<table class="">
			<tr>
				<th>글 번호</th>
				<td><%=num %></td>
			</tr>
			<tr>
				<th>작성자</th>
				<td>
				<%if(dto.getProfileImage()==null){ %>
						<i style="font-size:100px;" " class=""></i>
				<%}else{ %>
					<img src="${pageContext.request.contextPath }/upload/<%=dto.getProfileImage() %>"
						style="width:100px; height:100px; border-radius:50%;"  />
				<%} %>
				<%=dto.getWriter() %>
				</td>
			</tr>
			<tr>
				<th>제목</th>
				<td><%=StringEscapeUtils.escapeHtml4(dto.getTitle()) %></td>
			</tr>
			<tr>
				<th>조회수</th>
				<td><%=dto.getViewCount() %></td>
			</tr>
			<tr>
				<th>작성일</th>
				<td><%=dto.getCreatedAt() %></td>
			</tr>
		</table>
	</div>
</body>
</html>