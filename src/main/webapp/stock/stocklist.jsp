<%@page import="java.net.URLEncoder"%>
<%@page import="java.util.List"%>
<%@page import="dao.stock.InventoryDao"%>
<%@page import="dto.stock.InventoryDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String keyword = request.getParameter("keyword");
    if (keyword == null) keyword = "";

    int currentPage = 1;
    String pageParam = request.getParameter("page");
    if (pageParam != null && !pageParam.isEmpty()) {
        try {
            currentPage = Integer.parseInt(pageParam);
            if(currentPage < 1) currentPage = 1;
        } catch(Exception e) {
            currentPage = 1;
        }
    }

    int itemsPerPage = 10;
    int totalCount = InventoryDao.getInstance().getCountByKeyword(keyword);
    int totalPages = (int) Math.ceil((double) totalCount / itemsPerPage);
    int start = (currentPage - 1) * itemsPerPage;

    List<InventoryDto> list = InventoryDao.getInstance().selectByKeywordWithPaging(keyword, start, itemsPerPage);
    String encodedKeyword = "";
    try {
        encodedKeyword = URLEncoder.encode(keyword, "UTF-8");
    } catch(Exception e) {
        encodedKeyword = keyword;
    }
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>재고 목록</title>
    <jsp:include page="/WEB-INF/include/resource.jsp"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .container {
            padding-top: 1rem;
            padding-bottom: 1rem;
            max-width: 900px;
        }
        h1 {
            margin-bottom: 16px;
            font-weight: 700;
            font-size: 28px;
            color: #212529;
        }
        thead th {
            background-color: #e1e4e8;
            color: #212529;
            text-align: center;
            font-weight: 600;
        }
        tbody td {
            text-align: center;
        }
        .low-stock {
            color: red;
            font-weight: bold;
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
        }
        .cancel-btn:hover {
            background-color: #5a6268 !important;
            color: white !important;
            border-color: #545b62 !important;
        }
         .page-link,
        .page-link:hover,
        .page-link:focus,
        .page-link:visited {
            color: #003366 !important;
        }
        
        /* 현재 페이지는 흰 글씨 + 남색 배경 */
        .page-item.active .page-link {
            background-color: #003366 !important;
            color: white !important;
            font-weight: bold;
        }
        
        /* 페이지네이션 기본 스타일 */
        .pagination {
            display: inline-flex;
            border: 1px solid #003366;
            border-radius: 6px;
            overflow: hidden;
            margin: 0 auto;
        }
        
        /* 버튼 배경 및 간격 */
        .page-link {
            background-color: #f8f9fa;
            border: none;
            padding: 6px 18px;
            font-weight: 500;
        }
        
        /* 비활성 버튼 */
        .page-item.disabled .page-link {
            color: #b0b0b0 !important;
            background-color: #f8f9fa;
        }
        
        /* 버튼 사이 구분선 */
        .page-item:not(:last-child) .page-link {
            border-right: 1px solid #003366;
        }
        
        /* 가운데 정렬 */
        .pagination-wrapper {
            display: flex;
            justify-content: center;
        }

         /* 이전, 다음 버튼만 별도 스타일 */
        .pagination li:first-child .page-link,
        .pagination li:last-child .page-link {
            color: #003366 !important;            /* 남색 글자 */
            background-color: white  
            font-weight: 600;
        }

        /* 이전, 다음 버튼 호버 */
        .pagination li:first-child .page-link:hover,
        .pagination li:last-child .page-link:hover {
            color: white !important;
            background-color: #001f4d !important; /* 더 진한 남색 배경 */
            border-color: #001f4d !important;
        }
    </style>
</head>
<body class="bg-light">

