<%@page import="dto.HqBoardFileDto"%>
<%@page import="org.apache.commons.text.StringEscapeUtils"%>
<%@page import="dto.HqBoardDto"%>
<%@page import="dao.HqBoardDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    // get 방식 파라미터로 전달되는 글 번호 얻어내기
    //int num=Integer.parseInt(request.getParameter("num"));
	String numStr = request.getParameter("num");
	int num = 0;
	try {
	    num = Integer.parseInt(numStr);
	} catch(Exception e) {
	    out.println("<script>alert('잘못된 접근입니다.'); history.back();</script>");
	    return;
	}
    // DB 에서 해당 글의 자세한 정보를 얻어낸다.
    HqBoardDto dto=HqBoardDao.getInstance().getByNum(num);
    // 로그인 된 userName (null 가능성 있음)
    String userId=(String)session.getAttribute("userId");
    String userName=(String)session.getAttribute("userName");
    String role=(String)session.getAttribute("role");
    
    boolean isWriter = userId != null && userName.equals(dto.getWriter());
    boolean isAdmin = "admin".equalsIgnoreCase(role);
    boolean isKing = "king".equalsIgnoreCase(role) ;
    // 만일 본인 글 자세히 보기가 아니면 조회수를 1 증가시킨다.
    /*if(!dto.getWriter().equals(userName)){
        HqBoardDao.getInstance().addViewCount(num);
    }*/
    
    if(dto != null){
        // 본인 글이 아니면 조회수 증가
        if(!dto.getWriter().equals(userName)){
            HqBoardDao.getInstance().addViewCount(num);
        }
    } else {
        // 글이 존재하지 않는 경우
        out.println("<script>alert('존재하지 않는 게시글입니다.');history.back();</script>");
        return;
    }
    
    //로그인 여부를 알아내기
    boolean isLogin = userName == null ? false : true;
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/hqboard/hq-view.jsp</title>
<jsp:include page="/WEB-INF/include/resource.jsp"></jsp:include>
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
<style>
	/* ───────────── 기본 버튼, 헤더, 폰트, 유틸 ───────────── */
	
	/* 카드 헤더(본문 내용, 등) 스타일 */
	.card-header.bg-light {
	    background-color: #f8f9fa !important;
	    font-weight: bold;
	    font-size: 1.15rem;
	}
	
	/* 본사색 버튼(수정 등) */
	.btn-hq, .btn-hq:focus {
	    background-color: #224488;
	    border-color: #224488;
	    color: #fff;
	}
	.btn-hq:hover {
	    background-color: #1b326a;
	    border-color: #1b326a;
	    color: #fff;
	}
	
	/* 삭제 등 소프트 레드 버튼 */
	.btn-soft-danger, .btn-soft-danger:focus {
	    background-color: #ffe5e5;
	    border-color: #ffa3a3;
	    color: #e05252;
	}
	.btn-soft-danger:hover {
	    background-color: #ffb3b3;
	    border-color: #e05252;
	    color: #a51212;
	}
	
	/* 기타 버튼 라운드/패딩 */
	.btn-outline-primary, .btn-outline-danger {
	    border-radius: 0.5rem;
	    padding: 0.375rem 1rem;
	}
	
	/* 테이블 세로 정렬 */
	.table th, .table td {
	    vertical-align: middle !important;
	}
	
	/* 위아래 마진 유틸 */
	.my-5 {
	    margin-top: 3rem !important;
	    margin-bottom: 3rem !important;
	}
	
	/* 제목(h1/h3) 공통 스타일 */
	.h3.mb-4, h1.h3 {
	    font-size: 2rem;
	    font-weight: 600;
	    color: #222 !important;
	    margin-bottom: 1.5rem !important;
	}
	
	/* 넓이/간격/가운데 정렬 등 유틸 */
	.w-75 { width: 75% !important; }
	.gap-2 { gap: 0.5rem !important; }
	.mx-auto { margin-left: auto !important; margin-right: auto !important; }
	.btn-group-bottom { justify-content: flex-end; display: flex; gap: 0.5rem; }
	.btn-center { display: flex; justify-content: center; }
	.mt-5 { margin-top: 3rem !important; }
	.mb-5 { margin-bottom: 3rem !important; }
	.flex-center-between { display: flex; align-items: center; justify-content: space-between; gap: 2rem; }
	
	/* Prev/Next 네비 버튼 */
	.btn-prevnext {
	    min-width: 110px;
	    font-weight: 500;
	}
	.btn-prevnext:hover, .btn-prevnext:focus {
	    background-color: #224488;
	    color: #fff;
	    border-color: #224488;
	}
	
	/* 비활성 버튼 효과 
	.disabled {
	    pointer-events: none;
	    opacity: 0.6;
	}*/
	
	/* ───────────── 첨부파일 박스 관련 ───────────── */
	
	/* 첨부파일 전체 카드(입체/둥글게/배경) */
	.attachment-card {
	    border: 0;
	    border-radius: 0.95rem;
	    margin-top: 1.5rem;
	    background: linear-gradient(120deg,#fff 70%, #eaf3fb 100%);	
	    position: relative;
	}
	
	/* 첨부파일 카드 회사색 테두리 */
	.attachment-card:before {
	    content: "";
	    display: block;
	    position: absolute;
	    inset: 0;
	    border-radius: 0.95rem;
	    border: 2.5px solid #003366;
	    pointer-events: none;
	    opacity: 0.85;
	}
	
	/* 첨부파일 카드 내 제목(헤더) */
	.attachment-header {
	    padding: 0.7rem 1rem 0.5rem 1rem;
	    background: #f4f6fb;
	    font-weight: 600;
	    border-bottom: 1.5px solid #f0f1f6;
	    font-size: 1.1rem;
	    border-radius: 0.85rem 0.85rem 0 0;
	}
	
	/* 첨부파일 목록(ul) */
	.attachment-list {
	    padding: 0.9rem 1.2rem;
	    margin-bottom: 0;
	    list-style: none;
	}
	.attachment-list li {
	    margin-bottom: 0.3rem;
	}
	.attachment-list a {
	    text-decoration: underline;
	    color: #224488;
	    font-weight: 500;
	}
	.attachment-list a:hover {
	    color: #1b326a;
	    text-decoration: underline;
	}
	
	/* ───────────── HQ 정보 박스(상단 정보 테이블) ───────────── */
	
	/* 정보박스 우측정렬 래퍼 */
	.hq-info-box-wrap {
	    display: flex;
	    justify-content: flex-end;
	}
	
	/* 정보 테이블 박스: 고정폭/입체/회사색 테두리 */
	.hq-info-box {
	    min-width: 320px;
	    max-width: 430px;
	    width: 100%;
	    background: #fafbfe;
	    border: 2.2px solid #003366;
	    border-radius: 0.95rem;
	    padding: 1.7rem 2rem 1.1rem 2rem;
	    margin-bottom: 2.5rem;
	}
	/* 정보 테이블 라벨(왼쪽 th) */
	.hq-info-box th {
	    width: 90px;
	    background: #f5f6fa;
	    font-weight: 600;
	    color: #003366;
	    border: none;
	    text-align: right;
	    padding-right: 1rem;
	}
	/* 정보 테이블 값(td) */
	.hq-info-box td {
	    border: none;
	    background: transparent;
	    text-align: left;
	    color: #333;
	    padding-left: 0.5rem;
	}
	/* ───────────── 본문 내용 HQ박스 ───────────── */
	
	/* 본문내용 카드(테두리/둥글기/입체감) */
	.hq-content-box {
	    border: 2.2px solid #003366;
	    border-radius: 0.95rem;
	    background: #fff;
	    margin-top: 1.8rem;
	    overflow: hidden; /* 구분선, 둥근모서리 보정 */
	}
	
	/* 본문 헤더(강조/구분선/여백) */
	.hq-content-header {
	    padding: 0.9rem 1.2rem 0.5rem 1.2rem;
	    background: #f8fafd;
	    font-weight: bold;
	    font-size: 1.13rem;
	    border-bottom: 1.2px solid #003366; /* 회사색 */
	    letter-spacing: 0.01em;
	}
	
	/* 본문 내용 영역 */
	.hq-content-body {
	    padding: 1.4rem 1.6rem 1.2rem 1.6rem;
	    background: #fff;
	}
	
	/* ───────────── 반응형(모바일) ───────────── */
	@media (max-width: 600px) {
	  .hq-info-box { max-width: 98vw; padding: 1.1rem 0.7rem; }
	}

</style>
</head>
<body>
	<div class="container my-5">
	    <h1 class="h3 mb-4">게시글 상세보기</h1>
	    <!-- HQ 정보 박스: 우측 고정폭/테두리/입체감 -->
	    <div class="hq-info-box-wrap">
	      <table class="hq-info-box table table-borderless align-middle mb-0">
	          <tr>
	              <th>글 번호</th>
	              <td><%=num %></td>
	          </tr>
	          <tr>
	              <th>작성자</th>
	              <td><%=dto.getWriter() %></td>
	          </tr>
	          <tr>
	              <th>제목</th>
	              <td><%=dto.getTitle() %></td>
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
	    <!-- 본문 카드 -->
		<div class="hq-content-box">
		    <div class="hq-content-header">
		        <strong>본문 내용</strong>
		    </div>
		    <div class="hq-content-body">
		        <%=dto.getContent() %>
		    </div>
		</div>
	    <!-- 첨부파일 카드 스타일 -->
	    <div class="attachment-card">
	        <div class="attachment-header"><i class="bi bi-paperclip"></i> 첨부파일</div>
	        <ul class="attachment-list">
	        	<% if(dto.getFileList() != null && !dto.getFileList().isEmpty()) { 
	            	for (HqBoardFileDto file : dto.getFileList()) { %>
	                <li>
	                    <a href="${pageContext.request.contextPath }/test/download?orgFileName=<%=file.getOrgFileName()%>&saveFileName=<%=file.getSaveFileName()%>&fileSize=<%=file.getFileSize()%>">
	                        <i class="bi bi-file-earmark-arrow-down"></i> <%=file.getOrgFileName()%>
	                    </a>
	                </li>
	            	<% } 
	        	}else {%>
	        		<li class="text-secondary">첨부파일 없음</li>
				<% } %>
	        </ul>
	    </div>
	    <!-- 목록/이전/다음 버튼 -->
	    <div class="flex-center-between mt-5 mb-4">
	        <a class="btn btn-outline-secondary btn-prevnext <%=dto.getPrevNum()==0 ? "disabled":""%>"
	           href="<%=request.getContextPath()%>/headquater.jsp?page=hqboard/hq-view.jsp?num=<%=dto.getPrevNum() %>">
	            <i class="bi bi-arrow-left"></i> Prev
	        </a>
	        <a class="btn btn-secondary" href="<%=request.getContextPath()%>/headquater.jsp?page=hqboard/hq-list.jsp">
	            <i class="bi bi-list"></i> 목록
	        </a>
	        <a class="btn btn-outline-secondary btn-prevnext <%=dto.getNextNum()==0 ? "disabled":""%>"
	           href="<%=request.getContextPath()%>/headquater.jsp?page=hqboard/hq-view.jsp?num=<%=dto.getNextNum() %>">
	            Next <i class="bi bi-arrow-right"></i>
	        </a>
	    </div>
	    <!-- 수정/삭제 버튼 : 우측 정렬 -->
	    <% if(isWriter){ %>
	    <div class="btn-group-bottom mb-5">
	        <a class="btn btn-hq btn-sm" href="<%=request.getContextPath()%>/headquater.jsp?page=hqboard/hq-edit.jsp?num=<%=dto.getNum() %>">
	            <i class="bi bi-pencil"></i> 수정
	        </a>
	        <a class="btn btn-soft-danger btn-sm" href="<%=request.getContextPath()%>/hqboard/hq-delete.jsp?num=<%=dto.getNum() %>" onclick="return confirm('정말 삭제하시겠습니까?');">
	            <i class="bi bi-trash"></i> 삭제
	        </a>
	    </div>
	    <% } %>
	</div>
</body>
</html>
