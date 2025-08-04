<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="dao.BoardDao" %>
<%@ page import="dto.BoardDto" %>

<%
	
    int num = Integer.parseInt(request.getParameter("num"));
	String board_type = request.getParameter("board_type");
	
	// board_type이 null이면 기본값으로 "QNA" 넣기
    if (board_type == null || board_type.trim().isEmpty()) {
        board_type = "QNA"; // 게시판 타입 중 기본값으로 사용
    }
	
    // 글 상세정보 가져오기
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
    
 	// 로그인된 userName(null 일 가능성이 있음), session 영역에 userName 이 있는지 읽어와서
 	String user_name=(String)session.getAttribute("userId");
 	// 만일 본인 글 자세히 보기가 아니면 조회수 1을 증가시킨다
 	if(dto.getWriter() != null && !dto.getWriter().equals(user_name)) {
 		BoardDao.getInstance().addViewCount(num);
 	}
 	// 댓글 목록을 DB 에서 읽어오기
 	//List<CommentDto> commentList=CommentDao.getInstance().selectList(num);
 	
 	// 클라이언트가 로그인 했는지 여부 알아내기
 	boolean isLogin = user_name == null ? false: true;
%>
<%
    String loginUserId = (String) session.getAttribute("userId");
    String writerId = dto.getUser_id(); // 또는 dto.getWriter() – 실제 로그인 ID가 저장된 필드를 확인하세요
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
    <h2> 글 상세보기</h2>
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
            <th>작성일</th>
            <td><%= dto.getCreated_at() %></td>
        </tr>
        <tr>
            <th>게시판 유형</th>
            <td><%= dto.getBoard_type() %></td>
        </tr>
    </table>
	<div class="card mt-4">
			<div class="card-header bg-success">
				<strong>본문 내용</strong>
			</div>
			<div class="card-body p-1"><%=dto.getContent() %></div>
	</div>
		
		
    <div class="text-end">
        <a href="list.jsp?boardType=<%= dto.getBoard_type() %>" class="btn btn-secondary">목록</a>
		
		<%-- 수정 버튼: 작성자면 공통으로 노출 --%>
		<% if (loginUserId != null && loginUserId.equals(writerId)) { %>
		    <a href="update.jsp?num=<%= dto.getNum() %>&board_type=<%= dto.getBoard_type() %>" class="btn btn-warning">수정</a>
		<% } %>
		
		<%-- 삭제 버튼 분기 처리 --%>
		<%
		    String branchId = dto.getBranch_id(); // 글 작성자의 소속 (HQ 또는 지점)
		    boolean isWriter = loginUserId != null && loginUserId.equals(writerId);
		%>
		
		<%-- 문의사항: 작성자면 삭제 가능 --%>
		<% if ("QNA".equalsIgnoreCase(board_type) && isWriter) { %>
		    <a href="delete.jsp?num=<%= dto.getNum() %>&board_type=<%= dto.getBoard_type() %>"
		       onclick="return confirm('정말 삭제하시겠습니까?');"
		       class="btn btn-danger">삭제</a>
		<% } %>
		
		<%-- 공지사항: 본사 작성자만 삭제 가능 --%>
		<% if ("NOTICE".equalsIgnoreCase(board_type) && isWriter && "HQ".equalsIgnoreCase(branchId)) { %>
		    <a href="delete.jsp?num=<%= dto.getNum() %>&board_type=<%= dto.getBoard_type() %>"
		       onclick="return confirm('공지사항을 삭제하시겠습니까?');"
		       class="btn btn-danger">삭제</a>
		<% } %>
    </div>
</div>
</body>
</html>