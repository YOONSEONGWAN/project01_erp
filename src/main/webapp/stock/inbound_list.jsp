<%@page import="dao.stock.InboundOrdersDao"%>
<%@page import="dto.stock.InboundOrdersDto"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    // 페이지 번호, 기본값 1
    int currentPage = 1;
    String pageParam = request.getParameter("page");
    if (pageParam != null) {
        try {
            currentPage = Integer.parseInt(pageParam);
            if (currentPage < 1) currentPage = 1;
        } catch (NumberFormatException e) {
            currentPage = 1;
        }
    }

    // 담당자 검색어
    String managerKeyword = request.getParameter("managerKeyword");
    if (managerKeyword == null) managerKeyword = "";

    int pageSize = 10;  // 한 페이지에 보여줄 데이터 개수

    // DAO에서 해당 페이지, 검색어 기준 데이터 조회
    List<InboundOrdersDto> list = InboundOrdersDao.getInstance().selectByManagerWithPaging(managerKeyword, currentPage, pageSize);

    // 전체 데이터 수 조회 (페이징 계산용)
    int totalCount = InboundOrdersDao.getInstance().countByManager(managerKeyword);
    int totalPages = (int) Math.ceil(totalCount / (double) pageSize);
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>전체 입고 내역</title>

    <!-- 부트스트랩 CSS 포함 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        table thead th {
            background-color: #007bff !important;
            color: white !important;
        }

        .search-form input[type="text"] {
            width: 200px;
        }
    </style>
</head>
<body class="bg-light">

<div class="container py-5">

    <!-- 중앙 정렬 wrapper (네비 여백 고려) -->
    <div class="d-flex flex-column justify-content-center" style="min-height: calc(100vh - 150px);">

        <!-- Breadcrumb -->
        <nav aria-label="breadcrumb" class="mb-3">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath }/index/headquaterindex.jsp">홈</a></li>
                <li class="breadcrumb-item"><a href="stock.jsp">재고 관리</a></li>
                <li class="breadcrumb-item"><a href="inandout.jsp">입고 / 출고</a></li>
                <li class="breadcrumb-item active" aria-current="page">전체 입고 내역</li>
            </ol>
        </nav>

        <h2 class="text-center mb-4 fw-bold">전체 입고 내역</h2>

        <!-- 검색창 -->
        <div class="d-flex justify-content-end mb-3">
            <form class="d-flex" method="get" action="inbound_list.jsp" style="gap: 5px;">
                <input type="text" name="managerKeyword" placeholder="담당자 검색"
                       value="<%= managerKeyword %>" class="form-control form-control-sm" style="width: 200px; height: 32px;">
                <button type="submit" class="btn btn-primary btn-sm" style="height: 32px;">검색</button>
            </form>
        </div>

        <!-- 입고 내역 테이블 -->
        <table class="table table-bordered text-center align-middle">
            <thead>
                <tr>
                    <th>입고 ID</th>
                    <th>입고 날짜</th>
                    <th>담당자</th>
                    <th>상세보기</th>
                </tr>
            </thead>
            <tbody>
            <% if (list == null || list.isEmpty()) { %>
                <tr><td colspan="4">입고 내역이 없습니다.</td></tr>
            <% } else {
                for (InboundOrdersDto dto : list) { %>
                    <tr>
                        <td><%= dto.getOrder_id() %></td>
                        <td><%= dto.getIn_date() != null ? dto.getIn_date() : "-" %></td>
                        <td><%= dto.getManager() != null ? dto.getManager() : "-" %></td>
                        <td>
                            <a href="inbound_detail.jsp?order_id=<%= dto.getOrder_id() %>" class="btn btn-sm btn-primary">상세보기</a>
                        </td>
                    </tr>
            <%  } } %>
            </tbody>
        </table>

        <!-- 페이징 -->
        <nav aria-label="Page navigation example">
            <ul class="pagination justify-content-center">
                <% if (currentPage > 1) { %>
                    <li class="page-item">
                        <a class="page-link" href="inbound_list.jsp?page=<%= currentPage - 1 %>&managerKeyword=<%= managerKeyword %>">이전</a>
                    </li>
                <% } else { %>
                    <li class="page-item disabled"><span class="page-link">이전</span></li>
                <% } %>

                <% for (int i = 1; i <= totalPages; i++) {
                    if (i == currentPage) { %>
                        <li class="page-item active"><span class="page-link"><%= i %></span></li>
                    <% } else { %>
                        <li class="page-item">
                            <a class="page-link" href="inbound_list.jsp?page=<%= i %>&managerKeyword=<%= managerKeyword %>"><%= i %></a>
                        </li>
                <% }} %>

                <% if (currentPage < totalPages) { %>
                    <li class="page-item">
                        <a class="page-link" href="inbound_list.jsp?page=<%= currentPage + 1 %>&managerKeyword=<%= managerKeyword %>">다음</a>
                    </li>
                <% } else { %>
                    <li class="page-item disabled"><span class="page-link">다음</span></li>
                <% } %>
            </ul>
        </nav>

        <!-- 돌아가기 버튼 -->
        <div class="text-center mt-4">
            <a href="inandout.jsp" class="btn btn-outline-secondary">돌아가기</a>
        </div>

    </div> <!-- 중앙정렬 wrapper 끝 -->

</div> <!-- container 끝 -->

<!-- Bootstrap JS (필요시) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>