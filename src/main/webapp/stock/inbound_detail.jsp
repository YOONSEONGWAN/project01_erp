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
    <title>입고 상세 내역</title>

    <jsp:include page="/WEB-INF/include/resource.jsp"/>

    <style>
        body {
            background-color: #f8f9fa;
        }
        h2 {
            margin-top: 40px;
            text-align: center;
            font-weight: bold;
        }
        .table-container {
            max-width: 900px;
            margin: 30px auto;
        }
        /* 재고 목록 페이지와 동일한 테이블 헤더 스타일 */
        table thead th {
            background-color: #007bff !important;
            color: white !important;
        }
    </style>
</head>
<body>

    <h2>입고 상세 내역 (Order ID: <%= orderId %>)</h2>

    <div class="table-container">
        <table class="table table-bordered table-hover text-center align-middle">
            <thead>
                <tr>
                    <th>상품명</th>
                    <th>현재 수량</th>
                    <th>신청 수량</th>
                    <th>승인 여부</th>
                    <th>담당자</th>
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
                    </tr>
                <% } %>
            </tbody>
        </table>

        <div class="text-center mt-4">
            <a href="inandout.jsp" class="btn btn-outline-primary">돌아가기</a>
        </div>
    </div>

</body>
</html>