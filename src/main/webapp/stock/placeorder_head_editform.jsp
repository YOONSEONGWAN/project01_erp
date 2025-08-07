<%@ page import="dao.stock.PlaceOrderHeadDetailDao" %>
<%@ page import="dto.stock.PlaceOrderHeadDetailDto" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    int detailId = 0;
    int orderId = 0;
    try {
        detailId = Integer.parseInt(request.getParameter("detail_id"));
        orderId = Integer.parseInt(request.getParameter("order_id"));
    } catch (Exception e) {
        out.println("<script>alert('잘못된 접근입니다.'); history.back();</script>");
        return;
    }

    PlaceOrderHeadDetailDto dto = PlaceOrderHeadDetailDao.getInstance().getByDetailId(detailId);

    if(dto == null) {
        out.println("<script>alert('해당 발주 상세 내역이 존재하지 않습니다.'); history.back();</script>");
        return;
    }
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>발주 내역 수정</title>
    <!-- Bootstrap CSS CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        html, body {
            height: 100%;
            margin: 0;
            background-color: #f8f9fa;
        body {
        background-color: #f8f9fa;
        min-height: 100vh;
        margin: 0;
        padding: 20px;
    	}
        h2 {
            text-align: center;
            margin-bottom: 30px;
            font-weight: 700;
        }
        .form-container {
            max-width: 480px;
            width: 100%;
            background: #fff;
            padding: 25px 30px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
            box-sizing: border-box;
        }
        table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0 10px;
        }
        table tr th {
            background-color: #007bff !important;
            color: white !important;
            text-align: center;
            vertical-align: middle;
            width: 110px;
            white-space: nowrap;
            padding: 10px 8px;
        }
        table tr td {
            vertical-align: middle;
            text-align: center;
            padding: 10px 8px;
        }
        input[type="number"], select.form-select {
            max-width: 120px;
            margin: 0 auto;
            display: block;
        }
        .btn-group, .d-flex.justify-content-center {
            margin-top: 20px;
            text-align: center;
        }
        .btn-group .btn + .btn,
        .d-flex.justify-content-center .btn + .btn {
            margin-left: 10px;
        }
    </style>
</head>
<body>

    <div>
        <h2>발주 내역 수정 (Order ID: <%= orderId %>)</h2>

        <div class="form-container">
            <form action="${pageContext.request.contextPath}/headquater.jsp?page=/stock/placeorder_head_edit.jsp" method="post">
                <input type="hidden" name="detail_id" value="<%= detailId %>">
                <input type="hidden" name="order_id" value="<%= orderId %>">

                <table>
                    <tr>
                        <th>상품명</th>
                        <td><%= dto.getProduct() %></td>
                    </tr>
                    <tr>
                        <th>현재 수량</th>
                        <td><%= dto.getCurrent_quantity() %></td>
                    </tr>
                    <tr>
                        <th>신청 수량</th>
                        <td>
                            <input type="number" name="request_quantity" value="<%= dto.getRequest_quantity() %>" min="1" required class="form-control">
                        </td>
                    </tr>
                    <tr>
                        <th>승인 상태</th>
                        <td>
                            <select name="approval_status" class="form-select">
                                <option value="승인" <%= "승인".equals(dto.getApproval_status()) ? "selected" : "" %>>승인</option>
                                <option value="반려" <%= "반려".equals(dto.getApproval_status()) ? "selected" : "" %>>반려</option>
                            </select>
                        </td>
                    </tr>
                </table>

                <div class="d-flex justify-content-center mt-3">
                    <button type="submit" class="btn btn-primary">수정 완료</button>
                    <a href="${pageContext.request.contextPath}/headquater.jsp?page=/stock/placeorder_head_detail.jsp?order_id=<%= orderId %>" class="btn btn-secondary ms-2">취소</a>
                </div>
            </form>
        </div>
    </div>

    <!-- Bootstrap JS (Optional, for components if needed) -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>