<%@ page import="java.net.URLEncoder, java.util.List, dao.HrmDao, dto.HrmDto" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    String from = request.getParameter("from");
    if (from == null || (!from.equals("admin") && !from.equals("branch"))) {
        from = "admin";
    }

    String hqKeyword = request.getParameter("hqKeyword");
    if (hqKeyword == null) hqKeyword = "";
    int hqPageNum = 1;
    try { hqPageNum = Integer.parseInt(request.getParameter("hqPageNum")); if (hqPageNum < 1) hqPageNum = 1; } catch (Exception e) {}
    int hqPageSize = 10;
    int hqStart = (hqPageNum - 1) * hqPageSize;

    String branchKeyword = request.getParameter("branchKeyword");
    if (branchKeyword == null) branchKeyword = "";
    int branchPageNum = 1;
    try { branchPageNum = Integer.parseInt(request.getParameter("branchPageNum")); if (branchPageNum < 1) branchPageNum = 1; } catch (Exception e) {}
    int branchPageSize = 10;
    int branchStart = (branchPageNum - 1) * branchPageSize;

    HrmDao dao = new HrmDao();

    List<HrmDto> hqList = dao.selectHeadOfficeByKeywordWithPaging(hqKeyword, hqStart, hqPageSize);
    int hqTotalCount = dao.getHeadOfficeCountByKeyword(hqKeyword);
    int hqTotalPage = (int) Math.ceil(hqTotalCount / (double) hqPageSize);

    List<HrmDto> branchList = dao.selectBranchByKeywordWithPaging(branchKeyword, branchStart, branchPageSize);
    int branchTotalCount = dao.getBranchCountByKeyword(branchKeyword);
    int branchTotalPage = (int) Math.ceil(branchTotalCount / (double) branchPageSize);

    String contextPath = request.getContextPath();
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>직원 목록</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<style>
    button.btn-primary {
        background-color: #003366 !important;
        border-color: #003366 !important;
        color: white !important;
        font-weight: 500;
        border-radius: 6px;
        height: 38px;
    }
    button.btn-primary:hover {
        background-color: #002244 !important;
        border-color: #002244 !important;
        color: white !important;
    }
    body {
        margin: 0;
        padding: 0;
        background-color: #f8f9fa;
    }
    /* 검색 input, 버튼 크기 상품 관리 페이지와 동일하게 */
    input.form-control {
        height: 38px;
        max-width: 300px;
    }
    button.btn-primary {
        height: 38px;
    }
    /* 페이지네이션 기본 숫자 색깔 남색으로 */
    .pagination .page-link {
        color: #003366 !important;
        border-color: #003366 !important;
    }
    /* 활성화된 페이지네이션(현재 페이지) 배경 남색, 글자 흰색 */
    .pagination .page-item.active .page-link {
        background-color: #003366 !important;
        border-color: #003366 !important;
        color: white !important;
    }
    /* 페이지네이션 숫자 호버 시 진한 남색 배경, 글자 흰색 */
    .pagination .page-link:hover {
        background-color: #002244 !important;
        border-color: #002244 !important;
        color: white !important;
    }
    /* 상세, 삭제 파란 텍스트 버튼 스타일 */
    .link-button {
        color: #0d6efd;
        text-decoration: none;
        background: none;
        border: none;
        padding: 0;
        font: inherit;
        cursor: pointer;
    }
    .link-button:hover,
    .link-button:focus {
        text-decoration: underline;
    }
    
    .table-bordered thead th {
    background-color: #e9ecef !important;  /* 상품관리랑 똑같은 헤더 배경 */
    color: #212529 !important;              /* 진한 회색 텍스트 */
    border: 1px solid #dee2e6 !important;
    vertical-align: middle !important;
    text-align: center !important;
	}
	
	.table-bordered tbody td {
	    background-color: #fff !important;
	    border: 1px solid #dee2e6 !important;
	    vertical-align: middle !important;
	    text-align: center !important;
	}
    
</style>
</head>
<body>

<!-- breadcrumb -->
<nav aria-label="breadcrumb" class="mb-3" style="margin: 0 15px;">
  <ol class="breadcrumb">
    <li class="breadcrumb-item"><a href="<%=contextPath%>/headquater.jsp">홈</a></li>
    <li class="breadcrumb-item active" aria-current="page">직원 관리</li>
    <li class="breadcrumb-item active" aria-current="page"><%= "admin".equals(from) ? "본사 직원 목록" : "지점 직원 목록" %></li>
  </ol>
</nav>

