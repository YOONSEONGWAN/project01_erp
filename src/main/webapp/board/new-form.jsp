<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String writer = (String) session.getAttribute("userId");
    String branchId = (String) session.getAttribute("branchId");
    String boardType = request.getParameter("board_type");

    if (boardType == null || boardType.trim().isEmpty()) {
        boardType = "NOTICE";
    }

    if ("NOTICE".equalsIgnoreCase(boardType) && !"HQ".equalsIgnoreCase(branchId)) {
%>
    <script>
        alert("공지사항은 본사 회원만 작성할 수 있습니다.");
        history.back();
    </script>
<%
        return;
    }

    if ("QNA".equalsIgnoreCase(boardType) && "HQ".equalsIgnoreCase(branchId)) {
%>
    <script>
        alert("문의사항은 지점 회원만 작성할 수 있습니다.");
        history.back();
    </script>
<%
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>/board/new-form.jsp</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.7/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- ✅ Toast UI Editor CSS -->
    <link rel="stylesheet" href="https://uicdn.toast.com/editor/latest/toastui-editor.min.css" />
</head>
<body>
<div class="container mt-4">
    <h3 class="mb-4">새 글 작성</h3>

    <form action="${pageContext.request.contextPath}/board/save.jsp" method="post" id="saveForm">
        <input type="hidden" name="board_type" value="<%=boardType %>" />
        <input type="hidden" name="branch_id" value="<%=branchId %>" />
        <input type="hidden" name="user_id" value="<%=writer %>" />

        <!-- 작성자 -->
        <div class="mb-3">
            <label class="form-label">작성자</label>
            <input type="text" name="writer" class="form-control" value="<%=writer%>" readonly>
        </div>

        <!-- 제목 -->
        <div class="mb-3">
            <label class="form-label">제목</label>
            <input type="text" name="title" class="form-control" required>
        </div>

        <!-- ✅ Toast UI Editor 내용 입력 -->
        <div class="mb-3">
            <label class="form-label">내용</label>
            <div id="editor"></div>
            <!-- Toast UI Editor → 실제 서버로 전송될 값 -->
            <textarea name="content" id="hiddencontent" class="form-control" rows="10" style="display:none;"></textarea>
        </div>

        <!-- 버튼 -->
        <button type="submit" class="btn" style="background-color: #003366; color: white;">등록</button>
        <a href="<%= "HQ".equalsIgnoreCase((String)session.getAttribute("branchId")) 
				    ? request.getContextPath() + "/headquater.jsp?page=board/list.jsp&board_type=" + boardType 
				    : request.getContextPath() + "/branch.jsp?page=board/list.jsp&board_type=" + boardType 
				%>" class="btn btn-secondary">취소</a>
    </form>
</div>

<!-- ✅ Toast UI Editor JS -->
<script src="https://uicdn.toast.com/editor/latest/toastui-editor-all.min.js"></script>
<script src="https://uicdn.toast.com/editor/latest/i18n/ko-kr.js"></script>

<script>
    const editor = new toastui.Editor({
        el: document.querySelector('#editor'),
        height: '500px',
        initialEditType: 'wysiwyg',
        previewStyle: 'vertical',
        language: 'ko'
    });

    // 제출 시 content 내용을 textarea에 복사
    document.querySelector("#saveForm").addEventListener("submit", function () {
        const content = editor.getHTML();
        document.querySelector("#hiddencontent").value = content;
    });
</script>
</body>
</html>