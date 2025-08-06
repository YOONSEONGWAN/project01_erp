<%@page import="dao.stock.PlaceOrderBranchDetailDao"%>
<%@page import="dto.stock.PlaceOrderBranchDetailDto"%>
<%@page import="java.util.List"%>
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

    List<PlaceOrderBranchDetailDto> list = PlaceOrderBranchDetailDao.getInstance().getDetailsByOrderId(orderId);
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>입고 상세 내역</title>

    <!-- 부트스트랩 포함 -->
    <jsp:include page="/WEB-INF/include/resource.jsp"/>

    <style>
        body {
            background-color: #f8f9fa;

            /* 화면 전체 높이 100% */
            min-height: 100vh;

            /* flexbox로 수직, 수평 중앙 정렬 */
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;

            margin: 0;
            padding: 20px;
        }
        h2 {
            margin-bottom: 30px;
            font-weight: bold;
            text-align: center;
        }
        .table-container {
            max-width: 900px;
            width: 100%;
        }
        /* 테이블 헤더 파란색 배경 및 흰색 글씨 */
        table thead th {
            background-color: #007bff !important;
            color: white !important;
            text-align: center;
        }
        /* 테이블 셀 가운데 정렬 */
        table td {
            text-align: center;
            vertical-align: middle;
        }
        nav[aria-label="breadcrumb"] {
            width: 100%;
            max-width: 900px;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <nav aria-label="breadcrumb">
      <ol class="breadcrumb">
        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath }/index/headquaterindex.jsp">홈</a></li>
        <li class="breadcrumb-item"><a href="stock.jsp">재고 관리</a></li>
        <li class="breadcrumb-item active" aria-current="page"> 출고 상세 내역</li>
      </ol>
    </nav>

    <h2>출고 상세 내역 (Order ID: <%= orderId %>)</h2>

    <div class="table-container">
        <table class="table table-bordered table-hover align-middle">
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
                <% for (PlaceOrderBranchDetailDto dto : list) { %>
                <tr>
                    <td><%= dto.getDetail_id() %></td>
                    <td><%= dto.getBranch_id() %></td>
                    <td><%= dto.getProduct() %></td>
                    <td><%= dto.getCurrent_quantity() %></td>
                    <td><%= dto.getRequest_quantity() %></td>
                    <td><%= dto.getApproval_status() %></td>
                    <td><%= dto.getManager() %></td>
                    <td>
                        <a href="placeorder_branch_editform.jsp?detail_id=<%= dto.getDetail_id() %>&order_id=<%= dto.getOrder_id() %>" class="btn btn-sm btn-outline-primary">수정</a>
                    </td>
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