<%@page import="dao.BoardDao"%>
<%@page import="dto.BoardDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="dao.BoardDao"%>
<%@page import="dto.BoardDto"%>
<%@page import="java.util.List"%>
<%
	String boardType = request.getParameter("boardType");
	if (boardType == null || boardType.trim().isEmpty()) {
	    boardType = "QNA"; // 기본값
	}

	List<BoardDto> list = BoardDao.getInstance().getListByType(boardType);
	
%>
<%
    System.out.println("boardType 원본: [" + boardType + "]");
    System.out.println("boardType 길이: " + boardType.length());
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>게시판 목록</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="p-4">
  <div class="container">
    <h2 class="mb-4">종복치킨 게시판</h2>
	<p>현재 type 값: <%=boardType %></p>
	<%= "조회된 글 수: " + list.size() %><br>
    <!-- 카테고리 탭 -->
    <ul class="nav nav-tabs mb-3">
      <li class="nav-item">
        <a class="nav-link <%= "NOTICE".equals(boardType) ? "active" : "" %>" 
   			href="list.jsp?boardType=NOTICE">공지사항</a>

      </li>
      <li class="nav-item">
        <a class="nav-link <%= "QNA".equals(boardType) ? "active" : "" %>" 
   			href="list.jsp?boardType=QNA">문의사항</a>
      </li>
    </ul>
	<!-- 문의사항일 때만 새 글 작성 버튼 노출 -->
    <% if ("QNA".equalsIgnoreCase(boardType)) { %>
  	<div class="mb-3 text-end">
    	<a href="new-form.jsp?boardType=QNA" class="btn btn-success">+ 새 글 작성</a>
  	</div>
	<% } %>
    <!-- 게시글 목록 테이블 -->
    <table class="table table-bordered">
      <thead class="table-light">
        <tr>
          <th>번호</th>
          <th>제목</th>
          <th>작성자</th>
          <th>작성일</th>
        </tr>
      </thead>
      <tbody>
	  <%
	    if (list != null && !list.isEmpty()) {
	      for (BoardDto dto : list) {
	  %>
        <tr>
          <td><%= dto.getNum() %></td>
          <td><%= dto.getTitle() %></td>
          <td><%= dto.getWriter() %></td>
          <td><%= dto.getCreatedAt() %></td>
        </tr>
	  <%
	      }
	    } else {
	  %>
      <tr>
        <td colspan="4" class="text-center">등록된 게시글이 없습니다.</td>
      </tr>
	  <%
	    }
	  %>
</tbody>
    </table>
  </div>
</body>
</html>