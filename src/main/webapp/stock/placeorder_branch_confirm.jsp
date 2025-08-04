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

    StockRequestDao stockRequestDao = new StockRequestDao();  
    IngredientDao ingredientDao = new IngredientDao();         

    PlaceOrderBranchDao placeOrderBranchDao = PlaceOrderBranchDao.getInstance();
    InventoryDao inventoryDao = InventoryDao.getInstance();
    PlaceOrderBranchDetailDao placeOrderBranchDetailDao = PlaceOrderBranchDetailDao.getInstance();
    OutboundOrdersDao outboundOrdersDao = OutboundOrdersDao.getInstance();

    int orderId = placeOrderBranchDao.insert(manager);
    String orderDateStr = placeOrderBranchDao.getOrderDateByOrderId(orderId);
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

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

                if ("YES".equals(approval)) {
                    // 승인: 수량 증감, 상태 변경
                    ingredientDao.increaseQuantity(branchId, inventoryId, amount);
                    inventoryDao.decreaseQuantity(inventoryId, amount);
                    stockRequestDao.updateStatus(num, "승인");
                } else {
                    // 반려: 상태만 변경
                    stockRequestDao.updateStatus(num, "반려");
                }

                // 공통 처리
                stockRequestDao.updateDate(num); // updatedAt = SYSDATE

                // 상세 발주 기록 저장
                PlaceOrderBranchDetailDto dto = new PlaceOrderBranchDetailDto();
                dto.setOrder_id(orderId);
                dto.setBranch_id(branchId);
                dto.setInventory_id(inventoryId);
                dto.setProduct(product);
                dto.setCurrent_quantity(currentQty);
                dto.setRequest_quantity(amount);
                dto.setApproval_status("YES".equals(approval) ? "승인" : "반려");
                dto.setManager(manager);


                // outbound_orders 테이블에도 insert
               	OutboundOrdersDao.getInstance().insert(orderId, branchId, dto.getApproval_status(), orderDateStr, manager);

                InventoryDao.getInstance().updateApproval(num, "대기");

                placeOrderBranchDetailDao.insert(dto);


                // 출고 이력 저장 (inventoryId 사용, approvalStatus 인자 순서 주의!)
               	outboundOrdersDao.insert(orderId, branchId, dto.getApproval_status(), orderDateStr, manager);
                
                // ★ isplaceorder 값을 'no'로 변경 추가 ★
                stockRequestDao.updateIsPlaceOrder(num, "no");
                
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
%>

<script>
    alert("발주 내역이 정상적으로 처리되었습니다.");
    location.href = "placeorder_branch.jsp";
</script>