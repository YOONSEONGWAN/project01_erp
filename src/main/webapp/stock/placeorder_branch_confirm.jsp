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
    String manager = (String) session.getAttribute("userId");
    if (manager == null || manager.isEmpty()) {
%>
    <script>
        alert("로그인이 필요합니다.");
        location.href = "<%= request.getContextPath() %>/login.jsp";
    </script>
<%
        return;
    }

    Enumeration<String> paramNames = request.getParameterNames();
    boolean hasApprovalOrRejection = false;

    // 처리할 항목 있는지 체크
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
        location.href = "${pageContext.request.contextPath}/headquater.jsp?page=/stock/placeorder_branch.jsp";
    </script>
<%
        return;
    }

    StockRequestDao stockRequestDao = StockRequestDao.getInstance();
    IngredientDao ingredientDao = IngredientDao.getInstance();
    PlaceOrderBranchDetailDao placeOrderBranchDetailDao = PlaceOrderBranchDetailDao.getInstance();
    OutboundOrdersDao outboundOrdersDao = OutboundOrdersDao.getInstance();
    InventoryDao inventoryDao = InventoryDao.getInstance();

    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

    paramNames = request.getParameterNames(); // 다시 초기화

    // 여러 주문을 한번에 처리하므로, 처리 완료된 order_id를 저장
    java.util.Set<Integer> processedOrderIds = new java.util.HashSet<>();

    while (paramNames.hasMoreElements()) {
        String paramName = paramNames.nextElement();

        if (paramName.startsWith("approval_")) {
            String orderIdStr = paramName.substring("approval_".length());
            String approval = request.getParameter(paramName);

            try {
                int currentOrderId = Integer.parseInt(orderIdStr);

                // 이미 처리된 주문이면 skip (중복 방지)
                if (processedOrderIds.contains(currentOrderId)) {
                    continue;
                }

                // 1. placeorder_branch 테이블에 insert (발주 생성)
                int newOrderId = PlaceOrderBranchDao.getInstance().insert(currentOrderId, manager);

                // 발주 생성 날짜 조회
                String orderDateStr = PlaceOrderBranchDao.getInstance().getOrderDateByOrderId(newOrderId);

                // stock_request 정보 가져오기
                int requestQuantity = stockRequestDao.getRequestQuantityByOrderId(currentOrderId);
                String product = stockRequestDao.getProductByOrderId(currentOrderId);
                int currentQty = stockRequestDao.getQuantityByOrderId(currentOrderId);
                String branchId = stockRequestDao.getBranchIdByOrderId(currentOrderId);
                int inventoryId = stockRequestDao.getInventoryIdByOrderId(currentOrderId);

                if ("YES".equals(approval)) {
                    boolean decreased = inventoryDao.decreaseQuantity(inventoryId, requestQuantity);
                    if (!decreased) {
%>
    <script>
        alert("재고 부족으로 주문 처리에 실패했습니다. 주문번호: <%= currentOrderId %>");
        location.href = "${pageContext.request.contextPath}/headquater.jsp?page=/stock/placeorder_branch.jsp";
    </script>
<%
                        return;
                    }

                    ingredientDao.increaseQuantity(branchId, inventoryId, requestQuantity);
                    stockRequestDao.updateStatus(currentOrderId, "승인");
                } else {
                    stockRequestDao.updateStatus(currentOrderId, "반려");
                }

                stockRequestDao.updateDate(currentOrderId);

                PlaceOrderBranchDetailDto dto = new PlaceOrderBranchDetailDto();
                dto.setOrder_id(newOrderId);
                dto.setBranch_id(branchId);
                dto.setInventory_id(inventoryId);
                dto.setProduct(product);
                dto.setCurrent_quantity(currentQty);
                dto.setRequest_quantity(requestQuantity);
                dto.setApproval_status("YES".equals(approval) ? "승인" : "반려");
                dto.setManager(manager);

                placeOrderBranchDetailDao.insert(dto);

                stockRequestDao.updateIsPlaceOrder(currentOrderId, "no");

                // 출고 이력 insert
                outboundOrdersDao.insert(newOrderId, branchId, "처리됨", orderDateStr, manager);

                processedOrderIds.add(currentOrderId);

            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
%>

<script>
    alert("모든 발주 내역이 정상 처리되었습니다.");
    location.href = "${pageContext.request.contextPath}/headquater.jsp?page=/stock/placeorder_branch.jsp";
</script>