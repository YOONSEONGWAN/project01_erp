<%@page import="java.util.List"%>
<%@page import="dto.HqBoardDto"%>
<%@page import="dao.HqBoardDao"%>
<%@page import="org.apache.tomcat.jakartaee.commons.lang3.StringUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%
	//검색 keyword 가 있는지 읽어온다.
	String keyword=request.getParameter("keyword"); // keyword는 null, " ", "검색어..."
	if(keyword==null){
		keyword="";
	}

	// 기본 페이지 번호는 1로 설정
	int pageNum=1;
	String strPageNum=request.getParameter("pageNum");
	// 전달되는 페이지 번호가 있다면
	if(strPageNum != null){
		// 해당 페이지 번호를 숫자로 변경해서 사용한다.
		pageNum=Integer.parseInt(strPageNum);
	}
	

	// 한 페이지에 몇개씩 표시할 것인지
	final int PAGE_ROW_COUNT=10;
	
	// 하단 페이지를 몇개씩 표시할 것인지 표시
	final int PAGE_DISPLAY_COUNT=5;
	
	// 보여줄 페이지의 시작 ROWNUM
	int startRowNum=1+(pageNum-1)*PAGE_ROW_COUNT; // 공차수열
	// 보여줄 페이지의 끝 ROWNUM
	int endRowNum=pageNum*PAGE_ROW_COUNT; // 등비수열
	
	//하단 시작 페이지 번호 (정수를 정수로 나누면 소수점이 버려진 정수가 나옴)
	int startPageNum = 1 + ((pageNum-1)/PAGE_DISPLAY_COUNT)*PAGE_DISPLAY_COUNT;
	//하단 끝 페이지 번호
	int endPageNum=startPageNum+PAGE_DISPLAY_COUNT-1;
		
	/*
		StringUtils 클래스의 isEmpty() static 메소드를 이용하면 문자열이 비어있는지 여부를 알 수 있다.
		null 또는 "" 의 빈 문자열은 비었다고 판단
		
		StringUtils.isEmpty(keyword)
		는
		keyword == null or "".equals(keyword)*/
	
	// 전체 글의 갯수 
	int totalRow= 0; // 기본값 설정
	if(StringUtils.isEmpty(keyword)){ // 전달된 키워드가 없으면
		totalRow=HqBoardDao.getInstance().getCount(); // 전체 글의 개수를 리턴
	}else{ // 전달된 키워드가 있다면 키워드가 있는 글의 갯수 리턴
		totalRow=HqBoardDao.getInstance().getCountByKeyword(keyword);
	}
	
	//전체 페이지의 갯수 구하기 (double.실수로 나눠야 소숫점의 실수로 나온다.)
	int totalPageCount=(int)Math.ceil(totalRow/(double)PAGE_ROW_COUNT);
	//끝 페이지 번호가 이미 전체 페이지 갯수보다 크게 계산되었다면 잘못된 값이다.
	if(endPageNum > totalPageCount){
		endPageNum=totalPageCount; //보정해 준다. 
	}	
	
	HqBoardDto dto=new HqBoardDto();
	dto.setStartRowNum(startRowNum);
	dto.setEndRowNum(endRowNum);
	
	// 글 목록에서
	List<HqBoardDto> list=null;
	// 만약 keyword 가 없다면
	if(StringUtils.isEmpty(keyword)){
		list=HqBoardDao.getInstance().selectPage(dto);
	}else{ // keyword 가 있다면 dto 에 keyword 담고 특정 키워드만 출력
		dto.setKeyword(keyword);
		list=HqBoardDao.getInstance().selectPageByKeyword(dto);
		}
	
%>
    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/hqboard/hq-list</title>
</head>
<body>
	<div class="container">
		<a href="${pageContext.request.contextPath }/index/headquaterindex.jsp"> 본사 메인 페이지로 이동</a>
		<a class="" href="hq-new-form.jsp">
			새 글 작성
			<i class="bi bi-pencil-square"></i>
		</a>
		<h1>게시글 목록입니다.</h1>
		<!-- 행 만들기 -->
		<div class="">
			<div class="">
				<!-- 검색어 입력 폼 -->
				<form action="hq-list.jsp" method="get">
					<div class="input-group">
						<input value="<%=StringUtils.isEmpty(keyword) ? "" : keyword  %>"  type="text" name="keyword" class="form-control" placeholder="검색어 입력..." />
						<button type="submit" class="">검색<i class="bi bi-search"></i></button>
					</div>
				</form><!-- 검색어 입력 폼 -->
				
			</div>
		</div>
		<table class=""><!-- 게시판 보드 THead, TBody -->
			<thead>
				<tr>
					<th>글 번호</th>
					<th>작성자</th>
					<th>제목</th>
					<th>조회수</th>
					<th>작성일</th>
				</tr>
			</thead>
			<tbody>
			<% if(list != null && !list.isEmpty()) { %>
				<% for(HqBoardDto tmp : list){ %>
					<tr>
						<td><%=tmp.getNum() %></td>
						<td><%=tmp.getWriter() %></td>
						<td>
							<a href="${pageContext.request.contextPath }/hqboard/hq-view.jsp?num=<%=tmp.getNum() %>">
								<%=tmp.getTitle() %>
							</a>
						</td>
						<td><%=tmp.getViewCount() %></td>
						<td><%=tmp.getCreatedAt() %></td>
					</tr>
				<% } %>
			<% } else { %>
				<tr>
					<td colspan="5">등록된 글이 없습니다.</td>
				</tr>
			<% } %>
			</tbody>
		</table>
		
		<ul class=""><!-- 페이징 처리 부분 -->
			<%if(startPageNum!=1){ %>
				<li class="">
					<a class=page-link href="hq-list.jsp?pageNum=<%=startPageNum-1%>&keyword=<%=keyword %>">&lsaquo;</a><!-- 이전페이지 -->
				</li>
			<%}else{ %>
				
			<%} %>
			
			<% for(int i=startPageNum; i<=endPageNum; i++){%>
				<li class="page-item">
					<a class="page-link <%=i==pageNum ? "active" : "" %>" href="hq-list.jsp?pageNum=<%=i %>&keyword=<%=keyword %>"><%=i %></a>
				</li>
			<%} %>
			<%if(endPageNum < totalPageCount){ %>
				<li class="page-item">
					<a class=page-link href="hq-list.jsp?pageNum=<%=endPageNum+1%>&keyword=<%=keyword %>">&rsaquo;</a><!-- 다음페이지 -->
				</li>
			<%}else{ %>
				
			<%} %>
			
		</ul>
		
	</div>
</body>
</html>