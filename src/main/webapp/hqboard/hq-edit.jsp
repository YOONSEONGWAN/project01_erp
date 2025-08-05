<%@page import="java.util.List"%>
<%@page import="dto.HqBoardFileDto"%>
<%@page import="dao.HqBoardDao"%>
<%@page import="dto.HqBoardDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    // 수정 할 글의 정보를 얻어와서 
    int num = Integer.parseInt(request.getParameter("num"));
    HqBoardDto dto = HqBoardDao.getInstance().getByNum(num);
    List<HqBoardFileDto> fileList = dto.getFileList(); // 첨부파일 목록
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/hqboard/hq-edit.jsp</title>
<!-- Toast UI Editor CSS/JS 필요시 include 추가 -->
<link rel="stylesheet" href="https://uicdn.toast.com/editor/latest/toastui-editor.min.css" />
<script src="https://uicdn.toast.com/editor/latest/toastui-editor-all.min.js"></script>
<script src="https://uicdn.toast.com/editor/latest/i18n/ko-kr.js"></script>
</head>
<body>
	<div class="container my-5">
	    <h1 class="h3 mb-4">글 수정</h1>
	    <form action="hq-update.jsp" method="post" id="editForm" enctype="multipart/form-data">
	        <div class="mb-3">
	            <label for="num" class="form-label">글 번호</label>
	            <input type="text" class="form-control" name="num" id="num" value="<%=dto.getNum() %>" readonly/>
	        </div>
	        <div class="mb-3">
	            <label for="writer" class="form-label">작성자</label>
	            <input type="text" class="form-control" name="writer" id="writer" value="<%=dto.getWriter() %>" readonly/>
	        </div>
	        <div class="mb-3">
	            <label for="title" class="form-label">제목</label>
	            <input type="text" class="form-control" name="title" id="title" value="<%=dto.getTitle() %>" />
	        </div>
	        <div class="mb-3">
	            <label for="editor" class="form-label">내용</label>
	            <div id="editor"></div>
	            <textarea class="form-control" name="content" id="hiddencontent" style="display:none;"><%=dto.getContent() %></textarea>
	        </div>
	        <% if (fileList != null && !fileList.isEmpty()) { %>
	        <div class="mb-3">
	            <strong>첨부파일:</strong>
	            <ul class="list-unstyled">
	                <% for (HqBoardFileDto file : fileList) { %>
	                    <li>
	                        <a href="${pageContext.request.contextPath }/test/download?orgFileName=<%=file.getOrgFileName()%>&saveFileName=<%=file.getSaveFileName()%>&fileSize=<%=file.getFileSize()%>">
	                            <%=file.getOrgFileName()%>
	                        </a>
	                        <a class="text-danger ms-2" href="hq-file-delete.jsp?fileNum=<%=file.getNum()%>&boardNum=<%=dto.getNum()%>" onclick="return confirm('이 파일을 삭제할까요?');">[삭제]</a>
	                    </li>
	                <% } %>
	            </ul>
	        </div>
	        <% } %>
	        <div class="mb-3">
	            <label class="form-label">파일 추가</label>
	            <input type="file" class="form-control" name="myFile" multiple>
	            <small class="text-muted">새로운 파일 첨부, 여러 개 가능</small>
	        </div>
	        <div class="d-flex gap-2">
	            <button class="btn btn-primary" type="submit">수정 확인</button>
	            <button type="reset" class="btn btn-outline-secondary">리셋</button>
	        </div>
	    </form>
	</div>
</body>
</html>
