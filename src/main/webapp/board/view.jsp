<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="dao.BoardDao" %>
<%@ page import="dto.BoardDto" %>

<%
    int num = Integer.parseInt(request.getParameter("num"));

    // 글 상세정보 가져오기
    BoardDto dto = BoardDao.getInstance().getData(num);
    if (dto == null) {
%>
        <script>
            alert("해당 글이 존재하지 않습니다.");
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
    <title>글 상세보기</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="p-4">
<div class="container">
    <h2>📝 글 상세보기</h2>
    <table class="table table-bordered">
        <tr>
            <th>번호</th>
            <td><%= dto.getNum() %></td>
        </tr>
        <tr>
            <th>제목</th>
            <td><%= dto.getTitle() %></td>
        </tr>
        <tr>
            <th>작성자</th>
            <td><%= dto.getWriter() != null ? dto.getWriter() : "알 수 없음" %></td>
        </tr>
        <tr>
            <th>내용</th>
            <td><pre><%= dto.getContent() %></pre></td>
        </tr>
        <tr>
            <th>작성일</th>
            <td><%= dto.getCreatedAt() %></td>
        </tr>
        <tr>
            <th>게시판 유형</th>
            <td><%= dto.getBoardType() %></td>
        </tr>
    </table>

    <div class="text-end">
        <a href="list.jsp?boardType=<%= dto.getBoardType() %>" class="btn btn-secondary">목록</a>

        <%-- boardType이 "문의사항"일 때만 삭제 버튼 노출 --%>
        <% if ("문의사항".equals(dto.getBoardType())) { %>
            <a href="delete.jsp?num=<%= dto.getNum() %>"
               onclick="return confirm('정말 삭제하시겠습니까?');"
               class="btn btn-danger">삭제</a>
        <% } %>
    </div>
</div>
</body>
</html>