<div class="container py-1">

    <!-- 브래드크럼 -->
    <nav aria-label="breadcrumb" class="breadcrumb">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/headquater.jsp">홈</a></li>
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/headquater.jsp?page=/stock/stock.jsp">재고 관리</a></li>
            <li class="breadcrumb-item active" aria-current="page">재고 목록</li>
        </ol>
    </nav>

    <!-- 제목 -->
    <h1>재고 목록</h1>

    <!-- 검색창 -->
    <div class="d-flex justify-content-end mb-3">
        <form action="${pageContext.request.contextPath}/headquater.jsp" method="get" class="d-flex gap-2">
            <input type="hidden" name="page" value="/stock/stocklist.jsp" />
            <input type="text" name="keyword" placeholder="상품명 검색" class="form-control"
                   style="width: 200px;" value="<%= keyword %>" />
            <button type="submit" class="btn btn-primary">검색</button>
        </form>
    </div>

    <!-- 테이블 -->
    <form action="${pageContext.request.contextPath}/headquater.jsp?page=/stock/stock_update.jsp" method="post">
        <table class="table table-hover">
            <thead class="table-secondary">
                <tr>
                    <th>상품명</th>
                    <th>수량</th>
                    <th>폐기 여부</th>
                    <th>발주 여부</th>
                    <th>승인 여부</th>
                </tr>
            </thead>
            <tbody>
                <%
                    for (InventoryDto tmp : list) {
                        boolean isQuantityLow = tmp.getQuantity() < 10;
                        boolean needOrder = isQuantityLow;
                %>
                <tr>
                    <td><%= tmp.getProduct() %></td>
                    <td <%= isQuantityLow ? "class=\"low-stock\"" : "" %>><%= tmp.getQuantity() %></td>
                    <td>
                        <select class="form-select" name="disposal_<%= tmp.getNum() %>">
                            <option value="YES" <%= tmp.isDisposal() ? "selected" : "" %>>YES</option>
                            <option value="NO" <%= !tmp.isDisposal() ? "selected" : "" %>>NO</option>
                        </select>
                    </td>
                    <td>
                        <% if (needOrder) { %>
                            <select class="form-select" name="order_<%= tmp.getNum() %>">
                                <option value="YES" <%= tmp.isPlaceOrder() ? "selected" : "" %>>YES</option>
                                <option value="NO" <%= !tmp.isPlaceOrder() ? "selected" : "" %>>NO</option>
                            </select>
                        <% } else { %>
                            <%= tmp.isPlaceOrder() ? "YES" : "NO" %>
                        <% } %>
                    </td>
                    <td><%= tmp.getIsApproval() %></td>
                </tr>
                <% } %>
            </tbody>
        </table>

        <div class="d-flex justify-content-end gap-2 mt-3">
            <button type="reset" class="btn btn-secondary cancel-btn">취소</button>
            <button type="submit" class="btn btn-primary">확인</button>
        </div>
    </form>

    <!-- 페이징 -->
<div class="pagination-wrapper">
    <nav aria-label="Page navigation" class="mt-4">
        <ul class="pagination">
            <% if (currentPage > 1) { %>
                <li class="page-item">
                    <a class="page-link" href="${pageContext.request.contextPath}/headquater.jsp?page=/stock/stocklist.jsp&page=<%= currentPage - 1 %>&keyword=<%= encodedKeyword %>">이전</a>
                </li>
            <% } else { %>
                <li class="page-item disabled"><span class="page-link">이전</span></li>
            <% } %>

            <%
                int pageBlock = 5;
                int startPage = ((currentPage - 1) / pageBlock) * pageBlock + 1;
                int endPage = Math.min(startPage + pageBlock - 1, totalPages);
                for (int i = startPage; i <= endPage; i++) {
                    if (i == currentPage) {
            %>
                        <li class="page-item active"><span class="page-link"><%= i %></span></li>
            <%
                    } else {
            %>
                        <li class="page-item">
                            <a class="page-link" href="${pageContext.request.contextPath}/headquater.jsp?page=/stock/stocklist.jsp&page=<%= i %>&keyword=<%= encodedKeyword %>"><%= i %></a>
                        </li>
            <%
                    }
                }
            %>

            <% if (currentPage < totalPages) { %>
                <li class="page-item">
                    <a class="page-link" href="${pageContext.request.contextPath}/headquater.jsp?page=/stock/stocklist.jsp&page=<%= currentPage + 1 %>&keyword=<%= encodedKeyword %>">다음</a>
                </li>
            <% } else { %>
                <li class="page-item disabled"><span class="page-link">다음</span></li>
            <% } %>
        </ul>
    </nav>
</div>

</div>

</body>
</html>