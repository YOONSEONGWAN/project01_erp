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
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <title>발주 상세 내역</title>

    <!-- Bootstrap CSS 포함 -->
    <jsp:include page="/WEB-INF/include/resource.jsp"/>

    <style>
        /* 화면 전체 세로/가로 중앙 정렬 */
        html, body {
            height: 100%;
            margin: 0;
            background-color: #f8f9fa;
        }
        body {
    background-color: #f8f9fa;
    min-height: 100vh;

    /* 기존 중앙 정렬 제거 */
    /* display: flex; */
    /* flex-direction: column; */
    /* justify-content: center; */
    /* align-items: center; */

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
        }
        h2 {
            margin-top: 0;
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
    <nav aria-label="breadcrumb" style="margin-bottom: 20px;">
      <ol class="breadcrumb">
        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/headquater.jsp">홈</a></li>
        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/headquater.jsp?page=/stock/placeorder.jsp">발주 관리</a></li>
        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/headquater.jsp?page=/stock/placeorder_head.jsp">본사 발주</a></li>
        <li class="breadcrumb-item active" aria-current="page">상세 발주 내역</li>
      </ol>
    </nav>

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
                        <a href="${pageContext.request.contextPath}/headquater.jsp?page=/stock/placeorder_head_editform.jsp?detail_id=<%= dto.getDetail_id() %>&order_id=<%= dto.getOrder_id() %>" class="btn btn-sm btn-outline-primary">수정</a>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>

    
</div>

</body>
</html>
