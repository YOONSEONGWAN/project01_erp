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
	out.println("num 파라미터: [" + numStr + "]");
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
    String userName=(String)session.getAttribute("userId");
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
</head>
<body>
	<div class="container my-5">
	    <h1 class="h3 mb-4">게시글 상세보기</h1>
	    <div class="btn-group mb-3">
	        <a class="btn btn-outline-secondary <%=dto.getPrevNum()==0 ? "disabled":""%>" href="<%=request.getContextPath()%>/headquater.jsp?page=hqboard/hq-view.jsp?num=<%=dto.getPrevNum() %>">
	            <i class="bi bi-arrow-left"></i> Prev
	        </a>
	        <a class="btn btn-outline-secondary <%=dto.getNextNum()==0 ? "disabled":""%>" href="<%=request.getContextPath()%>/headquater.jsp?page=hqboard/hq-view.jsp?num=<%=dto.getNextNum() %>">
	            Next <i class="bi bi-arrow-right"></i>
	        </a>
	    </div>
	    <table class="table table-bordered align-middle w-75 mx-auto">
	        <tr>
	            <th>글 번호</th>
	            <td><%=num %></td>
	        </tr>
	        <tr>
	            <th>작성자</th>
	            <td>
	                <%=dto.getWriter() %>
	            </td>
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
	    <div class="card mt-4">
	        <div class="card-header bg-light"><strong>본문 내용</strong></div>
	        <div class="card-body p-3">
	            <%=dto.getContent() %>
	        </div>
	    </div>
	    <div class="mt-3">
	        <strong>첨부파일:</strong>
	        <ul class="list-unstyled">
	        	<% if(dto.getFileList() != null && !dto.getFileList().isEmpty()) { 
	            	for (HqBoardFileDto file : dto.getFileList()) { %>
	                <li>
	                    <a href="${pageContext.request.contextPath }/test/download?orgFileName=<%=file.getOrgFileName()%>&saveFileName=<%=file.getSaveFileName()%>&fileSize=<%=file.getFileSize()%>">
	                        <%=file.getOrgFileName()%>
	                    </a>
	                </li>
	            	<% } 
	        	}else {%>
	        		<li>첨부파일 없음</li>
				<% } %>
	        </ul>
	    </div>
	    <div class="d-flex gap-2 mt-4">
	        <a class="btn btn-secondary" href="<%=request.getContextPath()%>/headquater.jsp?page=hqboard/hq-list.jsp"><i class="bi bi-list"></i> 목록으로</a>
	        <% if(dto.getWriter().equals(userName)){ %>
	            <a class="btn btn-outline-primary" href="<%=request.getContextPath()%>/headquater.jsp?page=hqboard/hq-edit.jsp?num=<%=dto.getNum() %>"><i class="bi bi-pencil"></i> 수정</a>
	            <a class="btn btn-outline-danger" href="<%=request.getContextPath()%>/headquater.jsp?page=hqboard/hq-delete.jsp?num=<%=dto.getNum() %>" onclick="return confirm('정말 삭제하시겠습니까?');"><i class="bi bi-trash"></i> 삭제</a>
	        <% } %>
	    </div>
	</div>
</body>
</html>
