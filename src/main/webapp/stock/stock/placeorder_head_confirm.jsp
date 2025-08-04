<%@page import="dao.stock.InventoryDao"%>
<%@page import="dao.stock.PlaceOrderHeadDao"%>
<%@page import="dao.stock.PlaceOrderHeadDetailDao"%>
<%@page import="dao.stock.InboundOrdersDao"%>
<%@page import="dto.stock.PlaceOrderHeadDetailDto"%>
<%@page import="java.util.Enumeration"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page contentType="text/html; charset=UTF-8" %>

<%
    String manager = "admin";

    Enumeration<String> paramNames = request.getParameterNames();
    boolean hasApproval = false;

    while (paramNames.hasMoreElements()) {
        String param = paramNames.nextElement();
        if (param.startsWith("approval_") && "YES".equals(request.getParameter(param))) {
            hasApproval = true;
            break;
        }
    }

    if (!hasApproval) {
%>
    <script>
        alert("승인된 항목이 없습니다.");
        location.href = "placeorder_head.jsp";
    </script>
<%
        return;
    }

    // 예: 첫 번째 승인 항목에서 inventory_num 가져오기
    int inventoryNum = -1;
    paramNames = request.getParameterNames(); // 다시 초기화
    while (paramNames.hasMoreElements()) {
        String param = paramNames.nextElement();
        if (param.startsWith("approval_") && "YES".equals(request.getParameter(param))) {
            String numStr = param.substring("approval_".length());
            inventoryNum = Integer.parseInt(numStr);
            break;
        }
    }

    if (inventoryNum == -1) {
%>
    <script>
        alert("inventory_num을 찾을 수 없습니다.");
        location.href = "placeorder_head.jsp";
    </script>
<%
        return;
    }

    int orderId = PlaceOrderHeadDao.getInstance().insert(manager, inventoryNum);
    if (orderId <= 0) {
%>
    <script>
        alert("발주서 생성 실패 (orderId 유효하지 않음)");
        location.href = "placeorder_head.jsp";
    </script>
<%
        return;
    }

    // 발주일 조회
    String orderDate = PlaceOrderHeadDao.getInstance().getOrderDateByOrderId(orderId);
    String orderDateStr = orderDate != null ? orderDate : new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new java.util.Date());

    paramNames = request.getParameterNames(); // 다시 초기화
    boolean inboundInserted = false;

    while (paramNames.hasMoreElements()) {
        String paramName = paramNames.nextElement();

        if (paramName.startsWith("approval_")) {
            String numStr = paramName.substring("approval_".length());
            String approval = request.getParameter(paramName);
            String amountStr = request.getParameter("amount_" + numStr);

            try {
                int num = Integer.parseInt(numStr);
                int amount = Integer.parseInt(amountStr);

                String product = InventoryDao.getInstance().getProductByNum(num);
                int currentQty = InventoryDao.getInstance().getQuantityByNum(num);

                if ("YES".equals(approval)) {
                    InventoryDao.getInstance().increaseQuantity(num, amount);
                    InventoryDao.getInstance().updateApproval(num, "승인");
                } else {
                    InventoryDao.getInstance().updateApproval(num, "반려");
                }

                InventoryDao.getInstance().updatePlaceOrder(num, false);

                // 상세 레코드 insert
                PlaceOrderHeadDetailDto dto = new PlaceOrderHeadDetailDto();
                dto.setOrder_id(orderId);
                dto.setProduct(product);
                dto.setCurrent_quantity(currentQty);
                dto.setRequest_quantity(amount);
                dto.setApproval_status("YES".equals(approval) ? "승인" : "반려");
                dto.setManager(manager);
                PlaceOrderHeadDetailDao.getInstance().insert(dto);

                // inbound_orders는 나중에 테이블 수정 후 처리 (주석 처리 가능)
                if (!inboundInserted) {
                    InboundOrdersDao.getInstance().insert(orderId, inventoryNum, dto.getApproval_status(), orderDateStr, manager);
                    inboundInserted = true;
                }

                InventoryDao.getInstance().updateApproval(num, "대기");

            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
%>

<script>
    alert("발주 내역이 정상적으로 처리되었습니다.");
    location.href = "placeorder_head.jsp";
</script>
</script>