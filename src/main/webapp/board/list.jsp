<%@page import="org.apache.commons.lang3.StringUtils" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="dao.BoardDao"%>
<%@page import="dto.BoardDto"%>
<%@page import="java.util.List"%>

<%
  request.setCharacterEncoding("utf-8");

  String board_type = request.getParameter("board_type");
  
  if (board_type == null || board_type.trim().isEmpty()) {
      board_type = "QNA"; // 기본값
  }

  List<BoardDto> list = BoardDao.getInstance().getListByType(board_type);
  request.setAttribute("list", list);
 
 String keyword=request.getParameter("keyword");
 if(keyword==null){
		keyword="";
	}
	//기본 페이지 번호는 1로 설정
	int pageNum=1;
	// 페이지 번호를 읽어와서
	String strPageNum=request.getParameter("pageNum");
	// 전달되는 페이지 번호가 있다면 (null 이 아니라면)
	if(strPageNum != null){
		// 해당 페이지 번호를 숫자로 변경해서 사용한다.
		pageNum=Integer.parseInt(strPageNum);
	}
	
	// 현 페이지에 몇개씩 표시할 것인지
	final int PAGE_ROW_COUNT=5;
	
	// 하단 페이지를 몇개씩 표시할 것인지
	final int PAGE_DISPLAY_COUNT=5;
	
	// 보여줄 페이지의 시작 ROWNUM 
	int startRowNum=1+(pageNum-1)*PAGE_ROW_COUNT; //공차수열
	// 보여줄 페이지의 끝 ROWNUM
	int endRowNum=pageNum*PAGE_ROW_COUNT; // 등비수열 
	
	
	//하단 시작 페이지 번호 (정수를 정수로 나누면 소수점이 버려진 정수가 나온다)
	int startPageNum = 1 + ((pageNum-1)/PAGE_DISPLAY_COUNT)*PAGE_DISPLAY_COUNT;
	//하단 끝 페이지 번호
	int endPageNum=startPageNum+PAGE_DISPLAY_COUNT-1;
	
	// 전체 글의 갯수
	int totalRow=0;
	// 만일 전달된 keyword가 없다면
	if(StringUtils.isEmpty(keyword)) {
		// board_type별 글 수 계산 
		totalRow=BoardDao.getInstance().getCountByType(board_type);
	}else{ // 있다면 
		 // TODO: 키워드 + 타입 동시 검색이 필요할 경우, 새로운 DAO 메소드 만들어야 함
		totalRow=BoardDao.getInstance().getCountByKeyword(keyword);
	}
	
	//전체 페이지의 갯수 구하기
	int totalPageCount=(int)Math.ceil(totalRow/(double)PAGE_ROW_COUNT);
	//끝 페이지 번호가 이미 전체 페이지 갯수보다 크게 계산되었다면 잘못된 값이다.
	if(endPageNum > totalPageCount){
		endPageNum=totalPageCount; //보정해 준다. 
	}	
	
	
	// dto 에 select 할 row 의 정보를 담고
	BoardDto dto=new BoardDto();
	dto.setStartRowNum(startRowNum);
	dto.setEndRowNum(endRowNum);
	dto.setBoard_type(board_type);
	
	// 만일 keyword 가 없다면
	if(StringUtils.isEmpty(keyword)){
		list = BoardDao.getInstance().selectPage(dto);
	}else{ // keyword 가 있다면
		// dto 에 keyword 를 담고
		dto.setKeyword(keyword);
		// 키워드에 해당하는 글 목록을 얻어낸다. 
		list = BoardDao.getInstance().selectPageByKeyword(dto);
	}
  
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
          <th>조회수</th>
          <th>작성일</th>
        </tr>
      </thead>
      <tbody>
	  <%
	    if (list != null && !list.isEmpty()) {
	      for (BoardDto dto2 : list) {
	  %>
        <tr>
          <td><%= dto2.getNum() %></td>
          <td>
		      <a href="view.jsp?num=<%= dto2.getNum() %>&board_type=<%= dto2.getBoard_type() %>">
			    <%= dto2.getTitle() %>
			  </a>
    	  </td>
          <td><%= dto2.getWriter() %></td>
           <td><%= dto2.getView_count() %></td>
          <td><%= dto2.getCreated_at() %></td>
        </tr>
	  <%}
	  }else{ %>
      <tr>
        <td colspan="4" class="text-center">등록된 게시글이 없습니다.</td>
      </tr>
	  <% } %>
</tbody>
    </table>
    <ul class="pagination justify-content-center mt-2">
				<%-- startPageNum 이 1이 아닐때 이전 page 가 존재하기 때문에... --%>
				<%if(startPageNum != 1){ %>
					<li class="page-item">
					  <a class="page-link text-light bg-success"
					     href="list.jsp?pageNum=<%=startPageNum-1 %>&keyword=<%=keyword %>&board_type=<%=board_type %>">&lsaquo;</a>
					</li>
				<%} %>		
					
				<%for(int i=startPageNum; i<=endPageNum ; i++){ %>
					<li class="page-item">
						<a class="page-link text-light bg-success <%= i==pageNum ? "active":"" %>" href="list.jsp?pageNum=<%=i %>&keyword=<%=keyword %>"><%=i %></a>
					</li>
				<%} %>
				
				<%-- endPageNum 이 totalPageCount 보다 작을때 다음 page 가 있다 --%>		
				<%if(endPageNum < totalPageCount){ %>
					<li class="page-item">
				      <a class="page-link text-light bg-success"
				         href="list.jsp?pageNum=<%=endPageNum + 1%>&keyword=<%=keyword%>&board_type=<%=board_type%>">&rsaquo;</a>
				    </li>
				<%} %>	
			</ul>
  </div>
</body>
</html>