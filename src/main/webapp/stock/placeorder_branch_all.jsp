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
        /* 전체 화면 높이와 플렉스 박스로 중앙 정렬 */
        html, body {
            height: 100%;
            margin: 0;
        }
        body {
            background-color: #f8f9fa;
            display: flex;
            justify-content: center; /* 가로 중앙 */
            align-items: center;     /* 세로 중앙 */
            padding: 20px;
            box-sizing: border-box;
            min-height: 100vh;
        }
        .container {
            max-width: 960px;
            width: 100%;
            background: white;
            padding: 20px;
            box-shadow: 0 0 8px rgba(0,0,0,0.1);
            border-radius: 4px;
            box-sizing: border-box;
            /* 내용이 너무 길 때 스크롤 가능하도록 제한 높이 지정 (옵션) */
            max-height: 90vh;
            overflow-y: auto;
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
        table {
            width: 100%;
            border-collapse: collapse;
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
        .text-center {
            text-align: center;
        }
        .btn {
            cursor: pointer;
            border: 1px solid transparent;
            padding: 0.25rem 0.5rem;
            font-size: 0.875rem;
            border-radius: 0.2rem;
            transition: background-color 0.15s ease-in-out;
            display: inline-block;
            text-decoration: none;
        }
        .btn-primary {
            background-color: #007bff;
            color: white;
            border-color: #007bff;
        }
        .btn-primary:hover {
            background-color: #0056b3;
            border-color: #004085;
            color: white;
        }
        .btn-outline-primary {
            color: #007bff;
            border-color: #007bff;
            background-color: transparent;
        }
        .btn-outline-primary:hover {
            background-color: #007bff;
            color: white;
        }
        .btn-outline-secondary {
            color: #6c757d;
            border-color: #6c757d;
            background-color: transparent;
        }
        .btn-outline-secondary:hover {
            background-color: #6c757d;
            color: white;
        }
        /* 페이징 스타일 */
        .pagination {
            display: flex;
            list-style: none;
            padding-left: 0;
            justify-content: center;
            gap: 5px;
        }
        .pagination .page-item {
            display: inline;
        }
        .pagination .page-link {
            color: #007bff;
            text-decoration: none;
            padding: 4px 8px;
            border: 1px solid #dee2e6;
            border-radius: 0.25rem;
            cursor: pointer;
            user-select: none;
            display: inline-block;
        }
        .pagination .page-item.disabled .page-link,
        .pagination .page-item.disabled .page-link:hover {
            color: #6c757d;
            pointer-events: none;
            background-color: #fff;
            border-color: #dee2e6;
            cursor: default;
        }
        .pagination .page-item.active .page-link {
            background-color: #007bff;
            border-color: #007bff;
            color: white;
            cursor: default;
        }
    </style>
</head>
<body>

<div class="container">
    <nav aria-label="breadcrumb" style="margin-bottom: 20px;">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/index/headquaterindex.jsp">홈</a></li>
            <li class="breadcrumb-item"><a href="placeorder.jsp">발주 관리</a></li>
            <li class="breadcrumb-item"><a href="placeorder_branch.jsp">지점 발주</a></li>
            <li class="breadcrumb-item active" aria-current="page">전체 발주 내역</li>
        </ol>
    </nav>

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
                        <td>
                            <a href="placeorder_branch_detail.jsp?order_id=<%= dto.getOrder_id() %>">
                                <%= dto.getOrder_id() %>
                            </a>
                        </td>
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
        <ul class="pagination pagination-sm">
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