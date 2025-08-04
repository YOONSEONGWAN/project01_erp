<%@page import="dao.BoardDao"%>
<%@page import="dto.BoardDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="dao.BoardDao"%>
<%@page import="dto.BoardDto"%>
<%@page import="java.util.List"%>

<%
  request.setCharacterEncoding("utf-8");

  String board_type = request.getParameter("board_type");
  System.out.println("전달받은 board_type: " + board_type);
  if (board_type == null || board_type.trim().isEmpty()) {
      board_type = "QNA"; // 기본값
  }
  System.out.println("최종 board_type: " + board_type);

  List<BoardDto> list = BoardDao.getInstance().getListByType(board_type);
  request.setAttribute("list", list);
  System.out.println("최종 조회된 글 수: " + list.size());
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>게시판 목록</title>
  <jsp:include page="/WEB-INF/include/resource.jsp"></jsp:include>
</head>
<body>
	<jsp:include page="/WEB-INF/include/branchnavbar.jsp">
		<jsp:param value="board" name="thisPage"/>
	</jsp:include>
  <div class="container">
    <h2 class="mb-4">종복치킨 게시판</h2>
	<p>현재 type 값: <%=board_type %></p>
	<%= "조회된 글 수: " + list.size() %><br>
	
    <!-- 카테고리 탭 -->
    <ul class="nav nav-tabs mb-3">
      <li class="nav-item">
        <a class="nav-link <%= "NOTICE".equals(board_type) ? "active" : "" %>" 
   			href="list.jsp?board_type=NOTICE">공지사항</a>
      </li>
      
      <li class="nav-item">
        <a class="nav-link <%= "QNA".equals(board_type) ? "active" : "" %>" 
   			href="list.jsp?board_type=QNA">문의사항</a>
      </li>
    </ul>
    
	<!-- 문의사항일 때만 새 글 작성 버튼 노출 -->
    <% if ("QNA".equalsIgnoreCase(board_type)) { %>
  	<div class="mb-3 text-end">
    	<a href="new-form.jsp?board_type=QNA" class="btn btn-success">+ 새 글 작성</a>
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
          <td><%= dto.getCreated_at() %></td>
        </tr>
	  <%}
	  }else{ %>
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