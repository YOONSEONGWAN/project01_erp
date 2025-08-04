<%@page import="dao.stock.OutboundOrdersDao"%>
<%@page import="dao.stock.PlaceOrderBranchDetailDao"%>
<%@page import="dto.stock.PlaceOrderBranchDetailDto"%>
<%@page import="dao.stock.PlaceOrderBranchDao"%>
<%@page import="dao.stock.InventoryDao"%>



<%@page import="java.util.Enumeration"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@ page contentType="text/html; charset=UTF-8" %>

<%
    String manager = "admin";

    Enumeration<String> paramNames = request.getParameterNames();
    boolean hasApproval = false;

    // 승인된 항목이 있는지 검사
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
        location.href = "placeorder_branch.jsp";
    </script>
<%
        return;
    }

    int orderId = PlaceOrderBranchDao.getInstance().insert(manager);

    // placeOrder_branch에서 order_date 조회 (예: orderId로 조회하는 메서드 필요)
    String orderDate = PlaceOrderBranchDao.getInstance().getOrderDateByOrderId(orderId);

    // orderDate를 문자열로 변환 (포맷: yyyy-MM-dd HH:mm:ss)
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    String orderDateStr = orderDate;

    paramNames = request.getParameterNames(); // 다시 초기화

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
                    // 승인: 수량 증가
                    InventoryDao.getInstance().increaseQuantity(num, amount);
                    InventoryDao.getInstance().updateApproval(num, "승인");
                } else {
                    // 반려: 수량 유지
                    InventoryDao.getInstance().updateApproval(num, "반려");
                }

                // 승인 여부와 관계없이 발주 신청 해제
                InventoryDao.getInstance().updatePlaceOrder(num, false);

                // 발주 상세 기록
                PlaceOrderBranchDetailDto dto = new PlaceOrderBranchDetailDto();
                dto.setOrder_id(orderId);
                dto.setProduct(product);
                dto.setCurrent_quantity(currentQty);
                dto.setRequest_quantity(amount);
                dto.setApproval_status("YES".equals(approval) ? "승인" : "반려");
                dto.setManager(manager);
                PlaceOrderBranchDetailDao.getInstance().insert(dto);

                // outbound_orders 테이블에도 insert
               	OutboundOrdersDao.getInstance().insert(orderId, dto.getApproval_status(), orderDateStr, manager);

                InventoryDao.getInstance().updateApproval(num, "대기");

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