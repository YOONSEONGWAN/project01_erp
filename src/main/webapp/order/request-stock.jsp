<%@page import="dao.StockRequestDao"%>
<%@page import="java.util.*"%>
<%@page import="dto.StockRequestDto"%>
<%@page import="dao.IngredientDao"%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%

request.setCharacterEncoding("UTF-8");

List<StockRequestDto> requests = new ArrayList<>();

for(int i=0; i<100; i++) {
    String branchNumStr = request.getParameter("items[" + i + "].branchNum");
    String branchId = request.getParameter("items[" + i + "].branchId");
    String inventoryIdStr = request.getParameter("items[" + i + "].inventoryId");
    String product = request.getParameter("items[" + i + "].product");
    String currentQuantityStr = request.getParameter("items[" + i + "].currentQuantity");
    String requestQuantityStr = request.getParameter("items[" + i + "].requestQuantity");

    if(branchNumStr == null || branchId == null || inventoryIdStr == null ||
       product == null || currentQuantityStr == null || requestQuantityStr == null) {
        break;
    }
   
  



    int requestQuantity = Integer.parseInt(requestQuantityStr);
    if(requestQuantity <= 0) continue; // 요청수량이 0 이하면 skip



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


boolean isSuccess = false;
if(!requests.isEmpty()) {
    isSuccess = StockRequestDao.getInstance().batchInsertRequest(requests);
}
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>발주 요청 결과</title>
    <script>
    <% if(isSuccess) { %>
        location.href = "${pageContext.request.contextPath }/order/list.jsp?branchId=<%= (requests.size() > 0 ? requests.get(0).getBranchId() : "") %>";
    <% } else { %>
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