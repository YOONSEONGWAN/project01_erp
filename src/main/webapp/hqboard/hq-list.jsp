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
<jsp:include page="/WEB-INF/include/resource.jsp"></jsp:include>
<!-- Bootstrap Icons -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
<style>
	/* ───────────── HQ List 스타일 (본사색 통일 & 추가 요청 반영) ───────────── */
	
	/* 본사색 버튼 (새 글 등) */
	.btn-hq, .btn-hq:focus {
	    background-color: #003366;
	    border-color: #003366;
	    color: #fff;
	}
	.btn-hq:hover {
	    background-color: #002855;
	    border-color: #002855;
	    color: #fff;
	}
	
	/* 검색 버튼 본사색 hover */
	.btn-outline-secondary:hover, .btn-outline-secondary:focus {
	    background-color: #003366 !important;
	    border-color: #003366 !important;
	    color: #fff !important;
	}
	
	/* 테이블(리스트) 행, 열 */
	.table th, .table td {
	    vertical-align: middle !important;
	    font-size: 1.02rem;
	}
	.table th {
	    color: #003366;
	    background: #f2f5fa;
	    font-weight: 700;
	}
	.table-hover>tbody>tr:hover {
	    background: #eaf3fb;
	    transition: background 0.13s;
	}
	
	/* 제목(h1/h3) - 검정색 */
	.h3.mb-0 {
	    font-size: 2rem;
	    font-weight: 600;
	    color: #111 !important;
	    margin-bottom: 1.5rem !important;
	}
	
	/* 새 글 버튼 */
	.btn-new-post {
	    min-width: 140px;
	    font-size: 1.07rem;
	    font-weight: 500;
	}
	
	/* 검색폼 그룹 (검색창/버튼) */
	.input-group .form-control {
	    border-radius: 0.5rem 0 0 0.5rem;
	    font-size: 1.02rem;
	}
	.input-group .btn {
	    border-radius: 0 0.5rem 0.5rem 0;
	}
	
	/* 페이지네이션 HQ 컬러 */
	.pagination .active .page-link {
	    background-color: #003366;
	    border-color: #003366;
	    color: #fff;
	}
	.pagination .page-link {
	    color: #003366;
	    border-radius: 0.5rem !important;
	    font-weight: 500;
	}
	.pagination .page-link:hover {
	    background-color: #eaf3fb;
	    color: #003366;
	}
	
	/* 비활성화 버튼 */
	.disabled, .page-item.disabled .page-link {
	    pointer-events: none;
	    opacity: 0.6;
	    color: #adb5bd !important;
	    background: #f8fafd !important;
	}
	
	/* 마진, 컨테이너 */
	.my-5 { margin-top: 3rem !important; margin-bottom: 3rem !important; }
	.mx-auto { margin-left: auto !important; margin-right: auto !important; }
	.mb-4 { margin-bottom: 1.5rem !important; }
	.gap-2 { gap: 0.5rem !important; }
	
	/* 리스트 테이블과 페이지네이션 간격 */
	.mb-5px { margin-bottom: 32px !important; }
	
	/* 검색폼 우측정렬 */
	.search-bar-col {
	    display: flex;
	    justify-content: flex-end;
	}
	
	/* 검색폼 길이(PC col-4), 모바일은 꽉 채움 */
	@media (max-width: 991.98px) {
	  .search-bar-col { justify-content: flex-end; }
	}
	@media (max-width: 600px) {
	  .table th, .table td { font-size: 0.97rem; }
	  .h3.mb-0 { font-size: 1.24rem; }
	  .search-bar-col { justify-content: flex-end; }
	}
</style>
</head>
<body>
<div class="container my-5">
    <div class="row align-items-center mb-4">
        <div class="col-lg-6 col-md-6 col-12">
            <h1 class="h3 mb-0">게시글 목록</h1>
        </div>
        <div class="col-lg-6 col-md-6 col-12 d-flex justify-content-lg-end justify-content-md-end justify-content-start mt-3 mt-md-0">
            <a class="btn btn-hq btn-new-post" href="<%=request.getContextPath()%>/headquater.jsp?page=hqboard/hq-new-form.jsp">
                <i class="bi bi-pencil-square"></i> 새 글 작성
            </a>
        </div>
    </div>
    <div class="row justify-content-end mb-4">
        <div class="col-12 col-sm-8 col-md-6 col-lg-4 search-bar-col">
            <form action="<%=request.getContextPath()%>/headquater.jsp" method="get" style="width:100%;">
                <input type="hidden" name="page" value="hqboard/hq-list.jsp">
                <div class="input-group">
                    <input value="<%=keyword%>" type="text" name="keyword" class="form-control" placeholder="검색어 입력..."/>
                    <button type="submit" class="btn btn-outline-secondary"><i class="bi bi-search"></i> 검색</button>
                </div>
            </form>
        </div>
    </div>
    <div class="row">
        <div class="col-12">
            <table class="table table-hover align-middle text-center mb-5px">
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
        </div>
    </div>
    <nav class="mb-5">
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
    