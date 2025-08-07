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

    if (board_type == null || board_type.trim().isEmpty()) {
        board_type = "QNA";
    }

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

    String user_name = (String) session.getAttribute("userId");
    String branchId = (String) session.getAttribute("branchId");
    boolean isLogin = user_name != null;
    boolean isHQ = "HQ".equalsIgnoreCase(branchId);

    if(dto.getWriter() != null && !dto.getWriter().equals(user_name)) {
        BoardDao.getInstance().addViewCount(num);
    }

    List<CommentDto> commentList = CommentDao.getInstance().selectList(num, board_type);
    request.setAttribute("commentList", commentList);

    boolean canWriteComment = false;
    if (isLogin) {
        if ("QNA".equalsIgnoreCase(board_type)) {
            canWriteComment = true;
        } else if ("NOTICE".equalsIgnoreCase(board_type) && isHQ) {
            canWriteComment = true;
        }
    }

    String commentHeaderText = "댓글 작성";
    if ("QNA".equalsIgnoreCase(board_type)) {
        commentHeaderText = "\uD83D\uDCAC 문의하기";
    }
    
    Integer prevNum = BoardDao.getInstance().getPrevNum(dto.getNum(), board_type);
    Integer nextNum = BoardDao.getInstance().getNextNum(dto.getNum(), board_type);
    
    String contentHeaderText = "본문 내용"; 
    
    if ("NOTICE".equalsIgnoreCase(board_type)) {
        contentHeaderText = "공지내용";
    } else if ("QNA".equalsIgnoreCase(board_type)) {
        contentHeaderText = "문의내용";
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>글 상세보기</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
	<jsp:include page="/WEB-INF/include/resource.jsp"></jsp:include>
</head>
<body>

	<div class="container-fluid mt-3">
		  <div class="border-bottom pb-2 mb-3">
		     <h2 class="fw-bold fs-3 mb-1"><%= dto.getTitle() %></h2>
		  </div>
		
		  <!-- 글 정보 영역 -->
		  <div class="d-flex flex-wrap mb-3 text-muted small">
		    <div class="me-3">글 번호: <%= dto.getNum() %></div>
		    <div class="me-3">작성자: <%= dto.getWriter() != null ? dto.getWriter() : "알 수 없음" %></div>
		    <div class="me-3">작성일: <%= dto.getCreated_at() %></div>
		  </div>
		
		  <!-- 본문 내용 카드 -->
		  <div class="card mt-3">
			  <div class="card-header text-white" style="background-color: #003366;">
			    <strong><%= contentHeaderText %></strong>
			  </div>
			  <div class="card-body p-2"><%= dto.getContent() %></div>
		  </div>
	</div>
    <div class="text-end">
        <% if (user_name != null && user_name.equals(dto.getUser_id())) { %>
            <a href="<%="HQ".equalsIgnoreCase((String)session.getAttribute("branchId"))
			        ? request.getContextPath() + "/headquater.jsp?page=board/update.jsp&num=" + dto.getNum() + "&board_type=" + dto.getBoard_type()
			        : request.getContextPath() + "/branch.jsp?page=board/update.jsp&num=" + dto.getNum() + "&board_type=" + dto.getBoard_type() %>" class="btn btn-secondary">수정</a>
        <% } %>
        <% if ("QNA".equalsIgnoreCase(board_type) && user_name != null && user_name.equals(dto.getUser_id())) { %>
            <a href="<%= "HQ".equalsIgnoreCase((String)session.getAttribute("branchId")) 
					    ? request.getContextPath() + "/headquater.jsp?page=board/delete.jsp&num=" + dto.getNum() + "&board_type=" + dto.getBoard_type()
					    : request.getContextPath() + "/branch.jsp?page=board/delete.jsp&num=" + dto.getNum() + "&board_type=" + dto.getBoard_type()
					 %>" 
               onclick="return confirm('정말 삭제하시겠습니까?');" class="btn btn-danger">삭제</a>
        <% } %>
        <% if ("NOTICE".equalsIgnoreCase(board_type) && user_name != null && user_name.equals(dto.getUser_id()) && isHQ) { %>
            <a href="<%= "HQ".equalsIgnoreCase((String)session.getAttribute("branchId")) 
					    ? request.getContextPath() + "/headquater.jsp?page=board/delete.jsp&num=" + dto.getNum() + "&board_type=" + dto.getBoard_type()
					    : request.getContextPath() + "/branch.jsp?page=board/delete.jsp&num=" + dto.getNum() + "&board_type=" + dto.getBoard_type()
					 %>" 
               onclick="return confirm('공지사항을 삭제하시겠습니까?');" class="btn btn-danger">삭제</a>
        <% } %>
    </div>

    <% if (canWriteComment) { %>
        <div class="card mt-4">
		  <div class="card-header text-white fw-bold" style="background-color: #003366;"><%= commentHeaderText %></div>
		  <div class="card-body p-3">
		    <!-- 댓글 작성 폼 여기로 이동 -->
		    <form action="<%= request.getContextPath() %>/board/save-comment.jsp" method="post">
		        <input type="hidden" name="writer" value="<%= user_name %>">
		        <input type="hidden" name="board_num" value="<%= dto.getNum() %>">
		        <input type="hidden" name="board_type" value="<%= dto.getBoard_type() %>">
		        <textarea class="form-control mb-2" name="content" rows="3" placeholder="댓글을 입력하세요" required></textarea>
		         <div class="text-end">
			        <button type="submit" class="btn" style="background-color: #003366; color: white;">등록</button>
			    </div>
		    </form>
		  </div>
		</div>
        <!-- 목록 + Prev/Next 버튼 정렬 -->
		<div class="d-flex justify-content-between align-items-center mt-5 px-5">
		    <!-- Prev 버튼 -->
		    <% if (prevNum != null) { %>
		        <a href="<%= "HQ".equalsIgnoreCase((String)session.getAttribute("branchId")) 
				        ? "headquater.jsp?page=board/view.jsp&num=" + prevNum + "&board_type=" + board_type 
				        : "branch.jsp?page=board/view.jsp&num=" + prevNum + "&board_type=" + board_type%>" class="btn btn-outline-secondary">&larr; Prev</a>
		    <% } else { %>
		        <button class="btn btn-outline-secondary" disabled>&larr; Prev</button>
		    <% } %>
		
		    <!-- 목록 버튼 -->
		    <a href="<%= isHQ
		        ? request.getContextPath() + "/headquater.jsp?page=board/list.jsp&board_type=" + board_type
		        : request.getContextPath() + "/branch.jsp?page=board/list.jsp&board_type=" + board_type
		    %>" class="btn btn-dark btn-md px-4" style="background-color: #003366; color: white;">목록으로</a>
		
		    <!-- Next 버튼 -->
		    <% if (nextNum != null) { %>
		        <a href="<%= "HQ".equalsIgnoreCase((String)session.getAttribute("branchId")) 
						        ? "headquater.jsp?page=board/view.jsp&num=" + nextNum + "&board_type=" + board_type 
						        : "branch.jsp?page=board/view.jsp&num=" + nextNum + "&board_type=" + board_type %>" class="btn btn-outline-secondary">Next &rarr;</a>
		    <% } else { %>
		        <button class="btn btn-outline-secondary" disabled>Next &rarr;</button>
		    <% } %>
		</div>
    <% } else if (isLogin) { %>
        <p class="text-muted mt-4">※ 이 게시판에서는 댓글 작성 권한이 없습니다.</p>
    <% } else { %>
        <p class="text-muted mt-4">※ 댓글을 작성하려면 로그인해주세요.</p>
    <% } %>

    <div class="comments mt-5">
        <% for (CommentDto tmp : commentList) { %>
        <div class="card border border-dark mb-3">
            <% if ("yes".equals(tmp.getDeleted())) { %>
                <div class="card-body bg-light text-muted rounded">삭제된 댓글입니다</div>
            <% } else { %>
                <div class="card-body d-flex flex-column flex-sm-row position-relative">
                    <% if (tmp.getProfileImage() == null) { %>
                        <i style="font-size:50px;" class="bi bi-person-circle me-3 align-self-center"></i>
                    <% } else { %>
                        <img class="rounded-circle me-3 align-self-center" src="${pageContext.request.contextPath}/upload/<%= tmp.getProfileImage() %>" alt="프로필이미지" style="width:50px; height:50px;">
                    <% } %>

                    <div class="flex-grow-1">
                        <div class="d-flex justify-content-between">
                            <div><strong><%= tmp.getWriter() %></strong></div>
                            <small><%= tmp.getCreatedAt() %></small>
                        </div>
                        <pre><%= tmp.getContent() %></pre>

                        <% if (tmp.getWriter().equals(user_name)) { %>
                            <form action="<%= "HQ".equalsIgnoreCase((String)session.getAttribute("branchId")) 
									    ? request.getContextPath() + "/board/comment-delete.jsp"
									    : request.getContextPath() + "/board/comment-delete.jsp" 
									    %>" method="post" class="position-absolute top-0 end-0 m-2">
                                <input type="hidden" name="num" value="<%= tmp.getNum() %>">
                                <input type="hidden" name="board_num" value="<%= dto.getNum() %>">
                                <input type="hidden" name="board_type" value="<%= dto.getBoard_type() %>">
                                <button class="btn-close" onclick="return confirm('정말 삭제하시겠습니까?')"></button>
                            </form>
                            <button class="btn btn-sm btn-outline-dark mb-2 edit-btn">수정</button>
                            <div class="d-none form-div">
                                <form action="<%= "HQ".equalsIgnoreCase((String)session.getAttribute("branchId")) 
											    ? request.getContextPath() + "/board/comment-update.jsp" 
											    : request.getContextPath() + "/board/comment-update.jsp" 
											   %>" method="post">
                                    <input type="hidden" name="num" value="<%= tmp.getNum() %>">
                                    <input type="hidden" name="board_num" value="<%= dto.getNum() %>">
                                    <input type="hidden" name="board_type" value="<%= dto.getBoard_type() %>">
                                    <textarea name="content" class="form-control mb-2" rows="2"><%= tmp.getContent() %></textarea>
                                    <button type="submit" class="btn btn-sm btn-dark mb-2">수정 완료</button>
                                    <button type="reset" class="btn btn-sm btn-secondary cancel-edit-btn mb-2">취소</button>
                                </form>
                            </div>
                        <% } %>
                    </div>
                </div>
            <% } %>
        </div>
        <% } %>
    </div>
</div>
<script>
  document.querySelectorAll(".edit-btn").forEach(item => {
    item.addEventListener("click", () => {
      item.classList.add("d-none");
      const formDiv = item.nextElementSibling;
      formDiv.classList.remove("d-none");
    });
  });
  document.querySelectorAll(".cancel-edit-btn").forEach(item => {
    item.addEventListener("click", () => {
      const formDiv = item.closest(".form-div");
      formDiv.classList.add("d-none");
      formDiv.previousElementSibling.classList.remove("d-none");
    });
  });
</script>
</body>
</html>