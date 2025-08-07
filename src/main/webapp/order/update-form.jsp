<%@ page import="dto.StockRequestDto" %>
<%@ page import="dao.StockRequestDao" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
String orderIdStr = request.getParameter("orderId");
if(orderIdStr == null) {
%>
    <h3 style="color:red;">잘못된 접근입니다.</h3>
<%
    return;
}
int orderId = Integer.parseInt(orderIdStr);
StockRequestDto dto = StockRequestDao.getInstance().selectByOrderId(orderId);
if(dto == null) {
%>
    <h3 style="color:red;">해당 발주 정보가 없습니다.</h3>
<%
    return;
}
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>발주 요청 수정</title>
<style>
        .erp-form-container {
            max-width: 480px;
            margin: 70px auto 0 auto;
            background: #fff;
            border-radius: 16px;
            box-shadow: 0 4px 24px rgba(80,90,120,0.08);
            padding: 40px 38px 34px 38px;
        }
        .erp-form-title {
            text-align: center;
            margin-bottom: 26px;
            color: #6c63ff;
            font-weight: 600;
        }
        .erp-form-label {
            font-size: 1.1em;
            color: #404040;
            font-weight: 500;
        }
        .erp-form-input {
            border-radius: 10px;
            font-size: 1em;
        }
        .erp-form-btn {
            min-width: 110px;
            font-size: 1em;
            border-radius: 8px;
        }
        .erp-btn-primary {
            background: #6c63ff;
            color: #fff;
            border: none;
        }
        .erp-btn-secondary {
            background: #e3e6ef;
            color: #5c5c77;
            border: none;
        }
    </style>
</head>
<body style="background: #f6f7fa;">

<div class="erp-form-container">
    <h3 class="erp-form-title">발주 요청 수정</h3>
    <form action="${pageContext.request.contextPath}/branch.jsp?page=order/update-request.jsp" method="post">
        <input type="hidden" name="orderId" value="<%= dto.getOrderId() %>">
        <input type="hidden" name="branchNum" value="<%= dto.getBranchNum() %>"><!-- ★ 반드시 추가 -->
        <div class="mb-3">
            <label class="form-label erp-form-label">상품명</label>
            <input type="text" class="form-control erp-form-input" name="product" value="<%= dto.getProduct() %>" required readonly>
        </div>
        <div class="mb-3">
            <label class="form-label erp-form-label">요청 수량</label>
            <input type="number" class="form-control erp-form-input" name="requestQuantity" min="1" value="<%= dto.getRequestQuantity() %>" required>
        </div>
    <div class="d-flex justify-content-end mt-4">
    <button type="submit" class="erp-form-btn erp-btn-primary me-4">수정 완료</button>
    <a href="${pageContext.request.contextPath}/branch.jsp?page=order/list.jsp" class="erp-form-btn erp-btn-secondary text-decoration-none text-center pt-2">목록으로</a>
</div>
    </form>
</div>

</body>
</html>