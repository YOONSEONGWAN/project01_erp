<%@page import="java.util.List"%>
<%@page import="dto.stock.PlaceOrderHeadDto"%>
<%@page import="dao.stock.PlaceOrderHeadDao"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    // 검색 처리
    String managerKeyword = request.getParameter("managerKeyword");
    if (managerKeyword == null) managerKeyword = "";

    // 페이지 처리
    int currentPage = 1;
    String pageParam = request.getParameter("page");
    if (pageParam != null) {
        try {
            currentPage = Integer.parseInt(pageParam);
            if (currentPage < 1) currentPage = 1;
        } catch (Exception e) {
            currentPage = 1;
        }
    }

    int pageSize = 10;
    int totalCount = PlaceOrderHeadDao.getInstance().countByManager(managerKeyword);
    int totalPages = (int) Math.ceil(totalCount / (double)pageSize);

    List<PlaceOrderHeadDto> list = PlaceOrderHeadDao.getInstance()
        .selectByManagerWithPaging(managerKeyword, currentPage, pageSize);
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>전체 발주 내역</title>
    <jsp:include page="/WEB-INF/include/resource.jsp"/>

    <style>
        body {
            background-color: #f8f9fa;
        }
        .container {
            max-width: 960px;
            margin: 40px auto;
        }
        h2 {
            text-align: center;
            font-weight: bold;
            margin-bottom: 20px;
        }
        .search-bar {
            display: flex;
            justify-content: flex-end;
            margin-bottom: 10px;
        }
        table th {
            background-color: #007bff !important;
            color: white !important;
            text-align: center;
        }
        table td {
            text-align: center;
            vertical-align: middle;
        }
    </style>
</head>
<body>
<div class="container">

    <h2>전체 발주 내역</h2>

    <form class="search-bar" method="get" action="placeorder_head_all.jsp">
        <input type="text" name="managerKeyword" class="form-control form-control-sm me-2"
               style="max-width: 200px;"
               placeholder="담당자 검색" value="<%= managerKeyword %>">
        <button type="submit" class="btn btn-primary btn-sm">검색</button>
    </form>

    <div class="table-responsive">
        <table class="table table-bordered table-hover">
            <thead>
                <tr>
                    <th>Order ID</th>
                    <th>발주일</th>
                    <th>담당자</th>
                    <th>상세 보기</th>
                </tr>
            </thead>
            <tbody>
                <% if (list == null || list.isEmpty()) { %>
                    <tr><td colspan="4">발주 내역이 없습니다.</td></tr>
                <% } else {
                    for (PlaceOrderHeadDto order : list) { %>
                    <tr>
                        <td><%= order.getOrder_id() %></td>
                        <td><%= order.getOrder_date() %></td>
                        <td><%= order.getManager() %></td>
                        <td>
                            <a href="placeorder_head_detail.jsp?order_id=<%= order.getOrder_id() %>"
                               class="btn btn-sm btn-outline-primary">상세 보기</a>
                        </td>
                    </tr>
                <% }} %>
            </tbody>
        </table>
    </div>

    <!-- 페이지네비게이션 -->
    <nav aria-label="Page navigation">
        <ul class="pagination justify-content-center pagination-sm">
            <% if (currentPage > 1) { %>
                <li class="page-item">
                    <a class="page-link" href="placeorder_head_all.jsp?page=<%= currentPage -1 %>&managerKeyword=<%= managerKeyword %>">이전</a>
                </li>
            <% } else { %>
                <li class="page-item disabled"><span class="page-link">이전</span></li>
            <% } %>

            <% for (int i = 1; i <= totalPages; i++) {
                if (i == currentPage) { %>
                    <li class="page-item active"><span class="page-link"><%= i %></span></li>
                <% } else { %>
                    <li class="page-item">
                        <a class="page-link" href="placeorder_head_all.jsp?page=<%= i %>&managerKeyword=<%= managerKeyword %>"><%= i %></a>
                    </li>
            <% }} %>

            <% if (currentPage < totalPages) { %>
                <li class="page-item">
                    <a class="page-link" href="placeorder_head_all.jsp?page=<%= currentPage +1 %>&managerKeyword=<%= managerKeyword %>">다음</a>
                </li>
            <% } else { %>
                <li class="page-item disabled"><span class="page-link">다음</span></li>
            <% } %>
        </ul>
    </nav>

    <div class="text-center">
        <a href="placeorder.jsp" class="btn btn-outline-secondary btn-sm">돌아가기</a>
    </div>
</div>
</body>
</html>