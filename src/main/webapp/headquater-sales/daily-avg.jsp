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

    int totalRows;
    List<SalesDto> list;

    if (hasFilter) {
        totalRows = dao.getDailyAvgCountBetween(start, end);
        list = dao.getDailyAvgSalesPageBetween(start, end, startRow, endRow);
    } else {
        totalRows = dao.getDailyAvgCount(); // ← 구현 필요
        list = dao.getDailyAvgSalesPage(startRow, endRow); // ← 구현 필요
    }

    int totalPages = (int)Math.ceil(totalRows / (double)pageSize);

    NumberFormat nf = NumberFormat.getInstance();
%>

<h2 class="mb-2">일 평균 매출 (지점별)</h2>
<div class="table-responsive">
	<table class="table table-hover align-middle">
	    <thead class="table-secondary">
	        <tr>
	            <th>번호</th>
	            <th>지점</th>
	            <th>총 매출</th>
	            <th>활동 일수</th>
	            <th>일 평균 매출</th>
	        </tr>
	    </thead>
	    <tbody>
	        <%
	            int index = startRow;
	            for (SalesDto dto : list) {
	        %>
	        <tr>
	            <td><%= index++ %></td>
	            <td><%= dto.getBranch_name() %></td>
	            <td><%= nf.format(dto.getTotalSales()) %> 원</td>
	            <td><%= dto.getDayCount() %> 일</td>
	            <td><%= nf.format(dto.getAverageSalesPerDay()) %> 원</td>
	        </tr>
	        <% } %>
	    </tbody>
	</table>
</div>
<nav>
    <ul class="pagination justify-content-center">
        <% for (int i = 1; i <= totalPages; i++) { %>
            <li class="page-item <%= i == pageNum ? "active" : "" %>">
                <a class="page-link" href="?view=daily-avg
<%= hasFilter ? "&start=" + start + "&end=" + end : "" %>
&pageNum=<%=i%>"><%=i%></a>
            </li>
        <% } %>
    </ul>
</nav>
