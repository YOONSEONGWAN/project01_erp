<%@page import="java.util.List"%>
<%@page import="dto.stock.PlaceOrderBranchDto"%>
<%@page import="dao.stock.PlaceOrderBranchDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    // 검색어
    String managerKeyword = request.getParameter("managerKeyword");
    if (managerKeyword == null) managerKeyword = "";

    // 페이지 번호 처리
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
    int totalCount = PlaceOrderBranchDao.getInstance().countByManager(managerKeyword);
    int totalPages = (int) Math.ceil(totalCount / (double) pageSize);

    int startRow = (currentPage - 1) * pageSize + 1;
    int endRow = currentPage * pageSize;

    List<PlaceOrderBranchDto> list = PlaceOrderBranchDao.getInstance()
        .selectByManagerWithPaging(managerKeyword, startRow, endRow);
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>전체 발주 내역 (지점)</title>
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
            padding: 8px;
        }
        table td {
            text-align: center;
            vertical-align: middle;
            padding: 6px;
        }
    </style>
</head>
<body>

<div class="container">
    <h2>전체 발주 내역 (지점)</h2>

    <form method="get" action="placeorder_branch_all.jsp" class="search-bar">
        <input type="text" name="managerKeyword" class="form-control form-control-sm me-2"
               placeholder="담당자 검색" style="max-width:200px;" value="<%= managerKeyword %>">
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
                    <tr><td colspan="4">내역이 없습니다.</td></tr>
                <% } else {
                    for (PlaceOrderBranchDto dto : list) { %>
                    <tr>
                        <td><a href="placeorder_branch_detail.jsp?order_id=<%= dto.getOrder_id() %>">
                            <%= dto.getOrder_id() %>
                        </a></td>
                        <td><%= dto.getDate() %></td>
                        <td><%= dto.getManager() %></td>
                        <td>
                            <a href="placeorder_branch_detail.jsp?order_id=<%= dto.getOrder_id() %>"
                               class="btn btn-sm btn-outline-primary">상세 보기</a>
                        </td>
                    </tr>
                <% }} %>
            </tbody>
        </table>
    </div>

    <!-- 페이징 -->
    <nav aria-label="Page navigation">
        <ul class="pagination justify-content-center pagination-sm">
            <% if (currentPage > 1) { %>
                <li class="page-item">
                    <a class="page-link" href="placeorder_branch_all.jsp?page=<%= currentPage-1 %>&managerKeyword=<%= managerKeyword %>">이전</a>
                </li>
            <% } else { %>
                <li class="page-item disabled"><span class="page-link">이전</span></li>
            <% } %>

            <% for (int i = 1; i <= totalPages; i++) {
                if (i == currentPage) { %>
                    <li class="page-item active"><span class="page-link"><%= i %></span></li>
                <% } else { %>
                    <li class="page-item">
                        <a class="page-link" href="placeorder_branch_all.jsp?page=<%= i %>&managerKeyword=<%= managerKeyword %>"><%= i %></a>
                    </li>
            <% }} %>

            <% if (currentPage < totalPages) { %>
                <li class="page-item">
                    <a class="page-link" href="placeorder_branch_all.jsp?page=<%= currentPage+1 %>&managerKeyword=<%= managerKeyword %>">다음</a>
                </li>
            <% } else { %>
                <li class="page-item disabled"><span class="page-link">다음</span></li>
            <% } %>
        </ul>
    </nav>

    <div class="text-center mt-3">
        <a href="placeorder_branch.jsp" class="btn btn-outline-secondary btn-sm">돌아가기</a>
    </div>
</div>

</body>
</html>