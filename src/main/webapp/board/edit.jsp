<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="dao.BoardDao" %>
<%@ page import="dto.BoardDto" %>

<%
    request.setCharacterEncoding("UTF-8");

    int num = Integer.parseInt(request.getParameter("num"));
    String board_type = request.getParameter("board_type");
    String title = request.getParameter("title");
    String content = request.getParameter("content");

    BoardDto dto = new BoardDto();
    dto.setNum(num);
    dto.setTitle(title);
    dto.setContent(content);
	dto.setBoard_type(board_type);
	
    boolean isSuccess = BoardDao.getInstance().update(dto);

    if (isSuccess) {
%>
    <script>
        alert("수정 완료되었습니다.");
        location.href = "<%= 
            "HQ".equalsIgnoreCase((String)session.getAttribute("branchId")) 
            ? request.getContextPath() + "/headquater.jsp?page=board/view.jsp&num=" + num + "&board_type=" + board_type 
            : request.getContextPath() + "/branch.jsp?page=board/view.jsp&num=" + num + "&board_type=" + board_type 
        %>";
    </script>
<%
    } else {
%>
    <script>
        alert("수정 실패. 다시 시도해주세요.");
        history.back();
    </script>
<%
    }
%>

