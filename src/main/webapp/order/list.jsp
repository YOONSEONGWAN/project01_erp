<%@ page import="java.util.List" %>
<%@ page import="dto.StockRequestDto" %>
<%@ page import="dao.StockRequestDao" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
//String branchId = (String)session.getAttribute("branchId");

String branchId = (String)session.getAttribute("branchId");



List<StockRequestDto> orderList = StockRequestDao.getInstance().selectAllByBranch(branchId); // 발주 내역 리스트

	


%>
<!DOCTYPE html>
<html>
<head>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <meta charset="UTF-8">
    <title>발주 현황</title>

    <style>
        table { border-collapse: collapse; width: 850px; }
        th, td { border: 1px solid #ccc; padding: 8px; text-align: center; }
        .btn { padding: 4px 14px; border-radius: 5px; font-size: 0.95em; }
        .btn-update { background: #003366; color: #fff; border: none; }
         th {
        
    }
    </style>
</head>
<body>
<h3 class="ms-4 mt-4 mb-3">발주 현황</h3>
<table class="ms-4">
    <tr>
        <th>발주번호</th>
     <%--   <th>branch_stock번호</th>    branch_num 추가, 관리용 --%>
        <th>상품명</th>
        <th>현재 재고</th>
        <th>요청 수량</th>
        <th>요청상태</th>
        <th>상태</th>
        <th>신청일</th>
        <th>수정</th>
        <th>삭제</th>
    </tr>
<%
if (orderList == null || orderList.isEmpty()) {
%>
    <tr>
        <td colspan="10" style="text-align:center;">발주 내역이 없습니다.</td>
    </tr>
<%
} else {
    for(StockRequestDto dto : orderList) {
%>
    <tr>
        <td><%= dto.getOrderId() %></td>
        <%-- <td><%= dto.getBranchNum() %></td>   branch_num 표시, 필요없으면 생략 --%>
        <td><%= dto.getProduct() %></td>
        <td><%= dto.getCurrentQuantity() %></td>
        <td><%= dto.getRequestQuantity() %></td>
<td>
    <%
        String isPlaceOrder = dto.getIsPlaceOrder();
        String label;
        if ("YES".equals(isPlaceOrder)) {
            label = "승인";
        } else if ("NO".equals(isPlaceOrder)) {
            label = "거절";
        } else {
            label = "요청";
        }
    %>
    <%= label %>
</td>
        <td><%= dto.getStatus() %></td>
        <td>
            <% if (dto.getRequestedAt() != null) { %>
                <%= dto.getRequestedAt() %>
            <% } %>
        </td>
        <td>
           <form action="branch.jsp" method="get">
    			<input type="hidden" name="page" value="order/update-form.jsp">
                <input type="hidden" name="orderId" value="<%= dto.getOrderId() %>">
                <input type="hidden" name="branchNum" value="<%= dto.getBranchNum() %>">
                <button type="submit" class="btn btn-update">수정</button>
            </form>
        </td>
        <td>
            <form action="${pageContext.request.contextPath}/branch.jsp?page=order/delete.jsp" method="post" style="margin:0;" onsubmit="return confirm('정말 삭제하시겠습니까?');">
                <input type="hidden" name="orderId" value="<%= dto.getOrderId() %>">
                <input type="hidden" name="branchNum" value="<%= dto.getBranchNum() %>">
                <button type="submit" class="btn btn-secondary">삭제</button>
                
                
                
            </form>
        </td>
    </tr>
<%
    }
}
%>
</table>
<div style="margin-top:18px;">
    <a href="<%=request.getContextPath()%>/branch.jsp?page=order/insert.jsp" style="text-decoration:none;">
        <button class="btn btn-update ms-4" type="button">새 발주 요청</button>
    </a>
</div>
</body>
</html>