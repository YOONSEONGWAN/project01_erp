<%@ page import="dao.stock.InventoryDao" %>
<%@ page import="dto.stock.InventoryDto" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    
    List<InventoryDto> list = InventoryDao.getInstance().selectPlaceOrderList();
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>발주 신청 내역</title>
</head>
<body>
    <h2>📦 발주 신청 내역</h2>
    <form action="placeOrder_head_confirm.jsp" method="post">
        <table border="1" cellpadding="5" cellspacing="0">
            <thead>
                <tr>
                    <th>상품명</th>
                    <th>현재 수량</th>
                    <th>유통기한</th>
                    <th>발주 수량</th>
                    <th>발주 상태</th>
                </tr>
            </thead>
            <tbody>
                <%
                    for (InventoryDto dto : list) {
                %>
                <tr>
                    <td><%= dto.getProduct() %></td>
                    <td><%= dto.getQuantity() %></td>
                    <td><%= dto.getExpirationDate() %></td>
                    <td>
                        <input type="number" name="amount_<%= dto.getNum() %>" min="1" value="1" required>
                    </td>
                    <td>
                        <select name="approval_<%= dto.getNum() %>">
                            <option value="NO" >반려</option>
                            <option value="YES" >승인</option>
                        </select>
                    </td>
                </tr>
                <%
                    }
                %>
            </tbody>
        </table>
        <br>
        <input type="submit" value="발주 확정">
    </form>
    <br>
    <a href="placeOrder.jsp">돌아가기</a>
</body>
</html>