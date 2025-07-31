
<%@page import="dao.stock.PlaceOrderBranchDetailDao"%>
<%@ page import="dto.stock.PlaceOrderBranchDetailDto" %>
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
<html>
<head>
    <meta charset="UTF-8">
    <title>지점 발주 내역 수정</title>
</head>
<body>
    <h2>지점 발주 내역 수정 (Order ID: <%= orderId %>)</h2>

    <form action="placeorder_branch_edit.jsp" method="post">
        <input type="hidden" name="detail_id" value="<%= detailId %>">
        <input type="hidden" name="order_id" value="<%= orderId %>">

        <table border="1" cellpadding="5" cellspacing="0">
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
                    <input type="number" name="request_quantity" value="<%= dto.getRequest_quantity() %>" min="1" required>
                </td>
            </tr>
            <tr>
                <th>승인 상태</th>
                <td>
                    <select name="approval_status">
                        <option value="승인" <%= "승인".equals(dto.getApproval_status()) ? "selected" : "" %>>승인</option>
                        <option value="반려" <%= "반려".equals(dto.getApproval_status()) ? "selected" : "" %>>반려</option>
                    </select>
                </td>
            </tr>
        </table>
        <br>
        <input type="submit" value="수정 완료">
        <a href="placeorder_branch_detail.jsp?order_id=<%= orderId %>">취소</a>
    </form>
</body>
</html>