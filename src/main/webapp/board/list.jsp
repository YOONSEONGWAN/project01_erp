<%@page import="org.apache.commons.lang3.StringUtils" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="dao.BoardDao"%>
<%@page import="dto.BoardDto"%>
<%@page import="java.util.List"%>

<%
  request.setCharacterEncoding("utf-8");

  String boardType = request.getParameter("board_type");
  if (boardType == null || boardType.trim().isEmpty()) {
      boardType = "NOTICE"; // 기본값
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
	
	String keyword = request.getParameter("keyword");
	// 만일 전달된 keyword가 없다면
	if(StringUtils.isEmpty(keyword)) {
		// board_type별 글 수 계산 
		totalRow=BoardDao.getInstance().getCountByType(boardType);
	}else{ // 있다면 
		 // TODO: 키워드 + 타입 동시 검색이 필요할 경우, 새로운 DAO 메소드 만들어야 함
		totalRow=BoardDao.getInstance().getCountByKeyword(boardType, keyword);
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
	dto.setBoard_type(boardType);
	
	// 만일 keyword 가 없다면
	List<BoardDto> list = null;
	if(StringUtils.isEmpty(keyword)){
		list = BoardDao.getInstance().selectPage(dto);
	}else{ 
		dto.setKeyword(keyword);
		list = BoardDao.getInstance().selectPageByKeyword(dto);
	}
  	
	// 본사 회원인지 판별할 수 있는 정보
	String branchId = (String) session.getAttribute("branchId");
	 boolean isBranchUser = branchId != null && !"HQ".equalsIgnoreCase(branchId);
	 boolean isHQ = "HQ".equalsIgnoreCase(branchId);
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>게시글 목록</title>
  <jsp:include page="/WEB-INF/include/resource.jsp"></jsp:include>
</head>
<body>	

  <div class="container">
  	
    
    <h2 class="mb-4 mt-3">게시글 목록</h2>
    
    <!-- 탭 메뉴 + 새 글 작성 버튼 한 줄 정렬 -->
	<div class="d-flex justify-content-between align-items-center mb-3 mt-3">
	
	    <!-- 탭 메뉴 -->
	    <ul class="nav nav-tabs">
	        <li class="nav-item">
	            <a class="nav-link <%= "NOTICE".equals(boardType) ? "active" : "" %>"
	               href="<%= "HQ".equalsIgnoreCase(branchId)
	                        ? request.getContextPath() + "/headquater.jsp?page=board/list.jsp?board_type=NOTICE"
	                        : request.getContextPath() + "/branch.jsp?page=board/list.jsp?board_type=NOTICE" %>">
	                공지사항</a>
	        </li>
	        <li class="nav-item">
	            <a class="nav-link <%= "QNA".equals(boardType) ? "active" : "" %>"
	               href="<%= "HQ".equalsIgnoreCase(branchId)
	                        ? request.getContextPath() + "/headquater.jsp?page=board/list.jsp?board_type=QNA"
	                        : request.getContextPath() + "/branch.jsp?page=board/list.jsp?board_type=QNA" %>">
	                문의사항</a>
	        </li>
	    </ul>
	
	    <!-- 새 글 작성 버튼 (하나만 조건 분기) -->
	    <% if (
	        ("HQ".equalsIgnoreCase(branchId) && "NOTICE".equalsIgnoreCase(boardType)) ||
	        ("QNA".equalsIgnoreCase(boardType) && isBranchUser)
	    ) { %>
	        <a class="btn text-white"
	           style="background-color: #003366 !important;"
	           href="<%= "HQ".equalsIgnoreCase(branchId)
	                    ? request.getContextPath() + "/headquater.jsp?page=board/new-form.jsp&board_type=" + boardType
	                    : request.getContextPath() + "/branch.jsp?page=board/new-form.jsp&board_type=" + boardType %>">
	            + 새 글 작성
	        </a>
	    <% } %>
	
	</div>
    
    <!-- 공지사항 검색창 -->
	<% if ("NOTICE".equalsIgnoreCase(boardType)) { %>
	   <form action="<%= "HQ".equalsIgnoreCase((String)session.getAttribute("branchId")) 
                ? request.getContextPath() + "/headquater.jsp" 
                : request.getContextPath() + "/branch.jsp" %>" 
      		method="get" class="mb-4">
		    <input type="hidden" name="page" value="board/list.jsp">
		    <input type="hidden" name="board_type" value="NOTICE">
		    <div class="input-group">
		        <input type="text" name="keyword" value="<%= keyword != null ? keyword : "" %>" class="form-control" placeholder="공지사항 검색">
		        <button type="submit" class="btn btn-outline-secondary">검색</button>
		    </div>
		</form>
	<% } %>
	
	<!-- 문의사항 검색창 -->
	<% if ("QNA".equalsIgnoreCase(boardType)) { %>
	   <form action="<%= "HQ".equalsIgnoreCase((String)session.getAttribute("branchId")) 
                ? request.getContextPath() + "/headquater.jsp" 
                : request.getContextPath() + "/branch.jsp" %>" 
      		method="get" class="mb-4">
		    <input type="hidden" name="page" value="board/list.jsp">
		    <input type="hidden" name="board_type" value="QNA">
		    <div class="input-group">
		        <input type="text" name="keyword" 
		               value="<%= keyword != null ? keyword : "" %>"
		               class="form-control" 
		               placeholder="문의사항 검색">
		        <button type="submit" class="btn btn-outline-secondary">검색</button>
		    </div>
		</form>
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
			<a href="<%= "HQ".equalsIgnoreCase((String)session.getAttribute("branchId")) 
			              ? "headquater.jsp?page=board/view.jsp&num=" + dto2.getNum() + "&board_type=" + dto2.getBoard_type()
			              : "branch.jsp?page=board/view.jsp&num=" + dto2.getNum() + "&board_type=" + dto2.getBoard_type() %>">
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
        <td colspan="5" class="text-center">등록된 게시글이 없습니다.</td>
      </tr>
	  <% } %>
</tbody>
    </table>
    <!-- 페이징 처리 -->
    <ul class="pagination justify-content-center mt-2">
  <% if (startPageNum != 1) { %>
    <li class="page-item">
      <a class="page-link text-white"
         style="background-color: #003366;"
         href="<%= 
             "HQ".equalsIgnoreCase((String)session.getAttribute("branchId")) 
                 ? "headquater.jsp?page=board/list.jsp&pageNum=" + (startPageNum - 1) + "&board_type=" + boardType + "&keyword=" + (keyword != null ? keyword : "") 
                 : "branch.jsp?page=board/list.jsp?pageNum=" + (startPageNum - 1) + "&board_type=" + boardType + "&keyword=" + (keyword != null ? keyword : "") 
         %>">&lsaquo;</a>
    </li>
  <% } %>

  <% for (int i = startPageNum; i <= endPageNum; i++) { %>
    <li class="page-item <%= i == pageNum ? "active" : "" %>">
	  <a class="page-link"
	     style="<%= i == pageNum 
	                ? "background-color: #003366; color: white; border-color: #003366;" 
	                : "background-color: transparent; color: #003366; border: 1px solid #003366;" %>"
	     href="<%= 
	         "HQ".equalsIgnoreCase((String)session.getAttribute("branchId")) 
	             ? "headquater.jsp?page=board/list.jsp&pageNum=" + i + "&board_type=" + boardType + "&keyword=" + (keyword != null ? keyword : "") 
	             : "branch.jsp?page=board/list.jsp?pageNum=" + i + "&board_type=" + boardType + "&keyword=" + (keyword != null ? keyword : "") 
	     %>"><%= i %></a>
</li>
  <% } %>

  <% if (endPageNum < totalPageCount) { %>
    <li class="page-item">
      <a class="page-link text-white"
         style="background-color: #003366;"
         href="<%= 
             "HQ".equalsIgnoreCase((String)session.getAttribute("branchId")) 
                 ? "headquater.jsp?page=board/list.jsp&pageNum=" + (endPageNum + 1) + "&board_type=" + boardType + "&keyword=" + (keyword != null ? keyword : "") 
                 : "branch.jsp?page=board/list.jsp?pageNum=" + (endPageNum + 1) + "&board_type=" + boardType + "&keyword=" + (keyword != null ? keyword : "") 
         %>">&rsaquo;</a>
    </li>
  <% } %>
</ul>
  </div>
</body>
</html>