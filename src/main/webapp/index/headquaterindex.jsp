<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="dto.HqBoardDto" %>
<%@ page import="dao.HqBoardDao" %>

<%
    String userId = (String) session.getAttribute("userId");

    // 내부 게시판 최근 5개 글 가져오기 (검색, 페이징 없이 간단 조회)
    HqBoardDto dto = new HqBoardDto();
    dto.setStartRowNum(1);
    dto.setEndRowNum(5);

    List<HqBoardDto> boardList = null;
    try {
        boardList = HqBoardDao.getInstance().selectPage(dto);
    } catch(Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8" />
<title>본사 대시보드</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" />
<style>
   body {
    background: #f9fafc;
  }
	.container-fluid {
	  padding-top: 0;   /* 위쪽 패딩 없앰 */
	  padding-left: 2rem;
	  padding-right: 2rem;
	}

  .dashboard-card {
    border-radius: 1rem;
    background: #fff;
    padding: 2rem 1rem;
    box-shadow: 0 2px 12px rgba(0,0,0,0.04);
    color: inherit;
    text-decoration: none;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    flex-grow: 1;
    min-height: 180px;
    transition: box-shadow 0.2s ease;
    width: 100%;
    box-sizing: border-box;
    text-align: center;
  }
  .dashboard-card:hover {
    box-shadow: 0 4px 20px rgba(0,0,0,0.1);
  }

  .dashboard-card i.fs-3 {
    font-size: 3rem !important;
    margin-bottom: 0.75rem;
  }

  .dashboard-card .fw-bold {
    font-weight: 700;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
    width: 100%;
  }

  .dashboard-title {
    color: #3a53ce;
    font-weight: 700;
  }

  .row.flex-equal {
    display: flex !important;
    flex-wrap: nowrap !important;
    align-items: stretch;
    height: 200px;
  }

  .row.flex-equal > [class*='col-'] {
    display: flex;
    flex-direction: column;
    flex-grow: 1;
    max-width: none !important;
  }

  .row.flex-equal > [class*='col-'] > .dashboard-card {
    flex-grow: 1;
  }

  .row.flex-equal > .col-md-4:last-child {
    display: flex;
    flex-direction: column;
    gap: 0.25rem;
  }

  .quick-menu-vertical {
    display: flex;
    flex-direction: column;
    gap: 0.25rem;
    width: 100%;
    height: 180px;
    box-sizing: border-box;
  }

  .quick-menu-vertical a {
    display: flex;
    align-items: center;
    gap: 0.5rem;
    padding: 0.25rem 1rem;
    border-radius: 1rem;
    background: #fff;
    box-shadow: 0 2px 12px rgba(0,0,0,0.04);
    color: inherit;
    text-decoration: none;
    transition: box-shadow 0.2s ease;
    font-weight: 700;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
    width: 100%;
    min-height: 56px;
    box-sizing: border-box;
    font-size: 0.9rem;
    line-height: 1;
  }

  .quick-menu-vertical a:hover {
    box-shadow: 0 4px 20px rgba(0,0,0,0.1);
  }

  .quick-menu-vertical i {
    font-size: 1.6rem;
    flex-shrink: 0;
  }

  .quick-menu-content {
    display: flex;
    align-items: center;
    height: 100%;
  }

  .board-list {
    margin-top: 3rem;
    background: #fff;
    padding: 1rem 2rem;
    border-radius: 1rem;
    box-shadow: 0 2px 12px rgba(0,0,0,0.04);
  }

  .board-list h3 {
    color: #3a53ce;
    font-weight: 700;
    margin-bottom: 1.5rem;
  }

  .board-list table {
    width: 100%;
  }

  .board-list th, .board-list td {
    padding: 0.75rem 1rem;
    text-align: center;
    border-bottom: 1px solid #ddd;
  }

  .board-list td.text-start {
    text-align: left;
  }

  .board-list a {
    color: #224488;
    text-decoration: none;
  }

  .board-list a:hover {
    text-decoration: underline;
  }
</style>
</head>
<body>
  <div class="container-fluid">
    <div class="row mb-4">
      <div class="col-md-8 d-flex flex-column">
        <h2 class="dashboard-title mb-0" style="text-align: left;">대시보드</h2>
        <div class="text-secondary mt-2" style="font-size: 1.1rem;">
          <%= userId != null ? userId + "님, 환영합니다!" : "로그인이 필요합니다." %>
        </div>
      </div>
    </div>

    <!-- 상단 3개 카드 -->
    <div class="row g-4 mb-4 flex-equal">
      <div class="col-md-4">
        <a href="<%=request.getContextPath()%>/headquater.jsp?page=product/list.jsp" class="dashboard-card">
          <i class="bi bi-box-seam fs-3 text-primary"></i>
          <div class="fw-bold">상품 관리</div>
        </a>
      </div>
      <div class="col-md-4">
        <a href="<%=request.getContextPath()%>/headquater.jsp?page=branch-admin/list.jsp" class="dashboard-card">
          <i class="bi bi-building fs-3 text-secondary"></i>
          <div class="fw-bold">지점 관리</div>
        </a>
      </div>
      <div class="col-md-4">
        <a href="<%=request.getContextPath()%>/headquater.jsp?page=headquater/sales.jsp" class="dashboard-card">
          <i class="bi bi-graph-up-arrow fs-3 text-success"></i>
          <div class="fw-bold">매출 관리</div>
        </a>
      </div>
    </div>

    <!-- 하단 3개 카드 -->
    <div class="row g-4 mb-4 flex-equal">
      <div class="col-md-4">
        <a href="<%=request.getContextPath()%>/headquater.jsp?page=headquater/stock.jsp" class="dashboard-card">
          <i class="bi bi-stack fs-3 text-warning"></i>
          <div class="fw-bold">재고 관리</div>
        </a>
      </div>
      <div class="col-md-4">
        <a href="<%=request.getContextPath()%>/headquater.jsp?page=hqboard/hq-list.jsp" class="dashboard-card">
          <i class="bi bi-megaphone fs-3 text-info"></i>
          <div class="fw-bold">내부 게시판</div>
        </a>
      </div>
      <!-- 빠른 메뉴 세로 3줄 -->
      <div class="col-md-4 d-flex flex-column">
        <div class="quick-menu-vertical">
          <a href="<%=request.getContextPath()%>/headquater.jsp?page=product/insertform.jsp">
            <i class="bi bi-plus-circle text-primary"></i>
            <span class="quick-menu-content">신규 상품 등록</span>
          </a>
          <a href="<%=request.getContextPath()%>/headquater.jsp?page=branch-admin/insert-form.jsp">
            <i class="bi bi-building-add text-secondary"></i>
            <span class="quick-menu-content">신규 지점 등록</span>
          </a>
          <a href="<%=request.getContextPath()%>/headquater.jsp?page=board/list.jsp">
            <i class="bi bi-chat-dots text-info"></i>
            <span class="quick-menu-content">통합 게시판</span>
          </a>
        </div>
      </div>
    </div>

    <!-- 내부 게시판 최근 글 목록 출력 -->
    <div class="board-list">
      <h3>공지사항</h3>

   

      <table>
        <thead>
          <tr>
            <th>글 번호</th>
            <th>작성자</th>
            <th>제목</th>
            <th>조회수</th>
            <th>작성일</th>
          </tr>
        </thead>
        <tbody>
          <%
            if (boardList != null && !boardList.isEmpty()) {
              for(HqBoardDto post : boardList) {
          %>
            <tr>
              <td><%= post.getNum() %></td>
              <td><%= post.getWriter() %></td>
              <td class="text-start">
                <a href="<%=request.getContextPath()%>/headquater.jsp?page=hqboard/hq-view.jsp&num=<%=post.getNum()%>">
                  <%= post.getTitle() %>
                </a>
              </td>
              <td><%= post.getViewCount() %></td>
              <td><%= post.getCreatedAt() %></td>
            </tr>
          <%
              }
            } else {
          %>
            <tr>
              <td colspan="5" class="text-secondary">등록된 글이 없습니다.</td>
            </tr>
          <%
            }
          %>
        </tbody>
      </table>
    </div>

  </div>
</body>
</html>
