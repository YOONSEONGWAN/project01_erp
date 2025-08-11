<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="dao.BoardDao" %>
<%@ page import="dto.BoardDto" %>

<%
    request.setCharacterEncoding("UTF-8");

    int num = Integer.parseInt(request.getParameter("num"));
    String boardType = request.getParameter("board_type");
    String title = request.getParameter("title");
    String content = request.getParameter("content");
    
    dto.BoardDto post = dao.BoardDao.getInstance().getData(num, boardType);
    java.util.List<dto.BoardFileDto> files =
        dao.BoardFileDao.getInstance().getList(num, boardType);

    BoardDto dto = new BoardDto();
    dto.setNum(num);
    dto.setTitle(title);
    dto.setContent(content);
	dto.setBoard_type(boardType);
	
    boolean isSuccess = BoardDao.getInstance().update(dto);

    if (isSuccess) {
%>
    <script>
        alert("수정 완료되었습니다.");
        location.href = "<%= 
            "HQ".equalsIgnoreCase((String)session.getAttribute("branchId")) 
            ? request.getContextPath() + "/headquater.jsp?page=board/view.jsp&num=" + num + "&board_type=" + boardType 
            : request.getContextPath() + "/branch.jsp?page=board/view.jsp&num=" + num + "&board_type=" + boardType 
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

	<form action="${pageContext.request.contextPath}/board/update"
	      method="post" enctype="multipart/form-data">
	  <input type="hidden" name="num" value="<%=num%>">
	  <input type="hidden" name="board_type" value="<%=boardType%>">
	
	  <input class="form-control mb-2" name="title" value="<%=post.getTitle()%>" required>
	  <textarea class="form-control mb-2" name="content" rows="8" required><%=post.getContent()%></textarea>
	
	  <!-- 기존 파일 목록(삭제 선택) -->
	  <% if (!files.isEmpty()) { %>
	    <ul class="mb-2">
	      <% for (dto.BoardFileDto f : files) { %>
	        <li>
	          <a href="<%=request.getContextPath()%>/file/download?id=<%=f.getNum()%>"><%=f.getOrgFileName()%></a>
	          <label class="ms-2"><input type="checkbox" name="deleteFileIds" value="<%=f.getNum()%>"> 삭제</label>
	        </li>
	      <% } %>
	    </ul>
	  <% } %>
	
	  <!-- 새 파일 추가(없어도 됨) -->
	  <input type="file" name="files" class="form-control mb-3" multiple>
	
	  <button class="btn btn-primary">수정 완료</button>
	</form>
