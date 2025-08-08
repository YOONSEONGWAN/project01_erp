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
<title>/branch-admin/list.jsp</title>
<jsp:include page="/WEB-INF/include/resource.jsp"></jsp:include>

<!-- 부트스트랩 + 스타일 -->
<style>
    /* 버튼 기본: 남색 */
    .btn-primary {
        background-color: #003366 !important;
        border-color: #003366 !important;
        color: white !important;
        font-weight: 500;
        border-radius: 6px;
        box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
    }
    .btn-primary:hover {
        background-color: #002244 !important;
        border-color: #002244 !important;
        color: white !important;
    }

    /* 페이지네이션 기본 */
    .pagination .page-link {
        color: #003366 !important;
        border-color: #003366 !important;
    }
    .pagination .page-item.active .page-link {
        background-color: #003366 !important;
        border-color: #003366 !important;
        color: white !important;
    }
    .pagination .page-link:hover {
        background-color: #002244 !important;
        border-color: #002244 !important;
        color: white !important;
    }

    /* 지점명 링크 */
    a.text-primary {
        color: #003366 !important;
        font-weight: 600;
        text-decoration: none;
    }
</style>
</head>
<body>

<div class="container mt-4">
    <!-- Breadcrumb -->
    <nav aria-label="breadcrumb">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="<%=request.getContextPath()%>/headquater.jsp?page=index/headquaterindex.jsp">홈</a></li>
            <li class="breadcrumb-item active" aria-current="page">지점 관리</li>
            <li class="breadcrumb-item active" aria-current="page">지점 목록</li>
        </ol>
    </nav>

    <!-- 제목 + 검색 -->
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h3 class="fw-bold">지점 목록</h3>
        <form action="<%=request.getContextPath()%>/headquater.jsp" method="get" class="d-flex align-items-center">
		    <input type="hidden" name="page" value="branch-admin/list.jsp" />
		    <select name="status" class="form-select me-2" style="max-width: 120px;">
		        <option value="all" <%= "all".equals(status) ? "selected" : "" %>>전체</option>
		        <option value="운영중" <%= "운영중".equals(status) ? "selected" : "" %>>운영중</option>
		        <option value="휴업" <%= "휴업".equals(status) ? "selected" : "" %>>휴업</option>
		        <option value="폐업" <%= "폐업".equals(status) ? "selected" : "" %>>폐업</option>
		    </select>
		    <input value="<%=StringUtils.isEmpty(keyword) ? "" : keyword %>" type="text" name="keyword"
		           class="form-control me-2" placeholder="지점 이름 or 아이디 입력..." style="max-width: 220px;" />
			<button type="submit"
			        class="btn btn-primary me-1 d-inline-block text-nowrap"
			        style="height: 38px; min-width: 72px; padding-top: 6px; padding-bottom: 6px; font-size: 14px;">
			    검색
			</button>
			<a class="btn btn-outline-secondary px-3 py-2 d-inline-block text-nowrap"
			   style="height: 38px;"
			   href="<%=request.getContextPath()%>/headquater.jsp?page=branch-admin/list.jsp">초기화</a>
		</form>
    </div>

    <!-- 테이블 -->
    <table class="table table-hover align-middle">
        <thead class="table-secondary">
        <tr>
            <th>지점명</th>
            <th>주소</th>
            <th>전화번호</th>
            <th>담당자</th>
            <th>운영 상태</th>
        </tr>
        </thead>
        <tbody>
        <% for(BranchDto tmp : list) { %>
            <tr>
                <td>
                    <a href="<%=request.getContextPath()%>/headquater.jsp?page=branch-admin/detail.jsp?num=<%=tmp.getNum()%>"
                       class="text-primary"><%= tmp.getName() %></a>
                </td>
                <td><%= tmp.getAddress() %></td>
                <td><%= tmp.getPhone() %></td>
                <td><%= tmp.getUserName() %></td>
                <td><%= tmp.getStatus() %></td>
            </tr>
        <% } %>
        </tbody>
    </table>

    <!-- 페이지네이션 -->
    <nav class="mt-4">
        <ul class="pagination justify-content-center">
            <% if(startPageNum != 1) { %>
                <li class="page-item">
                    <a class="page-link" href="<%=request.getContextPath()%>/headquater.jsp?page=branch-admin/list.jsp&pageNum=<%=startPageNum-1%>&keyword=<%=keyword%>&status=<%=status%>">&lsaquo;</a>
                </li>
            <% } %>

            <% for(int i = startPageNum; i <= endPageNum; i++) { %>
                <li class="page-item <%= i == pageNum ? "active" : "" %>">
                    <a class="page-link" href="<%=request.getContextPath()%>/headquater.jsp?page=branch-admin/list.jsp&pageNum=<%=i%>&keyword=<%=keyword%>&status=<%=status%>"><%=i%></a>
                </li>
            <% } %>

            <% if(endPageNum < totalPageCount) { %>
                <li class="page-item">
                    <a class="page-link" href="<%=request.getContextPath()%>/headquater.jsp?page=branch-admin/list.jsp&pageNum=<%=endPageNum+1%>&keyword=<%=keyword%>&status=<%=status%>">&rsaquo;</a>
                </li>
            <% } %>
        </ul>
    </nav>
</div>

</body>
</html>
