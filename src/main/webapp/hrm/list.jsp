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
</head>
<body class="p-3">

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
    <form method="get" action="<%= contextPath %>/headquater.jsp" class="d-flex">
      <input type="hidden" name="page" value="hrm/list.jsp" />
      <input type="hidden" name="from" value="admin" />
      <input type="text" name="hqKeyword" class="form-control me-2" placeholder="이름 또는 직급 검색" value="<%= hqKeyword %>" style="max-width: 250px;" />
      <button type="submit" class="btn btn-primary">검색</button>
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
        <td><a class="btn btn-info btn-sm" href="<%= contextPath %>/headquater.jsp?page=hrm/detail.jsp&num=<%= dto.getNum() %>&from=admin">상세</a></td>
        <td><a class="btn btn-danger btn-sm" href="<%= contextPath %>/hrm/delete.jsp?num=<%= dto.getNum() %>" onclick="return confirm('삭제하시겠습니까?');">삭제</a></td>
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
    <form method="get" action="<%= contextPath %>/headquater.jsp" class="d-flex">
      <input type="hidden" name="page" value="hrm/list.jsp" />
      <input type="hidden" name="from" value="branch" />
      <input type="text" name="branchKeyword" class="form-control me-2" placeholder="이름 또는 지점 검색" value="<%= branchKeyword %>" style="max-width: 250px;" />
      <button type="submit" class="btn btn-primary">검색</button>
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
        <td><a class="btn btn-info btn-sm" href="<%= contextPath %>/headquater.jsp?page=hrm/detail.jsp&num=<%= dto.getNum() %>&from=branch">상세</a></td>
        <td><a class="btn btn-danger btn-sm" href="<%= contextPath %>/hrm/delete.jsp?num=<%= dto.getNum() %>" onclick="return confirm('삭제하시겠습니까?');">삭제</a></td>
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

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
