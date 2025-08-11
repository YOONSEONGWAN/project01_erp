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

    // 페이지 블록 설정 (한번에 보여줄 페이지 번호 개수)
    int pageBlock = 5;
    int startPage = ((currentPage - 1) / pageBlock) * pageBlock + 1;
    int endPage = Math.min(startPage + pageBlock - 1, totalPages);

    // 검색어 URL 인코딩
    String encodedManagerKeyword = "";
    try {
        encodedManagerKeyword = java.net.URLEncoder.encode(managerKeyword, "UTF-8");
    } catch (Exception e) {
        encodedManagerKeyword = managerKeyword;
    }
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>전체 입고 내역</title>

    <!-- 부트스트랩 CSS 포함 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

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
            padding: 20px;
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
            display: flex;
            flex-direction: column;
        }
        /* 크럼브 + 제목 영역 */
        .header-section {
            text-align: left;
            margin-bottom: 20px;
        }
        .header-section nav.breadcrumb {
            margin-bottom: 8px;
            padding-left: 0;
        }
        .header-section h2 {
            font-weight: 700;
            font-size: 24px;
            margin-top: 0;
            margin-bottom: 0;
            color: #212529;
        }

        .search-form input[type="text"] {
            max-width: 200px;
        }
        .d-flex.justify-content-end.mb-3 {
            gap: 8px;
        }
        table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0 10px;
            text-align: center; /* 모든 테이블 텍스트 중앙 */
        }
        thead tr {
            background-color: #e2e3e5; /* table-secondary 배경색 */
        }
        thead th {
            color: #212529;
            padding: 0.5rem 0.75rem;
            font-weight: 600;
            border-bottom: 2px solid #dee2e6;
            vertical-align: middle;
            white-space: nowrap;
        }
        tbody td {
            padding: 10px 8px;
            border-top: none;
            vertical-align: middle;
        }
        tbody tr {
            background-color: #fff;
            border-radius: 6px;
            box-shadow: 0 0 6px rgba(0, 0, 0, 0.05);
            margin-bottom: 10px;
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
    </style>
</head>
<body class="bg-light">
<div class="container py-5">

    <!-- 크럼브 + 제목 (좌측 상단) -->
    <div class="header-section">
        <nav aria-label="breadcrumb" class="mb-2">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath }/headquater.jsp">홈</a></li>
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/headquater.jsp?page=/stock/stock.jsp">재고 관리</a></li>
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/headquater.jsp?page=/stock/inandout.jsp">입고 / 출고</a></li>
                <li class="breadcrumb-item active" aria-current="page">전체 입고 내역</li>
            </ol>
        </nav>

        <h2 class="mb-4 fw-bold">전체 입고 내역</h2>
    </div>

    <!-- 본문영역: 검색창, 테이블, 페이징 -->
    <div class="content-section">

        <!-- 검색창 -->
        <div class="d-flex justify-content-end mb-3" style="gap:8px;">
            <form class="d-flex" method="get" action="${pageContext.request.contextPath}/headquater.jsp">
                <input type="hidden" name="page" value="/stock/inbound_list.jsp" />
                <input type="text" name="managerKeyword" placeholder="담당자 검색"
                       value="<%= managerKeyword %>" class="form-control form-control-sm" style="width: 200px; height: 32px;">
                <button type="submit" class="btn btn-primary btn-sm" style="height: 32px;">검색</button>
            </form>
        </div>

        <!-- 입고 내역 테이블 -->
        <table class="table text-center align-middle">
            <thead class="table-secondary">
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
                            <a href="${pageContext.request.contextPath}/headquater.jsp?page=/stock/inbound_detail.jsp&order_id=<%= dto.getOrder_id() %>" >상세</a>
                        </td>
                    </tr>
            <%  } } %>
            </tbody>
        </table>

        <!-- 페이징 -->
        <nav aria-label="Page navigation example" style="text-align: center;">
            <ul class="pagination justify-content-center">
                <% if (currentPage > 1) { %>
                    <li class="page-item">
                        <a class="page-link" href="${pageContext.request.contextPath}/headquater.jsp?page=/stock/inbound_list.jsp&page=<%= currentPage - 1 %>&managerKeyword=<%= encodedManagerKeyword %>">이전</a>
                    </li>
                <% } else { %>
                    <li class="page-item disabled"><span class="page-link">이전</span></li>
                <% } %>

                <% for (int i = startPage; i <= endPage; i++) {
                    if (i == currentPage) { %>
                        <li class="page-item active"><span class="page-link"><%= i %></span></li>
                    <% } else { %>
                        <li class="page-item">
                            <a class="page-link" href="${pageContext.request.contextPath}/headquater.jsp?page=/stock/inbound_list.jsp&page=<%= i %>&managerKeyword=<%= encodedManagerKeyword %>"><%= i %></a>
                        </li>
                <% } } %>

                <% if (currentPage < totalPages) { %>
                    <li class="page-item">
                        <a class="page-link" href="${pageContext.request.contextPath}/headquater.jsp?page=/stock/inbound_list.jsp&page=<%= currentPage + 1 %>&managerKeyword=<%= encodedManagerKeyword %>">다음</a>
                    </li>
                <% } else { %>
                    <li class="page-item disabled"><span class="page-link">다음</span></li>
                <% } %>
            </ul>
        </nav>

    </div> <!-- content-section -->

</div> <!-- container -->

<!-- 부트스트랩 JS (필요시) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>