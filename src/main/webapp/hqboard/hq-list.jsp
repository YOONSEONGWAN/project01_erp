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
<!-- Bootstrap CSS CDN -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<!-- Bootstrap Icons -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
<!-- "본사꾸미기" 커스텀 CSS (복붙만 하면 끝!) -->
<style>
.card-header.bg-light {
    background-color: #f8f9fa !important;
    font-weight: bold;
    font-size: 1.15rem;
}
.btn-outline-primary, .btn-outline-danger {
    border-radius: 0.5rem;
    padding: 0.375rem 1rem;
}
.table th, .table td {
    vertical-align: middle !important;
}
.my-5 {
    margin-top: 3rem !important;
    margin-bottom: 3rem !important;
}
.h3.mb-0 {
    font-size: 2rem;
    font-weight: 600;
    color: #224488;
    margin-bottom: 1.5rem !important;
}
.mx-auto {
    margin-left: auto !important;
    margin-right: auto !important;
}
.gap-2 {
    gap: 0.5rem !important;
}
.disabled {
    pointer-events: none;
    opacity: 0.6;
}
.pagination .active .page-link {
    background-color: #224488;
    border-color: #224488;
    color: #fff;
}
.pagination .page-link {
    color: #224488;
}
.pagination .page-link:hover {
    background-color: #e9ecef;
    color: #224488;
}
</style>
</head>
<body>
<div class="container my-5">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1 class="h3 mb-0">게시글 목록</h1>
        <a class="btn btn-primary" href="<%=request.getContextPath()%>/headquater.jsp?page=hqboard/hq-new-form.jsp">
            <i class="bi bi-pencil-square"></i> 새 글 작성
        </a>
    </div>
    <form action="<%=request.getContextPath()%>/headquater.jsp" method="get" class="mb-4">
        <input type="hidden" name="page" value="hqboard/hq-list.jsp">
        <div class="input-group">
            <input value="<%=keyword%>" type="text" name="keyword" class="form-control" placeholder="검색어 입력..."/>
            <button type="submit" class="btn btn-outline-secondary"><i class="bi bi-search"></i> 검색</button>
        </div>
    </form>
    <table class="table table-hover align-middle text-center">
        <thead class="table-light">
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
                    <td><%=tmp.getNum()%></td>
                    <td><%=tmp.getWriter()%></td>
                    <td class="text-start">
                        <a class="link-dark" href="<%=request.getContextPath()%>/headquater.jsp?page=hqboard/hq-view.jsp?num=<%=tmp.getNum()%>">
                            <%=tmp.getTitle()%>
                        </a>
                    </td>
                    <td><%=tmp.getViewCount()%></td>
                    <td><%=tmp.getCreatedAt()%></td>
                </tr>
            <% } %>
        <% } else { %>
            <tr>
                <td colspan="5" class="text-secondary">등록된 글이 없습니다.</td>
            </tr>
        <% } %>
        </tbody>
    </table>
    <nav>
        <ul class="pagination justify-content-center">
        <% if(startPageNum != 1) { %>
            <li class="page-item">
                <a class="page-link" href="<%=request.getContextPath()%>/headquater.jsp?page=hqboard/hq-list.jsp?pageNum=<%=startPageNum-1%>&keyword=<%=keyword%>">&lsaquo;</a>
            </li>
        <% } %>
        <% for(int i=startPageNum; i<=endPageNum; i++){ %>
            <li class="page-item <%=i==pageNum ? "active" : ""%>">
                <a class="page-link" href="<%=request.getContextPath()%>/headquater.jsp?page=hqboard/hq-list.jsp?pageNum=<%=i%>&keyword=<%=keyword%>"><%=i%></a>
            </li>
        <% } %>
        <% if(endPageNum < totalPageCount) { %>
            <li class="page-item">
                <a class="page-link" href="<%=request.getContextPath()%>/headquater.jsp?page=hqboard/hq-list.jsp?pageNum=<%=endPageNum+1%>&keyword=<%=keyword%>">&rsaquo;</a>
            </li>
        <% } %>
        </ul>
    </nav>
</div>
</body>
</html>
