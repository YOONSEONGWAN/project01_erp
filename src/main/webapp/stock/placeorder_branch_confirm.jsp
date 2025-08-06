<%@page import="dao.IngredientDao"%>
<%@page import="dao.StockRequestDao"%>
<%@page import="dao.stock.*"%>
<%@page import="dto.stock.PlaceOrderBranchDetailDto"%>
<%@page import="java.util.Enumeration"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@ page contentType="text/html; charset=UTF-8" %>

<%
    String manager = "admin";

    Enumeration<String> paramNames = request.getParameterNames();
    boolean hasApprovalOrRejection = false;

    while (paramNames.hasMoreElements()) {
        String param = paramNames.nextElement();
        if (param.startsWith("approval_")) {
            String val = request.getParameter(param);
            if ("YES".equals(val) || "NO".equals(val) || "반려".equals(val)) {
                hasApprovalOrRejection = true;
                break;
            }
        }
    }

    if (!hasApprovalOrRejection) {
%>
    <script>
        alert("처리할 항목이 없습니다.");
        location.href = "placeorder_branch.jsp";
    </script>
<%
        return;
    }

    // StockRequestDao, IngredientDao는 new로 생성
    StockRequestDao stockRequestDao = new StockRequestDao();
    IngredientDao ingredientDao = new IngredientDao();

    // 나머지 DAO는 getInstance() 유지
    PlaceOrderBranchDetailDao placeOrderBranchDetailDao = PlaceOrderBranchDetailDao.getInstance();
    OutboundOrdersDao outboundOrdersDao = OutboundOrdersDao.getInstance();
    InventoryDao inventoryDao = InventoryDao.getInstance();

    // 1. 발주 생성
    int orderId = PlaceOrderBranchDao.getInstance().insert(manager);
    String orderDateStr = PlaceOrderBranchDao.getInstance().getOrderDateByOrderId(orderId);
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

    // 변수 하나 만들어서 마지막 branchId 저장 (출고 이력에 필요)
    String lastBranchId = null;

    // 2. 승인/반려 처리
    paramNames = request.getParameterNames();

    while (paramNames.hasMoreElements()) {
        String paramName = paramNames.nextElement();

        if (paramName.startsWith("approval_")) {
            String numStr = paramName.substring("approval_".length());
            String approval = request.getParameter(paramName);
            String amountStr = request.getParameter("amount_" + numStr);

            try {
                int num = Integer.parseInt(numStr);
                int amount = Integer.parseInt(amountStr);

                String product = stockRequestDao.getProductByNum(num);         
                int currentQty = stockRequestDao.getQuantityByNum(num);       
                String branchId = stockRequestDao.getBranchIdByNum(num);
                int inventoryId = stockRequestDao.getInventoryIdByNum(num);

                lastBranchId = branchId; // 마지막 branchId 저장

                if ("YES".equals(approval)) {
                    ingredientDao.increaseQuantity(branchId, inventoryId, amount);
                    inventoryDao.decreaseQuantity(inventoryId, amount);
                    stockRequestDao.updateStatus(num, "승인");
                } else {
                    stockRequestDao.updateStatus(num, "반려");
                }

                stockRequestDao.updateDate(num); // updatedAt

                // 발주 상세 insert
                PlaceOrderBranchDetailDto dto = new PlaceOrderBranchDetailDto();
                dto.setOrder_id(orderId);
                dto.setBranch_id(branchId);
                dto.setInventory_id(inventoryId);
                dto.setProduct(product);
                dto.setCurrent_quantity(currentQty);
                dto.setRequest_quantity(amount);
                dto.setApproval_status("YES".equals(approval) ? "승인" : "반려");
                dto.setManager(manager);

                placeOrderBranchDetailDao.insert(dto);

                stockRequestDao.updateIsPlaceOrder(num, "no");

            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    // 3. 출고 이력은 order_id 1개당 1건만 insert
    if (lastBranchId != null) {
        outboundOrdersDao.insert(orderId, lastBranchId, "처리됨", orderDateStr, manager);
    }

%>
<script>
    alert("발주 내역이 정상적으로 처리되었습니다.");
    location.href = "placeorder_branch.jsp";
</script>