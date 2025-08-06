<%@page import="dao.stock.OutboundOrdersDao"%>
<%@page import="dto.stock.OutboundOrdersDto"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
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

    String managerKeyword = request.getParameter("managerKeyword");
    if (managerKeyword == null) managerKeyword = "";

    int pageSize = 10;

    List<OutboundOrdersDto> list = OutboundOrdersDao.getInstance().selectByManagerWithPaging(managerKeyword, currentPage, pageSize);
    int totalCount = OutboundOrdersDao.getInstance().countByManager(managerKeyword);
    int totalPages = (int) Math.ceil(totalCount / (double) pageSize);
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <title>전체 출고 내역</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <style>
        table thead th {
            background-color: #007bff !important;
            color: white !important;
        }
    </style>
</head>
<body class="bg-light">

<div class="container py-5">

    <!-- 중앙 정렬 wrapper 시작 -->
    <div class="d-flex flex-column justify-content-center" style="min-height: calc(100vh - 150px);">

        <nav aria-label="breadcrumb" class="mb-3">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath }/index/headquaterindex.jsp">홈</a></li>
                <li class="breadcrumb-item"><a href="stock.jsp">재고 관리</a></li>
                <li class="breadcrumb-item"><a href="inandout.jsp">입고 / 출고</a></li>
                <li class="breadcrumb-item active" aria-current="page">전체 출고 내역</li>
            </ol>
        </nav>

        <h2 class="text-center mb-4 fw-bold">전체 출고 내역</h2>

        <!-- 검색 폼 -->
        <form method="get" action="outbound_list.jsp" class="d-flex justify-content-end mb-3" role="search">
            <input
                class="form-control form-control-sm me-2"
                style="max-width: 200px;"
                type="search"
                placeholder="담당자 검색"
                aria-label="Search"
                name="managerKeyword"
                value="<%= managerKeyword %>"
            />
            <button class="btn btn-primary btn-sm" type="submit">검색</button>
        </form>

        <!-- 테이블 -->
        <div class="table-responsive">
            <table class="table table-bordered table-hover text-center align-middle">
                <thead>
                    <tr>
                        <th>출고 ID</th>
                        <th>재고 ID</th>
                        <th>승인 상태</th>
                        <th>출고 날짜</th>
                        <th>담당자</th>
                        <th>상세보기</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (list == null || list.isEmpty()) { %>
                        <tr>
                            <td colspan="6">출고 내역이 없습니다.</td>
                        </tr>
                    <% } else {
                        for (OutboundOrdersDto dto : list) { %>
                            <tr>
                                <td><%= dto.getOrder_id() %></td>
                                <td><%= dto.getBranch_id() %></td>
                                <td><%= dto.getApproval() != null ? dto.getApproval() : "-" %></td>
                                <td><%= dto.getOut_date() != null ? dto.getOut_date() : "-" %></td>
                                <td><%= dto.getManager() != null ? dto.getManager() : "-" %></td>
                                <td>
                            		<a href="outbound_detail.jsp?order_id=<%= dto.getOrder_id() %>" class="btn btn-sm btn-primary">상세보기</a>
                        		</td>
                            </tr>
                    <%  } } %>
                </tbody>
            </table>
        </div>

        <!-- 페이징 -->
        <nav aria-label="Page navigation" class="d-flex justify-content-center">
            <ul class="pagination pagination-sm">
                <% if (currentPage > 1) { %>
                    <li class="page-item">
                        <a class="page-link" href="outbound_list.jsp?page=<%= currentPage - 1 %>&managerKeyword=<%= managerKeyword %>">이전</a>
                    </li>
                <% } else { %>
                    <li class="page-item disabled"><span class="page-link">이전</span></li>
                <% } %>

                <% for (int i = 1; i <= totalPages; i++) {
                    if (i == currentPage) { %>
                        <li class="page-item active" aria-current="page">
                            <span class="page-link"><%= i %></span>
                        </li>
                    <% } else { %>
                        <li class="page-item">
                            <a class="page-link" href="outbound_list.jsp?page=<%= i %>&managerKeyword=<%= managerKeyword %>"><%= i %></a>
                        </li>
                <%  }} %>

                <% if (currentPage < totalPages) { %>
                    <li class="page-item">
                        <a class="page-link" href="outbound_list.jsp?page=<%= currentPage + 1 %>&managerKeyword=<%= managerKeyword %>">다음</a>
                    </li>
                <% } else { %>
                    <li class="page-item disabled"><span class="page-link">다음</span></li>
                <% } %>
            </ul>
        </nav>

        <!-- 돌아가기 버튼 -->
        <div class="text-center mt-3">
            <a href="inandout.jsp" class="btn btn-outline-primary btn-sm">돌아가기</a>
        </div>

    </div> <!-- 중앙 정렬 wrapper 끝 -->

</div>

<!-- Optional: Bootstrap JS Bundle -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>