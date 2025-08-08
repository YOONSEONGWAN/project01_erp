<%@ page import="java.text.NumberFormat" %>
<%@ page import="dao.SalesDao" %>
<%@ page import="dto.SalesDto" %>
<%@ page import="java.util.List" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    request.setCharacterEncoding("utf-8");

    String start = request.getParameter("start");
    String end = request.getParameter("end");

    int pageNum = 1;
    if (request.getParameter("pageNum") != null) {
        pageNum = Integer.parseInt(request.getParameter("pageNum"));
    }

    int pageSize = 10;
    int startRow = (pageNum - 1) * pageSize + 1;
    int endRow = pageNum * pageSize;

    SalesDao dao = SalesDao.getInstance();

    boolean hasFilter = start != null && end != null && !start.isEmpty() && !end.isEmpty();

    List<SalesDto> list;
    int totalRows;

    if (hasFilter) {
        totalRows = dao.getMonthlyRankStatsCountBetween(start, end);
        list = dao.getMonthlyRankStatsPageBetween(start, end, startRow, endRow);
    } else {
        totalRows = dao.getMonthlyRankStatsCountBetween("2000-01-01", "2099-12-31");
        list = dao.getMonthlyRankStatsPageBetween("2000-01-01", "2099-12-31", startRow, endRow);
    }

    int totalPages = (int) Math.ceil(totalRows / (double) pageSize);
    NumberFormat nf = NumberFormat.getInstance();
%>

<h2 class="mb-2">지점별 월간 매출 순위</h2>
<div class="table-responsive">
    <table class="table table-hover align-middle">
        <thead class="table-secondary">
            <tr>
                <th>번호</th>
                <th>월</th>
                <th>지점명</th>
                <th>총 매출액</th>
                <th>순위</th>
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
                <td><%= dto.getRank() %> 위</td>
            </tr>
            <% } %>
        </tbody>
    </table>
</div>

<nav>
    <ul class="pagination justify-content-center">
        <%
            for (int i = 1; i <= totalPages; i++) {
        %>
        <li class="page-item <%= i == pageNum ? "active" : "" %>">
            <a class="page-link"
               href="<%= request.getContextPath() %>/headquater.jsp?page=headquater/sales.jsp<%= start != null ? "&start=" + start : "" %><%= end != null ? "&end=" + end : "" %>&view=monthly-rank&pageNum=<%= i %>">
                <%= i %>
            </a>
        </li>
        <% } %>
    </ul>
</nav>
