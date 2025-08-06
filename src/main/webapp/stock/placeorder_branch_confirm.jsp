<%@page import="dao.IngredientDao"%>
<%@page import="dao.StockRequestDao"%>
<%@page import="dao.stock.PlaceOrderBranchDetailDao"%>
<%@page import="dao.stock.PlaceOrderBranchDao"%>
<%@page import="dao.stock.OutboundOrdersDao"%>
<%@page import="dao.stock.InventoryDao"%>
<%@page import="dto.stock.PlaceOrderBranchDetailDto"%>
<%@page import="java.util.Enumeration"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@ page contentType="text/html; charset=UTF-8" %>

<%
    String manager = "admin";

    Enumeration<String> paramNames = request.getParameterNames();
    boolean hasApprovalOrRejection = false;

    // 승인 혹은 반려 처리할 항목 있는지 체크
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
    PlaceOrderBranchDetailDao placeOrderBranchDetailDao = PlaceOrderBranchDetailDao.getInstance();
    OutboundOrdersDao outboundOrdersDao = OutboundOrdersDao.getInstance();
    InventoryDao inventoryDao = InventoryDao.getInstance();

    // 1. 발주 생성
    int orderId = PlaceOrderBranchDao.getInstance().insert(manager);
    String orderDateStr = PlaceOrderBranchDao.getInstance().getOrderDateByOrderId(orderId);
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

    String lastBranchId = null;

    // 2. 승인/반려 처리
    paramNames = request.getParameterNames();

    while (paramNames.hasMoreElements()) {
        String paramName = paramNames.nextElement();

        if (paramName.startsWith("approval_")) {
            String orderIdStr = paramName.substring("approval_".length());
            String approval = request.getParameter(paramName);

            try {
                int currentOrderId = Integer.parseInt(orderIdStr);

                // DB에서 실제 요청 수량과 inventory_id, product 등 가져오기
                int requestQuantity = stockRequestDao.getRequestQuantityByOrderId(currentOrderId);
                String product = stockRequestDao.getProductByOrderId(currentOrderId);
                int currentQty = stockRequestDao.getQuantityByOrderId(currentOrderId);
                String branchId = stockRequestDao.getBranchIdByOrderId(currentOrderId);
                int inventoryId = stockRequestDao.getInventoryIdByOrderId(currentOrderId);

                lastBranchId = branchId;

                if ("YES".equals(approval)) {
                    // 1) inventory 재고에서 요청 수량만큼 차감 시도
                    boolean decreased = inventoryDao.decreaseQuantity(inventoryId, requestQuantity);
                    if (!decreased) {
%>
<script>
    alert("재고 부족으로 주문 처리에 실패했습니다. 주문번호: <%= currentOrderId %>");
    location.href = "placeorder_branch.jsp";
</script>
<%
                        return;
                    }

                    // 2) branch_stock 재고에 요청 수량만큼 증가
                    ingredientDao.increaseQuantity(branchId, inventoryId, requestQuantity);

                    // 3) 주문 상태 승인으로 변경
                    stockRequestDao.updateStatus(currentOrderId, "승인");
                } else {
                    // 반려 처리
                    stockRequestDao.updateStatus(currentOrderId, "반려");
                }

                // 4) 주문 처리 날짜 업데이트
                stockRequestDao.updateDate(currentOrderId);

                // 5) 발주 상세 내역 Insert
                PlaceOrderBranchDetailDto dto = new PlaceOrderBranchDetailDto();
                dto.setOrder_id(orderId);
                dto.setBranch_id(branchId);
                dto.setInventory_id(inventoryId);
                dto.setProduct(product);
                dto.setCurrent_quantity(currentQty);
                dto.setRequest_quantity(requestQuantity);
                dto.setApproval_status("YES".equals(approval) ? "승인" : "반려");
                dto.setManager(manager);

                placeOrderBranchDetailDao.insert(dto);

                // 6) 발주 여부 플래그 업데이트
                stockRequestDao.updateIsPlaceOrder(currentOrderId, "no");

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