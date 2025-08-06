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

</head>
<body>

<h3>발주 요청 수정</h3>
<form action="<%=request.getContextPath()%>/branch.jsp?page=order/update-request.jsp" method="post">
    <input type="hidden" name="orderId" value="<%= dto.getOrderId() %>">
    <input type="hidden" name="branchNum" value="<%= dto.getBranchNum() %>"><!-- ★ 반드시 추가 -->
    <table>
        <tr>
            <th>상품명</th>
            <td>
                <input type="text" name="product" value="<%= dto.getProduct() %>" required>
            </td>
        </tr>
        <tr>
            <th>요청 수량</th>
            <td>
                <input type="number" name="requestQuantity" min="1" value="<%= dto.getRequestQuantity() %>" required>
            </td>
        </tr>
    </table>
     <div style="text-align:right; margin-top:18px;">
        <button type="submit" class="btn btn-primary" style="margin-right:10px;">수정 완료</button>
        <a href="<%=request.getContextPath()%>/branch.jsp?page=order/list.jsp" class="btn btn-secondary">목록으로</a>
    </div>
</form>
</body>
</html>