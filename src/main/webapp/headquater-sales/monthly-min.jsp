<%@page import="java.text.NumberFormat"%>
<%@page import="dao.SalesDao"%>
<%@page import="dto.SalesDto"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
        totalRows = dao.getMonthlyMinStatsCountBetween(start, end);
        list = dao.getMonthlyMinStatsPageBetween(start, end, startRow, endRow);
    } else {
        totalRows = dao.getMonthlyMinStatsCountBetween("2000-01-01", "2099-12-31");
        list = dao.getMonthlyMinStatsPageBetween("2000-01-01", "2099-12-31", startRow, endRow);
    }

    int totalPages = (int)Math.ceil(totalRows / (double)pageSize);
    NumberFormat nf = NumberFormat.getInstance();
%>

<h2 class="mb-2">월간 최저 매출일</h2>

<form method="get" class="row g-3 mb-3">
    <div class="col-auto">
        <label for="start" class="col-form-label">시작일</label>
    </div>
    <div class="col-auto">
        <input type="date" id="start" name="start" class="form-control" value="<%= start != null ? start : "" %>">
    </div>
    <div class="col-auto">
        <label for="end" class="col-form-label">종료일</label>
    </div>
    <div class="col-auto">
        <input type="date" id="end" name="end" class="form-control" value="<%= end != null ? end : "" %>">
    </div>
    <div class="col-auto">
        <button type="submit" class="btn btn-primary">조회</button>
    </div>
</form>

<table class="table table-bordered">
    <thead class="table-light">
        <tr>
            <th>번호</th>
            <th>월</th>
            <th>지점</th>
            <th>매출일자</th>
            <th>매출금액</th>
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
            <td><%= dto.getCreated_at() %></td>
            <td><%= nf.format(dto.getTotalSales()) %> 원</td>
        </tr>
        <% } %>
    </tbody>
</table>

<nav>
    <ul class="pagination justify-content-center">
        <% for (int i = 1; i <= totalPages; i++) { %>
        <li class="page-item <%= i == pageNum ? "active" : "" %>">
            <a class="page-link"
               href="<%= request.getContextPath() %>/headquater.jsp?page=headquater/sales.jsp<%= start != null ? "&start=" + start : "" %><%= end != null ? "&end=" + end : "" %>&view=monthly-min&pageNum=<%=i%>">
                <%= i %>
            </a>
        </li>
        <% } %>
    </ul>
</nav>
