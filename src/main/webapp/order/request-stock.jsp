<%@page import="dto.StockRequestDto"%>
<%@page import="dao.StockRequestDao"%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
request.setCharacterEncoding("UTF-8");
int branchNum = Integer.parseInt(request.getParameter("branchNum"));   // ★ 추가!
String branchId = request.getParameter("branchId");
int inventoryId = Integer.parseInt(request.getParameter("inventoryId"));
String product = request.getParameter("product");
int currentQuantity = Integer.parseInt(request.getParameter("currentQuantity"));
int requestQuantity = Integer.parseInt(request.getParameter("requestQuantity"));



StockRequestDto dto = new StockRequestDto();
dto.setBranchNum(branchNum); // ★ 반드시 추가!

dto.setBranchId(branchId);
dto.setInventoryId(inventoryId);
dto.setProduct(product);
dto.setCurrentQuantity(currentQuantity);
dto.setRequestQuantity(requestQuantity);
dto.setStatus("대기중");
dto.setIsPlaceOrder("요청");
dto.setField(""); // 필요시 메모

StockRequestDao dao = new StockRequestDao();
boolean isSuccess = dao.insertRequest(dto);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>발주 요청 결과</title>
    <script>
    <% if(isSuccess) { %>
        // 성공 시 바로 이동
        location.href = "order/list.jsp?branchId=<%= branchId %>";
    <% } else { %>
        // 실패 시 alert 후 이전 페이지로
        alert("발주 요청 실패!");
        history.back();
    <% } %>
    </script>
</head>
<body>
<%-- 본문은 필요 없으나 혹시 JS 안될 경우 대비 --%>
<% if(!isSuccess) { %>
    <h3 style="color:red;">발주 요청에 실패했습니다. 다시 시도해 주세요.</h3>
<% } %>
</body>
</html>