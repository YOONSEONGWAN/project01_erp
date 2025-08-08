<%@page import="java.text.NumberFormat"%>
<%@page import="dao.SalesDao"%>
<%@page import="dto.SalesDto"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
        // ✅ getWeeklyMaxSalesDatesBetween 메소드 호출 (페이징 적용)
        totalRows = dao.getWeeklyMaxCountBetween(start, end);
        list = dao.getWeeklyMaxSalesDatesBetween(start, end, startRow, endRow);
    } else {
        // ✅ getWeeklyMaxSalesDates 메소드 호출 (페이징 적용)
        totalRows = dao.getWeeklyMaxCountBetween("2000-01-01", "2099-12-31"); // 전체 기간에 대한 카운트
        list = dao.getWeeklyMaxSalesDates("2000-01-01", "2099-12-31", startRow, endRow); // 전체 기간에 대한 페이징 데이터
    }

    int totalPages = (int)Math.ceil(totalRows / (double)pageSize);
    NumberFormat nf = NumberFormat.getInstance();
%>

<h2 class="mb-2">지점별 주간 최고 매출일</h2>

<table class="table table-bordered">
    <thead class="table-light">
        <tr>
            <th>번호</th>
            <th>주차</th>
            <th>지점</th>
            <th>최고 매출일</th>
            <th>매출액</th>
        </tr>
    </thead>
    <tbody>
        <%
            if (list != null && !list.isEmpty()) { // 리스트가 비어있지 않을 때만 반복
                int index = startRow; // 시작 번호를 페이징에 맞게 설정
                for (SalesDto dto : list) {
        %>
        <tr>
            <td><%= index++ %></td>
            <td><%= dto.getPeriod() %></td>
            <td><%= dto.getBranch_name() %></td>
            <td><%= dto.getMaxSalesDate() %></td> <%-- ✅ getMaxSalesDate()로 변경 --%>
            <td><%= nf.format(dto.getTotalSales()) %> 원</td>
        </tr>
        <%
                }
            } else {
        %>
            <tr>
                <td colspan="5" class="text-center text-muted">해당 조건에 맞는 주간 최고 매출일 데이터가 없습니다.</td>
            </tr>
        <%
            }
        %>
    </tbody>
</table>

<nav>
    <ul class="pagination justify-content-center">
        <%
            // 페이지네이션 링크를 위한 쿼리 파라미터 구성
            String queryParams = "";
            if (start != null && !start.isEmpty()) queryParams += "&start=" + start;
            if (end != null && !end.isEmpty()) queryParams += "&end=" + end;
            queryParams += "&view=weekly-max"; // 현재 뷰 유지
        %>
        <% for (int i = 1; i <= totalPages; i++) { %>
        <li class="page-item <%= i == pageNum ? "active" : "" %>">
            <a class="page-link"
                href="<%= request.getContextPath() %>/headquater.jsp?page=headquater/sales.jsp<%= queryParams %>&pageNum=<%=i%>">
                <%= i %>
            </a>
        </li>
        <% } %>
    </ul>
</nav>
