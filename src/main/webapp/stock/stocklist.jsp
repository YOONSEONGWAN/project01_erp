<%@page import="java.util.List"%>
<%@page import="dao.stock.InventoryDao"%>
<%@page import="dto.stock.InventoryDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    // 검색어 처리
    String keyword = request.getParameter("keyword");
    if (keyword == null) keyword = "";

    // 페이지 처리
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

    // 총 데이터 개수 (검색 조건 반영)
    int totalCount = InventoryDao.getInstance().getCountByKeyword(keyword);
    int totalPages = (int) Math.ceil((double) totalCount / itemsPerPage);

    // 시작 index 계산
    int start = (currentPage - 1) * itemsPerPage;

    // 데이터 조회 (검색어, 시작 index, 페이지당 개수)
    List<InventoryDto> list = InventoryDao.getInstance().selectByKeywordWithPaging(keyword, start, itemsPerPage);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>재고 목록</title>
<jsp:include page="/WEB-INF/include/resource.jsp"/>
<style>
    table thead th {
        background-color: #007bff !important;
        color: white !important;
    }
    .low-stock {
        color: red;
        font-weight: bold;
    }
    /* 검색창 우측 정렬 */
    .search-container {
        display: flex;
        justify-content: flex-end;
        margin-bottom: 10px;
    }
    /* 페이징 버튼 스타일 */
    .paging {
        margin-top: 20px;
        text-align: center;
    }
    .paging a, .paging span {
        display: inline-block;
        margin: 0 5px;
        padding: 6px 12px;
        color: #007bff;
        text-decoration: none;
        border: 1px solid #007bff;
        border-radius: 3px;
        cursor: pointer;
    }
    .paging span.current {
        background-color: #007bff;
        color: white;
        cursor: default;
    }
    .paging a:hover {
        background-color: #0056b3;
        color: white;
        border-color: #0056b3;
    }
</style>
</head>
<body class="bg-light">

<div class="container py-5">
 	<!-- Breadcrumb -->
    <nav aria-label="breadcrumb" style="margin-bottom: 20px;">
      <ol class="breadcrumb">
        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath }/index/headquaterindex.jsp">홈</a></li>
        <li class="breadcrumb-item"><a href="stock.jsp">재고 관리</a></li>
        <li class="breadcrumb-item active" aria-current="page">재고 목록</li>
      </ol>
    </nav>
    <h1 class="text-center mb-4 fw-bold">재고 목록</h1>

    <!-- 검색창 오른쪽 정렬 -->
    <div class="search-container">
        <form action="stocklist.jsp" method="get" style="display: flex; gap: 8px;">
            <input type="text" name="keyword" placeholder="상품명 검색" class="form-control" 
                   style="width: 200px;" value="<%= keyword %>" />
            <button type="submit" class="btn btn-primary">검색</button>
        </form>
    </div>

    <form action="stock_update.jsp" method="post">
        <table class="table table-bordered text-center align-middle" style="margin: 0 auto;">
            <thead>
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

        <div class="text-center mt-3">
            <button type="submit" class="btn btn-primary me-2">확인</button>
            <button type="reset" class="btn btn-secondary">취소</button>
        </div>
    </form>

    <!-- 페이징 -->
    <div class="paging">
        <% for (int i = 1; i <= totalPages; i++) { %>
            <% if(i == currentPage) { %>
                <span class="current"><%= i %></span>
            <% } else { %>
                <a href="stocklist.jsp?page=<%= i %>&keyword=<%= keyword %>"><%= i %></a>
            <% } %>
        <% } %>
    </div>

    
</div>

</body>
</html>