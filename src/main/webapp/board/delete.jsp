<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.BoardDao" %>
<%@ page import="dto.BoardDto" %>
<%@ page import="jakarta.servlet.http.HttpServletResponse" %>

<%
    request.setCharacterEncoding("UTF-8");

    int num = Integer.parseInt(request.getParameter("num"));
    String board_type = request.getParameter("board_type");

    // 현재 로그인 사용자 ID
    String userId = (String) session.getAttribute("userId");

    // 글 정보 불러오기
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

    // 작성자와 현재 로그인 사용자가 다르면 삭제 불가
    if (userId == null || !userId.equals(dto.getUser_id())) {
        response.sendError(HttpServletResponse.SC_FORBIDDEN, "다른 사용자의 글은 삭제할 수 없습니다.");
        return;
    }

    boolean isDeleted = BoardDao.getInstance().deleteByNum(num, board_type);
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>글 삭제</title>
</head>
<body>
<% if (isDeleted) { %>
    <script>
        alert("삭제되었습니다.");
        location.href = "list.jsp?board_type=<%=board_type%>";
    </script>
<% } else { %>
    <p>삭제 실패. <a href="view.jsp?num=<%=num%>&board_type=<%=board_type%>">돌아가기</a></p>
<% } %>
</body>
</html>