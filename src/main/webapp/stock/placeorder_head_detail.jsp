<%@page import="java.util.List"%>
<%@page import="dto.stock.PlaceOrderHeadDetailDto"%>
<%@page import="dao.stock.PlaceOrderHeadDetailDao"%>
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

    List<PlaceOrderHeadDetailDto> list = PlaceOrderHeadDetailDao.getInstance().getDetailsByOrderId(orderId);
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>발주 상세 내역</title>

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
        /* 테이블 헤더 파란색 배경, 흰색 글씨 */
        table thead th {
            background-color: #007bff !important;
            color: white !important;
            text-align: center;
        }
        table tbody td {
            vertical-align: middle !important;
            text-align: center;
        }
    </style>
</head>
<body>

<div class="container py-5">

    <h2>발주 상세 내역 (Order ID: <%= orderId %>)</h2>

    <div class="table-container">
        <table class="table table-bordered table-hover align-middle">
            <thead>
                <tr>
                	
                    <th>상품명</th>
                    <th>현재 수량</th>
                    <th>신청 수량</th>
                    <th>승인 여부</th>
                    <th>담당자</th>
                    <th>수정</th>
                </tr>
            </thead>
            <tbody>
                <% for (PlaceOrderHeadDetailDto dto : list) { %>
                <tr>
                	
                    <td><%= dto.getProduct() %></td>
                    <td><%= dto.getCurrent_quantity() %></td>
                    <td><%= dto.getRequest_quantity() %></td>
                    <td><%= dto.getApproval_status() %></td>
                    <td><%= dto.getManager() %></td>
                    <td>
                        <a href="placeorder_head_editform.jsp?detail_id=<%= dto.getDetail_id() %>&order_id=<%= dto.getOrder_id() %>" class="btn btn-sm btn-outline-primary">수정</a>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>

    <div class="text-center">
        <a href="placeorder_head.jsp" class="btn btn-outline-secondary">돌아가기</a>
    </div>

</div>

</body>
</html>