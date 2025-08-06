<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="dao.BoardDao" %>
<%@ page import="dto.BoardDto" %>

<%
    int num = Integer.parseInt(request.getParameter("num"));
    String board_type = request.getParameter("board_type");

    BoardDto dto = BoardDao.getInstance().getData(num, board_type);
    if (dto == null) {
%>
    <script>
        alert("존재하지 않는 글입니다.");
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
    <title>글 수정</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="p-4">
<div class="container">
    <h2>글 수정</h2>
    <form action="edit.jsp" method="post">
        <input type="hidden" name="num" value="<%= dto.getNum() %>">
        <input type="hidden" name="board_type" value="<%= dto.getBoard_type() %>">
        <div class="mb-3">
            <label class="form-label">제목</label>
            <input type="text" name="title" class="form-control" value="<%= dto.getTitle() %>" required>
        </div>
        <div class="mb-3">
            <label class="form-label">내용</label>
            <textarea name="content" class="form-control" rows="6" required><%= dto.getContent() %></textarea>
        </div>
        <button type="submit" class="btn btn-primary">수정 완료</button>
        <a href="view.jsp?num=<%=dto.getNum()%>&board_type=<%=dto.getBoard_type()%>" class="btn btn-secondary">취소</a>
    </form>
</div>
</body>
</html>