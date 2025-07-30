<%@page import="dao.stock.InventoryDao"%>
<%@page import="dao.stock.PlaceOrderHeadDao"%>
<%@page import="dao.stock.PlaceOrderHeadDetailDao"%>
<%@page import="dto.stock.PlaceOrderHeadDetailDto"%>
<%@page import="java.time.LocalDate"%>
<%@page import="java.util.Enumeration"%>
<%@ page contentType="text/html; charset=UTF-8" %>

<%
    LocalDate today = LocalDate.now();
    LocalDate newExpirationDate = today.plusMonths(6);
    String manager = "admin";

    Enumeration<String> paramNames = request.getParameterNames();
    boolean hasApproval = false;

    // 승인된 항목이 하나라도 있는지 체크
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

    // 발주 헤더 insert (order_id 받기)
    int orderId = PlaceOrderHeadDao.getInstance().insert(manager);

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

                String product = InventoryDao.getInstance().getProductByNum(num);
                int currentQty = InventoryDao.getInstance().getQuantityByNum(num);

                if ("YES".equals(approval)) {
                    // 승인 처리: 재고 수량 증가, 유통기한 갱신
                    InventoryDao.getInstance().increaseQuantity(num, amount);
                    InventoryDao.getInstance().updateExpirationDate(num, newExpirationDate);
                    // 승인 상태 업데이트 + 발주 신청 해제
                    InventoryDao.getInstance().updateApproval(num, "승인");
                    InventoryDao.getInstance().updatePlaceOrder(num, false);
                    
                    PlaceOrderHeadDetailDto dto = new PlaceOrderHeadDetailDto();
                    dto.setOrder_id(orderId);
                    dto.setProduct(product);
                    dto.setCurrent_quantity(currentQty);
                    dto.setRequest_quantity(amount);
                    dto.setApproval_status("승인");
                    dto.setManager(manager);
                    PlaceOrderHeadDetailDao.getInstance().insert(dto);

                } else {
                    // 반려 처리: 상태만 반려로 변경 + 발주 신청 해제
                    InventoryDao.getInstance().updateApproval(num, "반려");
                    InventoryDao.getInstance().updatePlaceOrder(num, false);

                    PlaceOrderHeadDetailDto dto = new PlaceOrderHeadDetailDto();
                    dto.setOrder_id(orderId);
                    dto.setProduct(product);
                    dto.setCurrent_quantity(currentQty);
                    dto.setRequest_quantity(amount);
                    dto.setApproval_status("반려");
                    dto.setManager(manager);
                    PlaceOrderHeadDetailDao.getInstance().insert(dto);
                }
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