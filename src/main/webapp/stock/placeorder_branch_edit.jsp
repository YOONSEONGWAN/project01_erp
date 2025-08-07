<%@page import="dao.IngredientDao"%>
<%@page import="dao.StockRequestDao"%>
<%@page import="dao.stock.PlaceOrderBranchDetailDao"%>
<%@page import="dao.stock.InventoryDao"%>
<%@page import="dto.stock.PlaceOrderBranchDetailDto"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
try {
    int detailId = Integer.parseInt(request.getParameter("detail_id"));
    String newStatus = request.getParameter("approval_status");

    PlaceOrderBranchDetailDao detailDao = PlaceOrderBranchDetailDao.getInstance();
    StockRequestDao stockRequestDao = StockRequestDao.getInstance();
    InventoryDao inventoryDao = InventoryDao.getInstance();
    IngredientDao ingredientDao = IngredientDao.getInstance();

    PlaceOrderBranchDetailDto dto = detailDao.getDetailById(detailId);
    if (dto == null) {
%>
        <script>alert("해당 발주 상세 정보가 없습니다."); history.back();</script>
<%
        return;
    }

    int orderId = dto.getOrder_id();
    String oldStatus = dto.getApproval_status();
    int inventoryId = dto.getInventory_id();
    int requestQty = dto.getRequest_quantity();
    String branchId = dto.getBranch_id();

    if (oldStatus.equals(newStatus)) {
%>
        <script>alert("현재 상태와 동일합니다."); history.back();</script>
<%
        return;
    }

    if (!("승인".equals(newStatus) || "반려".equals(newStatus))) {
%>
        <script>alert("허용되지 않은 상태 값입니다."); history.back();</script>
<%
        return;
    }

    boolean inventoryResult = true;
    boolean ingredientResult = true;

    if ("승인".equals(oldStatus) && "반려".equals(newStatus)) {
        // inventory 재고 증가
        inventoryResult = inventoryDao.increaseQuantity2(inventoryId, requestQty);
        // stock_request current_quantity 감소
        ingredientResult = ingredientDao.decreaseCurrentQuantity2(branchId, inventoryId, requestQty);

    } else if ("반려".equals(oldStatus) && "승인".equals(newStatus)) {
        // inventory 재고 감소
        inventoryResult = inventoryDao.decreaseQuantity2(inventoryId, requestQty);
        // stock_request current_quantity 증가
        ingredientResult = ingredientDao.increaseCurrentQuantity2(branchId, inventoryId, requestQty);
    }

    if (!inventoryResult || !ingredientResult) {
%>
        <script>
            alert("재고 수량 변경에 실패했습니다. 재고 부족 또는 시스템 오류.");
            history.back();
        </script>
<%
        return;
    }

    boolean detailUpdated = detailDao.updateApprovalStatus(detailId, requestQty, newStatus);
    boolean stockUpdated = stockRequestDao.updateStatusByOrderId(orderId, newStatus);

    if (detailUpdated && stockUpdated) {
%>
        <script>
            alert("상태 및 재고 변경이 완료되었습니다.");
            location.href = "<%= request.getContextPath() %>/headquater.jsp?page=/stock/placeorder_branch_detail.jsp?order_id=<%= orderId %>";
        </script>
<%
    } else {
%>
        <script>
            alert("상태 변경 실패. 다시 시도해주세요.");
            history.back();
        </script>
<%
    }

} catch (Exception e) {
    e.printStackTrace();
%>
    <script>
        alert("처리 중 오류가 발생했습니다.");
        history.back();
    </script>
<%
}
%>