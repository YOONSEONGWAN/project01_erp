<%@page import="java.util.List"%>
<%@page import="dto.IngredientDto"%>
<%@page import="dao.IngredientDao"%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
String branchId = (String)session.getAttribute("branchId");
IngredientDao dao = new IngredientDao();
List<IngredientDto> stockList = dao.selectAll(branchId);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>지점 발주 요청</title>
    <style>
        table { border-collapse: collapse; width: 650px; }
        th, td { border: 1px solid #ccc; padding: 8px; text-align: center; }
        .req-input { width: 60px; }
        .outer-bar { width: 660px; display: flex; justify-content: flex-end; margin: 18px 0 10px 0;}
        .req-btn { font-size: 1em; padding: 8px 26px; border-radius: 6px; }
    </style>
</head>
<body>
<h3>지점 재고 현황</h3>

<form action="request-stock.jsp" method="post" style="margin:0;">
    <table>
        <tr>
            <th>식재료명</th>
            <th>현재 재고</th>
            <th>발주 요청 수량</th>
        </tr>
    <%
    if (stockList == null || stockList.size() == 0) {
    %>
        <tr>
            <td colspan="3" style="text-align:center;">재고 정보가 없습니다.</td>
        </tr>
    <%
    } else {
        for(int i=0; i < stockList.size(); i++){
            IngredientDto dto = stockList.get(i);
    %>
        <tr>
            <td>
                <%= dto.getProduct() %>
            <input type="hidden" name="items[<%=i%>].branchNum" value="<%= dto.getBranchNum() %>">
       		<input type="hidden" name="items[<%=i%>].inventoryId" value="<%= dto.getInventoryId() %>">
        	<input type="hidden" name="items[<%=i%>].product" value="<%= dto.getProduct() %>">
        	<input type="hidden" name="items[<%=i%>].branchId" value="<%= dto.getBranchId() %>">
        	<input type="hidden" name="items[<%=i%>].currentQuantity" value="<%= dto.getCurrentQuantity() %>">
            </td>
            <td><%= dto.getCurrentQuantity() %></td>
            <td>
                <input type="number" class="req-input" name="items[<%=i%>].requestQuantity" min="0" value="0">
            </td>
        </tr>
    <%
        }
    }
    %>
    </table>
    <div class="outer-bar">
        <button class="req-btn" type="submit">발주요청</button>
    </div>
</form>
</body>
</html>