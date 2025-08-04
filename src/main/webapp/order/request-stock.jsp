<%@page import="java.util.*"%>
<%@page import="dto.StockRequestDto"%>
<%@page import="dao.IngredientDao"%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
request.setCharacterEncoding("UTF-8");

List<StockRequestDto> requests = new ArrayList<>();

// items[0].branchNum, items[0].branchId, ... 이런식으로 0, 1, 2... 반복해서 받음
for(int i=0; i<100; i++) { // 100개면 충분. 더 필요하면 숫자 늘려도 됨
    String branchNumStr = request.getParameter("items[" + i + "].branchNum");
    String branchId = request.getParameter("items[" + i + "].branchId");
    String inventoryIdStr = request.getParameter("items[" + i + "].inventoryId");
    String product = request.getParameter("items[" + i + "].product");
    String currentQuantityStr = request.getParameter("items[" + i + "].currentQuantity");
    String requestQuantityStr = request.getParameter("items[" + i + "].requestQuantity");

    // 값이 없으면 반복 종료 (더 이상 데이터 없음)
    if(branchNumStr == null || branchId == null || inventoryIdStr == null ||
       product == null || currentQuantityStr == null || requestQuantityStr == null) {
        break;
    }

<<<<<<< HEAD
dto.setBranchId(branchId);
dto.setInventoryId(inventoryId);
dto.setProduct(product);
dto.setCurrentQuantity(currentQuantity);
dto.setRequestQuantity(requestQuantity);
dto.setStatus("대기중");
dto.setIsPlaceOrder("요청");

=======
    int requestQuantity = Integer.parseInt(requestQuantityStr);
    if(requestQuantity <= 0) continue; // 요청수량이 0 이하면 skip
>>>>>>> da777106801bb60ae953620a17c21197ba68b02b

    StockRequestDto dto = new StockRequestDto();
    dto.setBranchNum(Integer.parseInt(branchNumStr));
    dto.setBranchId(branchId);
    dto.setInventoryId(Integer.parseInt(inventoryIdStr));
    dto.setProduct(product);
    dto.setCurrentQuantity(Integer.parseInt(currentQuantityStr));
    dto.setRequestQuantity(requestQuantity);
    dto.setStatus("대기중");
    dto.setIsPlaceOrder("요청"); 

    requests.add(dto);
}

IngredientDao dao = new IngredientDao();
boolean isSuccess = false;
if(!requests.isEmpty()) {
    isSuccess = dao.requestStock(requests);
}
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>발주 요청 결과</title>
    <script>
    <% if(isSuccess) { %>
        // 성공 시 이동
        location.href = "order/list.jsp?branchId=<%= (requests.size() > 0 ? requests.get(0).getBranchId() : "") %>";
    <% } else { %>
        // 실패 시 alert 후 이전 페이지로
        alert("발주 요청 실패!");
        history.back();
    <% } %>
    </script>
</head>
<body>
<% if(!isSuccess) { %>
    <h3 style="color:red;">발주 요청에 실패했습니다. 다시 시도해 주세요.</h3>
<% } %>
</body>
</html>