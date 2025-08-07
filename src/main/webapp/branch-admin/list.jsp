<%@page import="java.util.List"%>
<%@page import="dto.BranchDto"%>
<%@page import="dao.BranchDao"%>
<%@page import="org.apache.tomcat.jakartaee.commons.lang3.StringUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	//검색 keyword 가 있는지 읽어와 본다.
	String keyword=request.getParameter("keyword");
	if(keyword==null){
		keyword=""; // 이렇게 써주면 StringUtils.isEmpty() 가 필요 없음
	}
	
	// 상태(status) 파라미터 읽어오기
	String status = request.getParameter("status");
	if (status == null || "all".equals(status) || status.isEmpty()) {
	    status = "all"; 
	}
	
	//기본 페이지 번호는 1 로 설정하고 
	int pageNum=1;
	//페이지 번호를 읽어와서 
	String strPageNum=request.getParameter("pageNum");
	//전달되는 페이지 번호가 있다면 
	if(strPageNum != null){
		//해당 페이지 번호를 숫자로 변경해서 사용한다. 
		pageNum=Integer.parseInt(strPageNum);
	}
	
	//한 페이지에 몇개씩 표시할 것인지
	final int PAGE_ROW_COUNT=10;
	
	//하단 페이지를 몇개씩 표시할 것인지
	final int PAGE_DISPLAY_COUNT=5;

	//보여줄 페이지의 시작 ROWNUM
	int startRowNum=1+(pageNum-1)*PAGE_ROW_COUNT; //공차수열
	//보여줄 페이지의 끝 ROWNUM
	int endRowNum=pageNum*PAGE_ROW_COUNT; //등비수열 
	
	//하단 시작 페이지 번호 (정수를 정수로 나누면 소수점이 버려진 정수가 나온다)
	int startPageNum = 1 + ((pageNum-1)/PAGE_DISPLAY_COUNT)*PAGE_DISPLAY_COUNT;
	//하단 끝 페이지 번호
	int endPageNum=startPageNum+PAGE_DISPLAY_COUNT-1;
	
	//전체 글의 갯수 
	int totalRow=0;
	BranchDao dao = BranchDao.getInstance();

	// 조건에 따라 분기하여 전체 row의 갯수를 얻어온다.
	boolean isKeywordEmpty = StringUtils.isEmpty(keyword);
	boolean isStatusAll = "all".equals(status);

	if (isKeywordEmpty && isStatusAll) { // 1. 키워드 X, 상태 X
	    totalRow = dao.getCount();
	} else if (!isKeywordEmpty && isStatusAll) { // 2. 키워드 O, 상태 X
	    totalRow = dao.getCountByKeyword(keyword);
	} else if (isKeywordEmpty && !isStatusAll) { // 3. 키워드 X, 상태 O
	    totalRow = dao.getCountByStatus(status);
	} else { // 4. 키워드 O, 상태 O
	    totalRow = dao.getCountByKeywordAndStatus(keyword, status);
	}
	
	//전체 페이지의 갯수 구하기
	int totalPageCount=(int)Math.ceil(totalRow/(double)PAGE_ROW_COUNT);
	//끝 페이지 번호가 이미 전체 페이지 갯수보다 크게 계산되었다면 잘못된 값이다.
	if(endPageNum > totalPageCount){
		endPageNum=totalPageCount; //보정해 준다. 
	}	
	
	//dto 에 select 할 row 의 정보를 담고 
	BranchDto dto=new BranchDto();
	dto.setStartRowNum(startRowNum);
	dto.setEndRowNum(endRowNum);
		
	//글목록
	List<BranchDto> list =null;

	// 조건에 따라 분기하여 목록을 얻어온다.
	if (isKeywordEmpty && isStatusAll) { // 1. 키워드 X, 상태 X
	    list = dao.selectPage(dto);
	} else if (!isKeywordEmpty && isStatusAll) { // 2. 키워드 O, 상태 X
	    dto.setKeyword(keyword);
	    list = dao.selectPageByKeyword(dto);
	} else if (isKeywordEmpty && !isStatusAll) { // 3. 키워드 X, 상태 O
	    list = dao.selectPageByStatus(dto, status);
	} else { // 4. 키워드 O, 상태 O
	    dto.setKeyword(keyword);
	    list = dao.selectPageByKeywordAndStatus(dto, status);
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/board/list.jsp</title>
<jsp:include page="/WEB-INF/include/resource.jsp"></jsp:include>
</head>
<body>
	<div class="container mt-1">
		<nav aria-label="breadcrumb">
		  <ol class="breadcrumb">
		    <li class="breadcrumb-item"><a href="<%=request.getContextPath()%>/headquater.jsp">Home</a></li>
		    <li class="breadcrumb-item"><a href="<%=request.getContextPath()%>/headquater.jsp?page=branch-admin/main.jsp">지점 관리</a></li>
		    <li class="breadcrumb-item active" aria-current="page">지점 목록</li>
		  </ol>
		</nav>
		
		<h1 class="text-center">지점 목록</h1>
		<div class="row">
			<div class="col-lg-4 col-md-6 w-75 mx-auto text-end">
				<form action="<%=request.getContextPath()%>/headquater.jsp" method="get">
					<input type="hidden" name="page" value="branch-admin/list.jsp" />
					<select name="status">
		                <option value="all" <%= "all".equals(status) ? "selected" : "" %>>전체</option>
		                <option value="운영중" <%= "운영중".equals(status) ? "selected" : "" %>>운영중</option>
		                <option value="휴업" <%= "휴업".equals(status) ? "selected" : "" %>>휴업</option>
		                <option value="폐업" <%= "폐업".equals(status) ? "selected" : "" %>>폐업</option>
		            </select>
					<input value="<%=StringUtils.isEmpty(keyword) ? "" : keyword %>" type="text" name="keyword" placeholder="지점 이름 or 아이디 입력..." />
					<button class="btn btn-outline-primary btn-sm" type="submit">검색</button>
					<a class="btn btn-outline-primary btn-sm" href="<%=request.getContextPath()%>/headquater.jsp?page=branch-admin/list.jsp">초기화</a>					
				</form>
			</div>
		</div>
		<table class="table table-bordered w-75 mx-auto mt-2">
		<thead>
			<tr>
				<th>지점명</th>
				<th>주소</th>
				<th>전화번호</th>
				<th>담당자</th>
				<th>운영 상태</th>
			</tr>
		</thead>
		<tbody>
			<%for(BranchDto tmp:list){ %>
				<tr>
					<td>
						<a href="<%=request.getContextPath()%>/headquater.jsp?page=branch-admin/detail.jsp?num=<%=tmp.getNum() %>"><%=tmp.getName() %></a>
					</td> 
					<td><%=tmp.getAddress() %></td>
					<td><%=tmp.getPhone() %></td>
					<td><%=tmp.getUserName() %></td>
					<td><%=tmp.getStatus() %></td>
				</tr>
			<%} %>	
		</tbody>
	</table>	
	<ul class="pagination d-flex justify-content-center">
		<%-- startPageNum 이 1이 아닐때 이전 page 가 존재하기 때문에... --%>
		<%if(startPageNum != 1){ %>
			<li class="page-item">
				<a class="page-link" href="<%=request.getContextPath()%>/headquater.jsp?page=branch-admin/list.jsp?pageNum=<%=startPageNum-1 %>&keyword=<%=keyword%>&status=<%=status%>">&lsaquo;</a>
			</li>
		<%} %>			
		<%for(int i=startPageNum; i<=endPageNum ; i++){ %>
			<li class="page-item">
				<a class="page-link <%= i==pageNum ? "active":"" %>" href="<%=request.getContextPath()%>/headquater.jsp?page=branch-admin/list.jsp?pageNum=<%=i %>&keyword=<%=keyword%>&status=<%=status%>"><%=i %></a>
			</li>
		<%} %>
		<%-- endPageNum 이 totalPageCount 보다 작을때 다음 page 가 있다 --%>		
		<%if(endPageNum < totalPageCount){ %>
			<li class="page-item">
				<a class="page-link" href="<%=request.getContextPath()%>/headquater.jsp?page=branch-admin/list.jsp?pageNum=<%=endPageNum+1 %>&keyword=<%=keyword%>&status=<%=status%>">&rsaquo;</a>
			</li>
		<%} %>	
	</ul>	
	</div>	
</body>
</html>