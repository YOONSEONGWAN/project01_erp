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

    List<PlaceOrderBranchDetailDto> list = PlaceOrderBranchDetailDao.getInstance().getDetailListByOrderId(orderId);
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>지점 발주 상세 내역</title>
    <!-- Bootstrap 5 CSS CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        /* 화면 전체 높이 100%, flex로 세로/가로 중앙 정렬 */
        html, body {
            height: 100%;
            margin: 0;
            background-color: #f8f9fa;
        }
        body {
            display: flex;
            justify-content: center; /* 가로 중앙 */
            align-items: center;     /* 세로 중앙 */
            padding: 40px 20px;
            box-sizing: border-box;
            min-height: 100vh;
        }
        .container {
            max-width: 960px;
            width: 100%;
            max-height: calc(100vh - 80px); /* 화면 높이에서 패딩 제외 */
            overflow-y: auto; /* 내용이 길면 스크롤 */
            background: #fff;
            padding: 20px 30px;
            box-shadow: 0 0 8px rgba(0,0,0,0.1);
            border-radius: 4px;
            box-sizing: border-box;
        }
        h2 {
            text-align: center;
            margin-top: 0;
            margin-bottom: 30px;
        }
        .table thead th {
            background-color: #007bff !important;
            color: white !important;
            text-align: center;
        }
        .table tbody td {
            text-align: center;
            vertical-align: middle;
        }
        a {
            color: #007bff;
            text-decoration: none;
        }
        a:hover {
            text-decoration: underline;
        }
        .table-container {
            max-width: 900px;
            margin: 0 auto 40px auto;
        }
        .text-center {
            text-align: center;
        }
    </style>
</head>
<body>

<div class="container">
    <nav aria-label="breadcrumb" style="margin-bottom: 20px;">
      <ol class="breadcrumb">
        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath }/index/headquaterindex.jsp">홈</a></li>
        <li class="breadcrumb-item"><a href="placeorder.jsp">발주 관리</a></li>
        <li class="breadcrumb-item"><a href="placeorder_branch.jsp">지점 발주</a></li>
        <li class="breadcrumb-item active" aria-current="page"> 상세 발주 내역</li>
      </ol>
    </nav>

    <h2>지점 발주 상세 내역 (Order ID: <%= orderId %>)</h2>

    <div class="table-container">
        <table class="table table-bordered table-hover">
            <thead>
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