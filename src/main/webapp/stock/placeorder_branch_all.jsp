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
  html, body {
    height: 100%;
    margin: 0;
    background-color: #f8f9fa;
}
body {
    background-color: #f8f9fa;
    min-height: 100vh;
    margin: 0;
    padding: 0px;
}
.container {
    max-width: 960px;
    width: 100%;
    max-height: calc(100vh - 80px);
    overflow-y: auto;
    background: #fff;
    padding: 20px 30px;
    box-shadow: 0 0 8px rgba(0,0,0,0.1);
    border-radius: 4px;
    box-sizing: border-box;
}
h2 {
    text-align: left;
    font-weight: bold;
    margin-bottom: 20px;
    font-size: 24px;
    color: #212529;
}
.search-bar {
    display: flex;
    justify-content: flex-end;
    margin-bottom: 10px;
    gap: 8px;
}
table {
    width: 100%;
    border-collapse: collapse;
}
thead tr {
    background-color: #e1e4e8;
}
thead th {
    color: #212529;
    padding: 0.5rem 0.75rem;
    text-align: center;
    font-weight: 600;
    border-bottom: 2px solid #dee2e6;
}
tbody td {
    padding: 0.45rem 0.75rem;
    border-top: 1px solid #dee2e6;
    text-align: center;
    vertical-align: middle;
}
.btn {
    cursor: pointer;
    border: 1px solid transparent;
    padding: 0.25rem 0.6rem;
    font-size: 0.875rem;
    border-radius: 4px;
    transition: all 0.2s ease-in-out;
    text-decoration: none;
    display: inline-block;
}
.btn-primary {
    background-color: #003366 !important;
    border-color: #003366 !important;
    color: white !important;
    font-weight: 500;
}
.btn-primary:hover {
    background-color: #002244 !important;
    border-color: #002244 !important;
    color: white !important;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
}
.btn-outline-primary {
    color: #003366;
    border-color: #003366;
    background-color: transparent;
}
.btn-outline-primary:hover {
    background-color: #003366;
    color: white;
}

.pagination {
    display: inline-flex;        /* 버튼들이 한 줄에 붙게 */
    border: 1px solid #1a2c49;  /* 전체 테두리 */
    border-radius: 6px;          /* 전체 둥근 테두리 */
    overflow: hidden;            /* 둥근 테두리에서 버튼 넘치지 않도록 */
    padding: 0;
    margin-top: 20px;
    justify-content: center !important;
}

.pagination .page-item {
    margin: 0;                   /* 버튼 사이 간격 제거 */
}

.pagination .page-link {
    border: none;                /* 개별 버튼 테두리 제거 */
    padding: 6px 16px;
    font-size: 14px;
    color: #1a2c49;
    background-color: white;
    cursor: pointer;
    user-select: none;
    display: block;
    transition: background-color 0.2s ease;
}

.pagination .page-item.active .page-link {
    background-color: #1a2c49;
    color: white;
    cursor: default;
    pointer-events: none;
}

.pagination .page-item.disabled .page-link {
    color: #6c757d;
    background-color: white;
    cursor: default;
    pointer-events: none;
}

.pagination .page-link:hover:not(.disabled):not(.active) {
    background-color: #e9ecef;
    color: #1a2c49;
}

/* 버튼들 사이에만 좌우 구분선 추가 */
.pagination .page-item:not(:last-child) .page-link {
    border-right: 1px solid #1a2c49;
}
.pagination .page-item:first-child .page-link,
.pagination .page-item:last-child .page-link {
    color: #1a2c49 !important;
}

.btn-outline-light {
    color: white !important;
    border-color: white !important;
    background-color: transparent !important;
    transition: all 0.2s ease-in-out;
}

.btn-outline-light:hover {
    background-color: white !important;
    color: #003366 !important;
    border-color: white !important;
}
</style>
</head>
<body>

<div class="container">
    <nav aria-label="breadcrumb" style="margin-bottom: 20px;">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/headquater.jsp">홈</a></li>
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/headquater.jsp?page=/stock/placeorder.jsp">발주 관리</a></li>
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/headquater.jsp?page=/stock/placeorder_branch.jsp">지점 발주</a></li>
            <li class="breadcrumb-item active" aria-current="page">전체 발주 내역</li>
        </ol>
    </nav>

    <h2>전체 발주 내역 (지점)</h2>

    <form method="get" action="${pageContext.request.contextPath}/headquater.jsp" class="search-bar">
	    <input type="hidden" name="page" value="/stock/placeorder_branch_all.jsp" />
	    <input type="text" name="managerKeyword" class="form-control form-control-sm me-2"
	           placeholder="담당자 검색" style="max-width:200px;" value="<%= managerKeyword %>">
	    <button type="submit" class="btn btn-primary btn-sm">검색</button>
	</form>

    <div class="table-responsive">
        <table class="table  table-hover">
            <thead class="table-secondary">
                <tr>
                    <th>발주 ID</th>
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
                            <a href="${pageContext.request.contextPath}/headquater.jsp?page=/stock/placeorder_branch_detail.jsp?order_id=<%= dto.getOrder_id() %>">
                                <%= dto.getOrder_id() %>
                            </a>
                        </td>
                        <td><%= dto.getDate() %></td>
                        <td><%= dto.getManager() %></td>
                        <td>
                            <a href="${pageContext.request.contextPath}/headquater.jsp?page=/stock/placeorder_branch_detail.jsp?order_id=<%= dto.getOrder_id() %>"
                               >상세</a>
                        </td>
                    </tr>
                <% }} %>
            </tbody>
        </table>
    </div>

     <!-- 페이징 -->
    <nav aria-label="Page navigation" style="text-align: center;">
        <ul class="pagination pagination-sm">
            <% if (currentPage > 1) { %>
                <li class="page-item">
                    <a class="page-link" href="${pageContext.request.contextPath}/headquater.jsp?page=/stock/placeorder_branch_all.jsp&page=<%= currentPage-1 %>&managerKeyword=<%= managerKeyword %>">이전</a>
                </li>
            <% } else { %>
                <li class="page-item disabled"><span class="page-link">이전</span></li>
            <% } %>

            <% for (int i = 1; i <= totalPages; i++) {
                if (i == currentPage) { %>
                    <li class="page-item active"><span class="page-link"><%= i %></span></li>
                <% } else { %>
                    <li class="page-item">
                        <a class="page-link" href="${pageContext.request.contextPath}/headquater.jsp?page=/stock/placeorder_branch_all.jsp&page=<%= i %>&managerKeyword=<%= managerKeyword %>"><%= i %></a>
                    </li>
            <% }} %>

            <% if (currentPage < totalPages) { %>
                <li class="page-item">
                    <a class="page-link" href="${pageContext.request.contextPath}/headquater.jsp?page=/stock/placeorder_branch_all.jsp&page=<%= currentPage+1 %>&managerKeyword=<%= managerKeyword %>">다음</a>
                </li>
            <% } else { %>
                <li class="page-item disabled"><span class="page-link">다음</span></li>
            <% } %>
        </ul>
    </nav>

    
</div>

</body>