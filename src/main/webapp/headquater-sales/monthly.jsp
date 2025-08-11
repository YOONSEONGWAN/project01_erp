<%@page import="java.text.NumberFormat"%>
<%@page import="dao.SalesDao"%>
<%@page import="dto.SalesDto"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
request.setCharacterEncoding("utf-8");

// 1) 날짜 정규화
String startRaw = request.getParameter("start");
String endRaw   = request.getParameter("end");

String start = (startRaw != null && !startRaw.isEmpty() && startRaw.matches("\\d{4}-\\d{2}-\\d{2}")) ? startRaw : null;
String end   = (endRaw   != null && !endRaw.isEmpty()   && endRaw.matches("\\d{4}-\\d{2}-\\d{2}"))   ? endRaw   : null;

boolean hasFilter = (start != null && end != null);

// 2) 페이징
int pageNum = 1;
try {
    if (request.getParameter("pageNum") != null) pageNum = Integer.parseInt(request.getParameter("pageNum"));
} catch (NumberFormatException ignore) {}

int pageSize = 10;
int startRow = (pageNum - 1) * pageSize + 1;
int endRow   = pageNum * pageSize;

// 3) DAO 호출은 안전 기본값으로 통일
String startSafe = hasFilter ? start : "2000-01-01";
String endSafe   = hasFilter ? end   : "2099-12-31";

SalesDao dao = SalesDao.getInstance();
int totalRows = dao.getMonthlyStatsCountBetween(startSafe, endSafe);
List<SalesDto> list = dao.getMonthlyStatsPageBetween(startSafe, endSafe, startRow, endRow);

int totalPages = Math.max(1, (int)Math.ceil(totalRows / (double)pageSize));
NumberFormat nf = NumberFormat.getInstance();

// 4) 랩퍼(sales.jsp) 경유 링크 (CSS 유지)
String base  = request.getContextPath() + "/headquater.jsp?page=headquater/sales.jsp&view=monthly";
String extra = hasFilter ? "&start=" + start + "&end=" + end : "";
%>

<h2 class="mb-2">지점별 월간 매출 총합</h2>

<div class="table-responsive">
  <table class="table table-hover align-middle">
    <thead class="table-secondary">
      <tr>
        <th>번호</th>
        <th>월</th>
        <th>지점</th>
        <th>총 매출</th>
      </tr>
    </thead>
    <tbody>
      <%
        int index = startRow;
        for (SalesDto dto : list) {
      %>
      <tr>
        <td><%= index++ %></td>
        <td><%= dto.getPeriod() %></td>
        <td><%= dto.getBranch_name() %></td>
        <td><%= nf.format(dto.getTotalSales()) %> 원</td>
      </tr>
      <% } %>
      <% if (list == null || list.isEmpty()) { %>
      <tr><td colspan="4" class="text-center text-muted">데이터가 없습니다.</td></tr>
      <% } %>
    </tbody>
  </table>
</div>

<nav aria-label="Page navigation">
  <ul class="pagination justify-content-center">
    <li class="page-item <%= (pageNum <= 1 ? "disabled" : "") %>">
      <a class="page-link" href="<%= base + extra %>&pageNum=<%= Math.max(1, pageNum - 1) %>">이전</a>
    </li>
    <li class="page-item active"><span class="page-link"><%= pageNum %></span></li>
    <li class="page-item <%= (pageNum >= totalPages ? "disabled" : "") %>">
      <a class="page-link" href="<%= base + extra %>&pageNum=<%= Math.min(totalPages, pageNum + 1) %>">다음</a>
    </li>
  </ul>
</nav>
