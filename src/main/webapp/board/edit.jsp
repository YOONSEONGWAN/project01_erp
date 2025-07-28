<%@page import="dao.BoardDao"%>
<%@page import="dto.BoardDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>


<%
  request.setCharacterEncoding("UTF-8");

  // 수정할 글 번호 얻기
  int num = Integer.parseInt(request.getParameter("num"));

  // 게시글 정보 읽어오기
  BoardDto dto = BoardDao.getInstance().getData(num);
%>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>/board/edit.jsp</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
  <div class="container mt-4">
    <h3 class="mb-4">✏ 글 수정</h3>

    <form action="update.jsp" method="post">
      <!-- 글 번호 (수정 대상 식별용, 숨김 처리) -->
      <input type="hidden" name="num" value="<%=dto.getNum()%>">

      <!-- boardType도 같이 전달 (hidden 처리) -->
      <input type="hidden" name="boardType" value="<%=dto.getBoardType()%>">

      <!-- 작성자 (수정 불가) -->
      <div class="mb-3">
        <label class="form-label">작성자</label>
        <input type="text" class="form-control" value="<%=dto.getWriter()%>" readonly>
      </div>

      <!-- 제목 -->
      <div class="mb-3">
        <label class="form-label">제목</label>
        <input type="text" name="title" class="form-control" value="<%=dto.getTitle()%>" required>
      </div>

      <!-- 내용 -->
      <div class="mb-3">
        <label class="form-label">내용</label>
        <textarea name="content" class="form-control" rows="7" required><%=dto.getContent()%></textarea>
      </div>

      <!-- 버튼 -->
      <button type="submit" class="btn btn-primary">수정 완료</button>
      <a href="view.jsp?num=<%=dto.getNum()%>" class="btn btn-secondary">취소</a>
    </form>
  </div>
</body>
</html>