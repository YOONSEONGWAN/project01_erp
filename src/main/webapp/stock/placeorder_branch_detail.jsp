<%@page import="java.util.List"%>
<%@page import="dto.stock.PlaceOrderBranchDetailDto"%>
<%@page import="dao.stock.PlaceOrderBranchDetailDao"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    String orderIdStr = request.getParameter("order_id");
    int orderId = 0;
    try {
        orderId = Integer.parseInt(orderIdStr);
    } catch (Exception e) {
        out.println("<script>alert('잘못된 접근입니다.'); history.back();</script>");
        return;
    }

    // order_id 기준으로 상세 리스트 조회
    List<PlaceOrderBranchDetailDto> list = PlaceOrderBranchDetailDao.getInstance().getDetailListByOrderId(orderId);
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>지점 발주 상세 내역</title>
    <!-- Bootstrap 5 CSS CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        /* 제목과 테이블 전체 가운데 정렬 */
        h2 {
            text-align: center;
            margin-top: 20px;
            margin-bottom: 30px;
        }
        .table thead th {
            color: #007bff;
            text-align: center;
        }
        /* 테이블 데이터도 가운데 정렬 */
        .table tbody td {
            text-align: center;
        }
        /* 수정 링크는 파란색으로 표시 */
        a {
            color: #007bff;
            text-decoration: none;
        }
        a:hover {
            text-decoration: underline;
        }
        /* 테이블을 화면 중앙에 배치 */
        .table-container {
            max-width: 900px;
            margin: 0 auto 40px auto;
        }
    </style>
</head>
<body>

<div class="container">
    <h2>지점 발주 상세 내역 (Order ID: <%= orderId %>)</h2>

    <div class="table-container">
        <table class="table table-bordered table-hover">
            <thead class="table-light">
                <tr>
                    <th>상세ID</th>
                    <th>지점ID</th>
                    <th>상품명</th>
                    <th>현재 수량</th>
                    <th>신청 수량</th>
                    <th>승인 여부</th>
                    <th>담당자</th>
                    <th>수정</th>
                </tr>
            </thead>
            <tbody>
                <%
                    for (PlaceOrderBranchDetailDto dto : list) {
                %>
                <tr>
                    <td><%= dto.getDetail_id() %></td>
                    <td><%= dto.getBranch_id() %></td>
                    <td><%= dto.getProduct() %></td>
                    <td><%= dto.getCurrent_quantity() %></td>
                    <td><%= dto.getRequest_quantity() %></td>
                    <td><%= dto.getApproval_status() %></td>
                    <td><%= dto.getManager() %></td>
                    <td>
                        <a href="placeorder_branch_editform.jsp?detail_id=<%= dto.getDetail_id() %>&order_id=<%= dto.getOrder_id() %>">수정</a>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>

    <div class="text-center mb-5">
        <a href="placeorder_branch.jsp" class="btn btn-primary">돌아가기</a>
    </div>
</div>

<!-- Bootstrap 5 JS bundle (optional if you use JS components) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>