<div class="container-fluid p-3">

    <!-- 탭 네비게이션 -->
    <ul class="nav nav-tabs mb-3">
      <li class="nav-item">
        <a class="nav-link <%= "admin".equals(from) ? "active" : "" %>" href="?page=hrm/list.jsp&from=admin">본사 직원</a>
      </li>
      <li class="nav-item">
        <a class="nav-link <%= "branch".equals(from) ? "active" : "" %>" href="?page=hrm/list.jsp&from=branch">지점 직원</a>
      </li>
    </ul>

    <!-- 본사 직원 -->
    <div class="<%= "admin".equals(from) ? "" : "d-none" %>">
      <div class="d-flex justify-content-between align-items-center mb-3">
        <h4>본사 직원 목록</h4>
       <form method="get" action="<%= contextPath %>/headquater.jsp" class="d-flex align-items-center justify-content-end mb-3" style="gap:8px;">
		    <input type="hidden" name="page" value="hrm/list.jsp" />
		    <input type="hidden" name="from" value="admin" />
		    <input type="text" name="hqKeyword" class="form-control" placeholder="이름 또는 직급 검색" value="<%= hqKeyword %>" style="max-width: 300px;" />
		    <button type="submit" class="btn btn-primary" style="height: 38px; white-space: nowrap;">검색</button>
		</form>

      </div>

      <table class="table table-bordered table-hover align-middle text-center">
        <thead class="table-secondary">
          <tr><th>번호</th><th>이름</th><th>직급</th><th>상세 보기</th><th>삭제</th></tr>
        </thead>
        <tbody>
        <%
          int hqDisplayNum = (hqPageNum - 1) * hqPageSize + 1;
          for(HrmDto dto : hqList) {
        %>
          <tr>
            <td><%= hqDisplayNum++ %></td>
            <td><%= dto.getName() %></td>
            <td><%= dto.getRole() %></td>
            <td>
              <a class="link-button" href="<%= contextPath %>/headquater.jsp?page=hrm/detail.jsp&num=<%= dto.getNum() %>&from=admin">상세</a>
            </td>
            <td>
              <a class="link-button" href="<%= contextPath %>/hrm/delete.jsp?num=<%= dto.getNum() %>" onclick="return confirm('삭제하시겠습니까?');">삭제</a>
            </td>
          </tr>
        <% } %>
        </tbody>
      </table>

      <!-- 페이지네이션 -->
      <nav>
        <ul class="pagination justify-content-center">
          <li class="page-item <%= (hqPageNum == 1) ? "disabled" : "" %>">
            <a class="page-link" href="?page=hrm/list.jsp&from=admin&hqPageNum=<%= hqPageNum - 1 %>&hqKeyword=<%= URLEncoder.encode(hqKeyword, "UTF-8") %>">이전</a>
          </li>
          <% for(int i=1; i<=hqTotalPage; i++) { %>
            <li class="page-item <%= (i == hqPageNum) ? "active" : "" %>">
              <a class="page-link" href="?page=hrm/list.jsp&from=admin&hqPageNum=<%= i %>&hqKeyword=<%= URLEncoder.encode(hqKeyword, "UTF-8") %>"><%= i %></a>
            </li>
          <% } %>
          <li class="page-item <%= (hqPageNum == hqTotalPage) ? "disabled" : "" %>">
            <a class="page-link" href="?page=hrm/list.jsp&from=admin&hqPageNum=<%= hqPageNum + 1 %>&hqKeyword=<%= URLEncoder.encode(hqKeyword, "UTF-8") %>">다음</a>
          </li>
        </ul>
      </nav>
    </div>

    <!-- 지점 직원 -->
    <div class="<%= "branch".equals(from) ? "" : "d-none" %>">
      <div class="d-flex justify-content-between align-items-center mb-3">
        <h4>지점 직원 목록</h4>
        <form method="get" action="<%= contextPath %>/headquater.jsp" class="d-flex align-items-center justify-content-end mb-3" style="gap:8px;">
		    <input type="hidden" name="page" value="hrm/list.jsp" />
		    <input type="hidden" name="from" value="branch" />
		    <input type="text" name="branchKeyword" class="form-control" placeholder="이름 또는 지점 검색" value="<%= branchKeyword %>" style="max-width: 300px;" />
		    <button type="submit" class="btn btn-primary" style="height: 38px; white-space: nowrap;">검색</button>
		</form>

      </div>

      <table class="table table-bordered table-hover align-middle text-center">
        <thead class="table-secondary">
          <tr><th>번호</th><th>이름</th><th>직급</th><th>지점</th><th>상세 보기</th><th>삭제</th></tr>
        </thead>
        <tbody>
        <%
          int branchDisplayNum = (branchPageNum - 1) * branchPageSize + 1;
          for(HrmDto dto : branchList) {
        %>
          <tr>
            <td><%= branchDisplayNum++ %></td>
            <td><%= dto.getName() %></td>
            <td><%= dto.getRole() %></td>
            <td><%= dto.getBranchName() %></td>
            <td>
              <a class="link-button" href="<%= contextPath %>/headquater.jsp?page=hrm/detail.jsp&num=<%= dto.getNum() %>&from=branch">상세</a>
            </td>
            <td>
              <a class="link-button" href="<%= contextPath %>/hrm/delete.jsp?num=<%= dto.getNum() %>" onclick="return confirm('삭제하시겠습니까?');">삭제</a>
            </td>
          </tr>
        <% } %>
        </tbody>
      </table>

      <!-- 페이지네이션 -->
      <nav>
        <ul class="pagination justify-content-center">
          <li class="page-item <%= (branchPageNum == 1) ? "disabled" : "" %>">
            <a class="page-link" href="?page=hrm/list.jsp&from=branch&branchPageNum=<%= branchPageNum - 1 %>&branchKeyword=<%= URLEncoder.encode(branchKeyword, "UTF-8") %>">이전</a>
          </li>
          <% for(int i=1; i<=branchTotalPage; i++) { %>
            <li class="page-item <%= (i == branchPageNum) ? "active" : "" %>">
              <a class="page-link" href="?page=hrm/list.jsp&from=branch&branchPageNum=<%= i %>&branchKeyword=<%= URLEncoder.encode(branchKeyword, "UTF-8") %>"><%= i %></a>
            </li>
          <% } %>
          <li class="page-item <%= (branchPageNum == branchTotalPage) ? "disabled" : "" %>">
            <a class="page-link" href="?page=hrm/list.jsp&from=branch&branchPageNum=<%= branchPageNum + 1 %>&branchKeyword=<%= URLEncoder.encode(branchKeyword, "UTF-8") %>">다음</a>
          </li>
        </ul>
      </nav>
    </div>

</div>

</body>
</html>
