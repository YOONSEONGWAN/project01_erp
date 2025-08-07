<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	// 세션에서 로그인된 사용자 아이디 얻어오기
	String writer = (String)session.getAttribute("userId");
	String branchId = (String) session.getAttribute("branchId");	

	// URL 로 직접접근 막기
	String boardType = request.getParameter("board_type");
	if (boardType == null || boardType.trim().isEmpty()) {
	    boardType = "NOTICE"; // 기본값
	}
	
	// 1. 공지사항 → 본사 아니면 차단
	if ("NOTICE".equalsIgnoreCase(boardType) && !"HQ".equalsIgnoreCase(branchId)) {
	%>
	  <script>
	    alert("공지사항은 본사 회원만 작성할 수 있습니다.");
	    history.back();
	  </script>
	<%
	    return;
	}

	// 2. 문의사항 → 본사면 차단
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
</head>
<body>
	<div class="container mt-4">
		<h3 class="mb-4">새 글 작성</h3>
		
		<form action="${pageContext.request.contextPath}/board/save.jsp" method="post">
			<input type="hidden" name="board_type" value="<%=boardType %>" />
			<input type="hidden" name="branch_id" value="<%=branchId %>" />
    		<input type="hidden" name="user_id" value="<%=writer %>" />
    		
			<!-- 작성자 (자동 입력, 수정 불가) -->
			<div class="mb-3">
			    <label class="form-label">작성자</label>
			    <input type="text" name="writer" class="form-control" value="<%=writer%>" readonly>
			</div>

			<!-- 제목 -->
			<div class="mb-3">
				<label class="form-label">제목</label>
				<input type="text" name="title" class="form-control" required>
			</div>

			<!-- 내용 -->
			<div class="mb-3">
				<label class="form-label">내용</label>
				<textarea name="content" class="form-control" rows="7" required></textarea>
			</div>

			<!-- 등록 버튼 -->
			<button type="submit" class="btn" style="background-color: #003366; color: white;">등록</button>
			<a href="${pageContext.request.contextPath}/board/list.jsp" class="btn btn-secondary">취소</a>
		</form>
	</div>
</body>
</html>