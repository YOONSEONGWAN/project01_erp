<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	// 세션에서 로그인된 사용자 아이디 얻어오기
	String writer = (String)session.getAttribute("user_name");
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
			<!-- 작성자 (자동 입력, 수정 불가) -->
			<div class="mb-3">
				<label class="form-label">작성자</label>
				<input type="text" name="writer" class="form-control" value="<%=writer%>">
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
			<button type="submit" class="btn btn-primary">등록</button>
			<a href="${pageContext.request.contextPath}/board/list.jsp" class="btn btn-secondary">취소</a>
		</form>
	</div>
</body>
</html>