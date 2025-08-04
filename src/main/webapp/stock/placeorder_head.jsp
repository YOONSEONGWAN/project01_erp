<%@page import="dto.stock.PlaceOrderHeadDto"%>
<%@page import="dao.stock.PlaceOrderHeadDao"%>
<%@page import="dto.stock.InventoryDto"%>
<%@page import="dao.stock.InventoryDao"%>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    List<InventoryDto> list = InventoryDao.getInstance().selectAll();
    List<PlaceOrderHeadDto> list2 = PlaceOrderHeadDao.getInstance().getRecentOrders();
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>발주 신청 내역</title>

    <!-- Bootstrap CSS 포함 -->
    <jsp:include page="/WEB-INF/include/resource.jsp"/>

    <style>
        body {
            background-color: #f8f9fa;
        }
        h2 {
            margin-top: 40px;
            margin-bottom: 20px;
            font-weight: bold;
            text-align: center;
        }
        .table-container {
            max-width: 900px;
            margin: 0 auto 50px auto;
        }
        /* 테이블 헤더 파란색 배경 및 흰색 글씨 */
        table thead th {
            background-color: #007bff !important;
            color: white !important;
            text-align: center;
        }
        table td, table th {
            vertical-align: middle !important;
            text-align: center;
        }
    </style>
</head>
<body>

<div class="container py-5">

    <h2>발주 신청 내역</h2>

    <div class="table-container">
        <form action="placeorder_head_confirm.jsp" method="post">
            <table class="table table-bordered table-hover align-middle">
                <thead>
                    <tr>
                        <th>상품명</th>
                        <th>현재 수량</th>
                        <th>발주 수량</th>
                        <th>발주 상태</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (InventoryDto dto : list) {
                        if (!dto.isPlaceOrder()) {
                            continue;
                        }
                    %>
                    <tr>
                        <td><%= dto.getProduct() %></td>
                        <td><%= dto.getQuantity() %></td>
                        <td>
                            <input type="number" name="amount_<%= dto.getNum() %>" min="1" value="1" required class="form-control form-control-sm" style="max-width: 80px; margin: 0 auto;">
                        </td>
                        <td>
                            <select name="approval_<%= dto.getNum() %>" class="form-select form-select-sm" style="max-width: 120px; margin: 0 auto;">
                                <option value="NO">반려</option>
                                <option value="YES">승인</option>
                            </select>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>

            <div class="text-center">
                <button type="submit" class="btn btn-primary">발주 확정</button>
            </div>
        </form>
    </div>

    <hr>

    <h2>최근 10건 발주 내역</h2>

    <div class="table-container">
        <table class="table table-bordered table-hover align-middle">
            <thead>
                <tr>
                    <th>Order ID</th>
                    <th>발주일</th>
                    <th>담당자</th>
                    <th>상세 보기</th>
                </tr>
            </thead>
            <tbody>
                <% for (PlaceOrderHeadDto order : list2) { %>
                <tr>
                    <td><%= order.getOrder_id() %></td>
                    <td><%= order.getOrder_date() %></td>
                    <td><%= order.getManager() %></td>
                    <td>
                        <a href="placeorder_head_detail.jsp?order_id=<%= order.getOrder_id() %>" class="btn btn-sm btn-outline-primary">상세 보기</a>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>

    <div class="text-center mb-5">
        <a href="placeorder_head_all.jsp" class="btn btn-outline-secondary me-3">전체 발주 내역 보기</a>
        <a href="placeorder.jsp" class="btn btn-outline-secondary">돌아가기</a>
    </div>

</div>

</body>
</html>