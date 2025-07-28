<%@page import="java.util.List"%>
<%@page import="dao.stock.InventoryDao"%>
<%@page import="dto.stock.InventoryDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    List<InventoryDto> list = InventoryDao.getInstance().selectByInventoryId();

    int today = Integer.parseInt(new java.text.SimpleDateFormat("yyyyMMdd").format(new java.util.Date()));
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>stockList.jsp</title>
<style>
    table {
        border-collapse: collapse;
    }
    th, td {
        border: 1px solid #333;
        padding: 6px 10px;
        text-align: center;
    }
</style>
</head>
<body>
    <div class="container">
        <h1>재고 목록별 상태</h1>
        <form action="stock_update.jsp" method="post">
        <table>
            <thead>
                <tr>
                    <th>상품명</th>
                    <th>수량</th>
                    <th>유통기한</th>
                    <th>폐기 여부</th>
                    <th>발주 여부</th>
                    <th>승인 여부</th>
                </tr>
            </thead>
            <tbody>
            <%
                for (InventoryDto tmp : list) {
                    String expStr = tmp.getExpirationDate().replace("-", "");
                    int expInt = Integer.parseInt(expStr);
                    boolean isExpired = expInt <= today;
                    boolean isQuantityLow = tmp.getQuantity() < 10;
                    boolean needDisposal = isExpired;
                    boolean needOrder = isExpired || isQuantityLow;
            %>
                <tr>
                    <td><%= tmp.getProduct() %></td>
                    <td<%= isQuantityLow ? " style=\"color:orange; font-weight:bold;\"" : "" %>><%= tmp.getQuantity() %></td>
                    <td<%= isExpired ? " style=\"color:red;\"" : "" %>><%= tmp.getExpirationDate() %></td>
                    <td>
                        <% if (needDisposal) { %>
                            <select name="disposal_<%= tmp.getNum() %>">
                                <option value="YES" <%= tmp.isDisposal() ? "selected" : "" %>>YES</option>
                                <option value="NO" <%= !tmp.isDisposal() ? "selected" : "" %>>NO</option>
                            </select>
                        <% } else { %>
                            <%= tmp.isDisposal() ? "YES" : "NO" %>
                        <% } %>
                    </td>
                    <td>
                        <% if (needOrder) { %>
                            <select name="order_<%= tmp.getNum() %>">
                                <option value="YES" <%= tmp.isPlaceOrder() ? "selected" : "" %>>YES</option>
                                <option value="NO" <%= !tmp.isPlaceOrder() ? "selected" : "" %>>NO</option>
                            </select>
                        <% } else { %>
                            <%= tmp.isPlaceOrder() ? "YES" : "NO" %>
                        <% } %>
                    </td>
                    <td>
                        <%= tmp.getIsApproval()%>
                    </td>
                </tr>
            <% } %>
            </tbody>
        </table>
        <button type="submit" value="수정">확인</button>
        <button type="reset">취소</button>
        </form>
    </div>
    <a href="stock.jsp">돌아가기</a>
</body>
</html>