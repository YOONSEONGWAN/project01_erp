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
        /* 화면 전체 높이, 플렉스박스 중앙 정렬 */
        html, body {
            height: 100%;
            margin: 0;
            background-color: #f8f9fa;
        }
        body {
    background-color: #f8f9fa;
    min-height: 100vh;

    /* 기존 중앙 정렬 제거 */
    /* display: flex; */
    /* flex-direction: column; */
    /* justify-content: center; */
    /* align-items: center; */

    margin: 0;
    padding: 20px;
}
        .container {
            max-width: 960px;
            width: 100%;
            max-height: calc(100vh - 80px); /* padding 위아래 40px씩 빼고 남은 공간 */
            overflow-y: auto; /* 내용이 길면 스크롤 */
            background: #fff;
            padding: 20px 30px;
            box-shadow: 0 0 8px rgba(0,0,0,0.1);
            border-radius: 4px;
            box-sizing: border-box;
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
        /* 페이지네비게이션 스타일 */
        .pagination {
            display: flex;
            list-style: none;
            padding-left: 0;
            justify-content: center;
            gap: 5px;
            margin-top: 15px;
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
        .text-center {
            text-align: center;
            margin-top: 20px;
        }
    </style>
</head>
<body>
<div class="container">
    <nav aria-label="breadcrumb" style="margin-bottom: 20px;">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath }/headquater.jsp">홈</a></li>
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/headquater.jsp?page=/stock/placeorder.jsp">발주 관리</a></li>
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/headquater.jsp?page=/stock/placeorder_head.jsp">본사 발주</a></li>
            <li class="breadcrumb-item active" aria-current="page"> 전체 발주 내역</li>
        </ol>
    </nav>
    <h2>전체 발주 내역</h2>

    <form class="search-bar" method="get" action="${pageContext.request.contextPath}/headquater.jsp?page=/stock/placeorder_head_all.jsp?managerKeyword=amin">
        <input type="text" name="managerKeyword" class="form-control form-control-sm me-2"
               style="max-width: 200px;"
               placeholder="담당자 검색" value="<%= managerKeyword %>">
        <button type="submit" class="btn btn-primary btn-sm">검색</button>
    </form>

    <div class="table-responsive">
        <table class="table table-bordered table-hover">
            <thead>
                <tr>
                    <th>발주 ID</th>
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
                            <a href="${pageContext.request.contextPath}/headquater.jsp?page=/stock/placeorder_head_detail.jsp?order_id=<%= order.getOrder_id() %>"
                               class="btn btn-sm btn-outline-primary">상세 보기</a>
                        </td>
                    </tr>
                <% }} %>
            </tbody>
        </table>
    </div>

    <!-- 페이지네비게이션 -->
    <nav aria-label="Page navigation">
        <ul class="pagination pagination-sm">
            <% if (currentPage > 1) { %>
                <li class="page-item">
                    <a class="page-link" href="${pageContext.request.contextPath}/headquater.jsp?page=/stock/placeorder_head_all.jsp?page=<%= currentPage -1 %>&managerKeyword=<%= managerKeyword %>">이전</a>
                </li>
            <% } else { %>
                <li class="page-item disabled"><span class="page-link">이전</span></li>
            <% } %>

            <% for (int i = 1; i <= totalPages; i++) {
                if (i == currentPage) { %>
                    <li class="page-item active"><span class="page-link"><%= i %></span></li>
                <% } else { %>
                    <li class="page-item">
                        <a class="page-link" href="${pageContext.request.contextPath}/headquater.jsp?page=/stock/placeorder_head_all.jsp?page=<%= i %>&managerKeyword=<%= managerKeyword %>"><%= i %></a>
                    </li>
            <% }} %>

            <% if (currentPage < totalPages) { %>
                <li class="page-item">
                    <a class="page-link" href="${pageContext.request.contextPath}/headquater.jsp?page=/stock/placeorder_head_all.jsp?page=<%= currentPage +1 %>&managerKeyword=<%= managerKeyword %>">다음</a>
                </li>
            <% } else { %>
                <li class="page-item disabled"><span class="page-link">다음</span></li>
            <% } %>
        </ul>
    </nav>

    
</div>
</body>
</html>