<%@ page import="java.text.NumberFormat" %>
<%@ page import="dao.SalesDao" %>
<%@ page import="dto.SalesDto" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.*" %>
<%@ page import="java.time.temporal.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%!
    private String formatWeekLabel(String isoYearWeek) {
        try {
            String[] parts = isoYearWeek.split("-W");
            int y = Integer.parseInt(parts[0]);
            int w = Integer.parseInt(parts[1]);
            LocalDate weekStart = LocalDate.now()
                    .with(IsoFields.WEEK_BASED_YEAR, y)
                    .with(IsoFields.WEEK_OF_WEEK_BASED_YEAR, w)
                    .with(ChronoField.DAY_OF_WEEK, 1);
            WeekFields wf = WeekFields.ISO;
            int month = weekStart.getMonthValue();
            int weekOfMonth = weekStart.get(wf.weekOfMonth());
            return String.format("%d년 %d월 %d주차", y, month, weekOfMonth);
        } catch (Exception e) {
            return isoYearWeek;
        }
    }
%>

<%
    request.setCharacterEncoding("utf-8");
    String startRaw = request.getParameter("start");
    String endRaw   = request.getParameter("end");
    String start = (startRaw != null && !startRaw.isEmpty() && startRaw.matches("\\d{4}-\\d{2}-\\d{2}")) ? startRaw : null;
    String end   = (endRaw   != null && !endRaw.isEmpty()   && endRaw.matches("\\d{4}-\\d{2}-\\d{2}"))   ? endRaw : null;
    boolean hasFilter = (start != null && end != null);
    String startSafe = hasFilter ? start : "2000-01-01";
    String endSafe   = hasFilter ? end   : "2099-12-31";
    int pageNum = 1;
    try { if (request.getParameter("pageNum") != null) pageNum = Integer.parseInt(request.getParameter("pageNum")); } catch (Exception ignore) {}
    int pageSize = 10;
    int startRow = (pageNum - 1) * pageSize + 1;
    int endRow   = pageNum * pageSize;
    SalesDao dao = SalesDao.getInstance();
    int totalRows = dao.getWeeklyMinStatsCountBetween(startSafe, endSafe);
    List<SalesDto> list = dao.getWeeklyMinStatsPageBetween(startSafe, endSafe, startRow, endRow);
    int totalPages = Math.max(1, (int) Math.ceil(totalRows / (double) pageSize));
    NumberFormat nf = NumberFormat.getInstance();
    String base  = request.getContextPath() + "/headquater.jsp?page=headquater/sales.jsp&view=weekly-min";
    String extra = hasFilter ? "&start=" + start + "&end=" + end : "";
%>

<h2 class="mb-2">지점별 주간 최저 매출일</h2>

<div class="table-responsive">
  <table class="table table-hover align-middle">
    <thead class="table-secondary">
      <tr>
        <th>번호</th>
        <th>주차</th>
        <th>지점</th>
        <th>최저 매출일</th>
        <th>매출 금액</th>
      </tr>
    </thead>
    <tbody>
      <%
        if (list != null && !list.isEmpty()) {
          int index = startRow;
          for (SalesDto dto : list) {
      %>
      <tr>
        <td><%= index++ %></td>
        <td><%= formatWeekLabel(dto.getPeriod()) %></td>
        <td><%= dto.getBranch_name() %></td>
        <td><%= dto.getMinSalesDate() %></td>
        <td><%= nf.format(dto.getTotalSales()) %> 원</td>
      </tr>
      <%
          }
        } else {
      %>
      <tr>
        <td colspan="5" class="text-center text-muted">해당 조건에 맞는 주간 최저 매출일 데이터가 없습니다.</td>
      </tr>
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
