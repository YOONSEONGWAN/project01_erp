<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="dao.BoardDao"%>
<%@page import="dto.BoardDto"%>
<%
    int num = Integer.parseInt(request.getParameter("num"));
    String boardType = request.getParameter("board_type");

    BoardDto dto = BoardDao.getInstance().getData(num, boardType);
    String title = dto.getTitle();
    String content = dto.getContent(); // 이미 HTML 상태일 가능성 높음
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>글 수정</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.7/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Toast UI Editor CSS -->
    <link rel="stylesheet" href="https://uicdn.toast.com/editor/latest/toastui-editor.min.css" />
</head>
<body>
<div class="container mt-4">
    <h3 class="mb-4">글 수정하기</h3>

    <form action="${pageContext.request.contextPath}/board/edit.jsp" method="post" id="editForm">
        <input type="hidden" name="num" value="<%=num %>" />
        <input type="hidden" name="board_type" value="<%=boardType %>" />

        <!-- 제목 -->
        <div class="mb-3">
            <label class="form-label">제목</label>
            <input type="text" name="title" class="form-control" value="<%=title%>" required>
        </div>

        <!-- Toast UI Editor -->
        <div class="mb-3">
            <label class="form-label">내용</label>
            <div id="editor"></div>
            <textarea name="content" id="hiddencontent" class="form-control" rows="10" style="display: none;"></textarea>
        </div>

        <button type="submit" class="btn" style="background-color: #003366 !important; color: white;">수정</button>
        <a href="<%= "HQ".equalsIgnoreCase((String)session.getAttribute("branchId")) 
				    ? request.getContextPath() + "/headquater.jsp?page=board/view.jsp&num=" + num + "&board_type=" + boardType 
				    : request.getContextPath() + "/branch.jsp?page=board/view.jsp&num=" + num + "&board_type=" + boardType 
				%>" class="btn btn-secondary">취소</a>
    </form>
</div>

<!-- Toast UI JS -->
<script src="https://uicdn.toast.com/editor/latest/toastui-editor-all.min.js"></script>
<script src="https://uicdn.toast.com/editor/latest/i18n/ko-kr.js"></script>

<script>
    const editor = new toastui.Editor({
        el: document.querySelector('#editor'),
        height: '500px',
        initialEditType: 'wysiwyg',
        previewStyle: 'vertical',
        language: 'ko',
        initialValue: `<%=content.replace("\"", "\\\"").replace("\r", "").replace("\n", "\\n")%>`
    });

    document.querySelector("#editForm").addEventListener("submit", function () {
        const content = editor.getHTML();
        document.querySelector("#hiddencontent").value = content;
    });
</script>
</body>
</html>