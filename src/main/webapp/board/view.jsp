<%@page import="dao.CommentDao"%>
<%@page import="dto.CommentDto"%>
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
 	System.out.println("📌 session.getAttribute(\"userId\") = " + user_name); // 이 줄 추가
 	// 클라이언트가 로그인 했는지 여부 알아내기
  	boolean isLogin = user_name == null ? false: true;
 	// 만일 본인 글 자세히 보기가 아니면 조회수 1을 증가시킨다
 	if(dto.getWriter() != null && !dto.getWriter().equals(user_name)) {
 		BoardDao.getInstance().addViewCount(num);
 	}
 	// 댓글 목록을 DB 에서 읽어오기
 	List<CommentDto> commentList=CommentDao.getInstance().selectList(num, board_type);
 	request.setAttribute("commentList", commentList);
 	
 	
 	
 	String loginUserId = (String) session.getAttribute("userId");
    String writerId = dto.getUser_id(); 
 	
    // board_type 이 문의사항일 경우 commentHeaderText를 문의하기로 변경
 	String commentHeaderText = "댓글 작성";
    if ("QNA".equalsIgnoreCase(board_type)) {
        commentHeaderText = "💬 문의하기";
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
    <% if (isLogin) { %>
    <div class="mt-4">
        <h5><%=commentHeaderText %></h5>
        <form action="<%= request.getContextPath() %>/board/save-comment.jsp" method="post">
            <input type="hidden" name="writer" value="<%= user_name %>">
            <input type="hidden" name="board_num" value="<%= dto.getNum() %>">
            <input type="hidden" name="board_type" value="<%= dto.getBoard_type() %>">
            <input type="hidden" name="parent_num" value="<%= dto.getNum() %>">
            
            <input type="hidden" name="target_user_id" value="">
            
            <div class="mb-2">
                <textarea class="form-control" name="content" rows="3" placeholder="댓글을 입력하세요" required></textarea>
            </div>
            <button type="submit" class="btn btn-success">등록</button>
        </form>
    </div>
	<% } else { %>
	    <p class="text-muted mt-4">※ 댓글을 작성하려면 로그인해주세요.</p>
	<% } %>
	
	<!-- 댓글 목록을 출력하기 -->
		<div class="comments">
		<%for(CommentDto tmp:commentList){ %>
		<%-- 대댓글은 자신의 글번호와 댓글의 그룹번호가 다르다. 그런 경우 왼쪽 마진을 부여한다 --%>
		 <div class="card border border-dark mb-3 <%=tmp.getNum() == tmp.getGroupNum() ? "" : "ms-5"%>">
			<%if(tmp.getDeleted().equals("yes")){ %>
				<div class="card-body bg-light text-muted rounded">삭제된 댓글입니다</div>
			<%}else{ %>
			<div class="card-body d-flex flex-column flex-sm-row position-relative">
				<%-- 대댓글 작성 시 표시되는 화살표 UI --%>
				<%if(tmp.getNum() != tmp.getGroupNum()){ %>
					<i class="bi bi-arrow-return-right position-absolute" style="top:0;left:-30px"></i>
					<%} %>
            	<%-- 댓글 작성자가 로그인된 userName 과 같을때만 삭제버튼 출력 --%>
            	<%if(tmp.getWriter().equals(user_name)){ %>
            		<button data-num="<%=tmp.getNum() %>" class="btn-close position-absolute top-0 end-0 m-2" ></button>
            	<%} %>
            	
            	<%if(tmp.getProfileImage() == null){ %>
					<i style="font-size:50px;" class="bi bi-person-circle me-3 align-self-center"></i>
            	<%}else{ %>
            		<img class="rounded-circle me-3 align-self-center " 
                	 src="${pageContext.request.contextPath}/upload/<%=tmp.getProfileImage() %>" 
                	 alt="프로필이미지"
                	 style="width:50px; height:50px;">
            	<%} %>
                <div class="flex-grow-1">
                <div class="d-flex justify-content-between">
                                <div >
                                        <strong><%=tmp.getWriter() %></strong>
                                        <small><span><%= tmp.getTargetUserId() != null ? "@" + tmp.getTargetUserId() : "" %></span></small>
                                </div>
                                <small><%=tmp.getCreatedAt() %></small>
                        </div>
                        <pre><%=tmp.getContent() %></pre>
                        
                        <%-- 댓글 작성자가 로그인된 userName 과 같으면 수정폼, 다르면 댓글폼을 출력한다 --%>
                        <%if(tmp.getWriter().equals(user_name)){ %>
                         <!-- 수정 버튼 (본인에게만 보임) -->
                           <button class="btn btn-sm btn-outline-dark mb-2 edit-btn">수정</button>  
                           
                           <!-- 댓글 입력 폼 (처음에는 숨김) -->
                           <div class="d-none form-div">
                               <form action="comment-update.jsp" method="post">
                               	   <!-- 댓글을 수정하기 위한 댓글의 번호, 이 페이지로 다시 돌아오기 위한 parentNum 도 같이 전송되도록 -->
                                   <input type="hidden" name="num" value="<%=tmp.getNum() %>" />
                                   <input type="hidden" name="parentNum" value="<%=num %>" />
                                   <textarea name="content" class="form-control mb-2" rows="2" ><%=tmp.getContent() %></textarea>
                                   <button type="submit" class="btn btn-sm btn-dark mb-2">수정 완료</button>
                                   <button type="reset" class="btn btn-sm btn-secondary cancel-edit-btn mb-2">취소</button>
                               </form>
                           </div>
                        <%}else{ %>
						  <button class="btn btn-sm btn-outline-dark mb-2 show-reply-btn">댓글</button>
                       		<!-- 대댓글 입력 폼(처음에는 숨김) -->
                        	<div class="d-none form-div">
                            	<form action="save-comment.jsp" method="post">
                            		<!-- 원글의 글번호, 댓글 대상자의 userName, 댓글의 그룹번호도 같이 전송해야한다
                            		input type = "hidden"으로 들고간다.  -->
                            	<input type="hidden" name="parentNum" value="<%=dto.getNum() %>" />
                            	<input type="hidden" name="targetWriter" value="<%=tmp.getWriter() %>" />
                            	<input type="hidden" name="groupNum" value="<%=tmp.getGroupNum() %>"/>
                            	<input type="hidden" name="board_type" value="<%= dto.getBoard_type() %>" />
                                <textarea name="content" class="form-control mb-3" rows="2" 
                                        placeholder="댓글을 입력하세요"></textarea>
                                <button type="submit" class="btn btn-sm btn-dark">등록</button>
                                <button type="reset" class="btn btn-sm btn-secondary cancel-reply-btn">취소</button>
                            </form>
                        </div>
                        <%} %>
                </div>
            </div><!-- .card-body -->
			<%} %>
         </div><!-- .card -->
		 <%} %>
		 
</div>
</body>
</html>