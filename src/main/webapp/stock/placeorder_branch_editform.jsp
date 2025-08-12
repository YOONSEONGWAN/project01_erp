<%@page import="dao.stock.PlaceOrderBranchDetailDao"%>
<%@page import="dto.stock.PlaceOrderBranchDetailDto"%>
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

    PlaceOrderBranchDetailDto dto = PlaceOrderBranchDetailDao.getInstance().getDetailById(detailId);
    if(dto == null) {
        out.println("<script>alert('해당 발주 상세 내역이 존재하지 않습니다.'); history.back();</script>");
        return;
    }
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>지점 발주 내역 수정</title>
    <!-- Bootstrap 5 CSS CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        html, body {
            height: 100%;
            margin: 0;
            background-color: #f8f9fa;
        }
        body {
            min-height: 100vh;
            margin: 0;
            padding: 0px;
        }
        h2 {
            text-align: left; /* 좌측 정렬 */
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
            text-align: center; /* 모든 테이블 텍스트 중앙 */
        }
        table tr th {
            background-color: #e2e3e5; /* table-secondary 배경색 */
            color: #212529;
            vertical-align: middle;
            width: 110px;
            white-space: nowrap;
            padding: 10px 8px;
        }
        table tr td {
            vertical-align: middle;
            padding: 10px 8px;
            text-align: center;
        }
        input[type="number"], select.form-select {
            max-width: 120px;
            margin: 0 auto;
            display: block;
        }
        .btn-group {
            display: flex;
            justify-content: space-between; /* 좌우 끝 정렬 */
            margin-top: 20px;
            max-width: 480px; /* form-container 폭과 맞춤 */
        }
        .btn-primary {
            background-color: #003366 !important;
            border-color: #003366 !important;
            color: white !important;
            font-weight: 500;
            border-radius: 6px;
            box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
        }
        .btn-primary:hover {
            background-color: #002244 !important; /* 더 어두운 남색 */
            border-color: #002244 !important;
            color: white !important;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
        }
         .btn-soft-danger, .btn-soft-danger:focus {
	       background-color: #ffe5e5;
	       border-color: #ffa3a3;
	       color: #e05252;
	   }
	   	 .btn-soft-danger:hover {
	       background-color: #ffb3b3;
	       border-color: #e05252;
	       color: #a51212;
	   }
    </style>
</head>
<body>

    <div style="display: flex; flex-direction: column; align-items: center; padding: 20px;">
        <h2 style="align-self: flex-start; width: 480px;">발주 내역 수정 (Order ID: <%= orderId %>)</h2>

        <div class="form-container mt-5">
            <form action="${pageContext.request.contextPath}/headquater.jsp?page=/stock/placeorder_branch_edit.jsp" method="post">
                <input type="hidden" name="detail_id" value="<%= detailId %>" />
                <input type="hidden" name="order_id" value="<%= orderId %>" />

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
                            <input type="number" name="request_quantity" value="<%= dto.getRequest_quantity() %>" min="1" required class="form-control" />
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

                <div class="d-flex justify-content-end gap-2 mt-3" style="max-width: 480px; margin: auto;">
                    <a href="${pageContext.request.contextPath}/headquater.jsp?page=/stock/placeorder_branch_detail.jsp?order_id=<%=orderId %>" class="btn btn-soft-danger" margin: 0 10px;">
				        취소
				    </a>
                    <button type="submit" class="btn btn-primary">확인</button>
                    
                </div>
            </form>
        </div>
    </div>

    <!-- Bootstrap JS (Optional) -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>




