<%@page import="dao.StockRequestDao"%>
<%@page import="dao.IngredientDao"%>
<%@page import="dao.stock.PlaceOrderBranchDetailDao"%>
<%@page import="dto.stock.PlaceOrderBranchDetailDto"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
try {
    int detailId = Integer.parseInt(request.getParameter("detail_id"));
    int orderId = Integer.parseInt(request.getParameter("order_id"));
    int newRequestQty = Integer.parseInt(request.getParameter("request_quantity"));
    String newApprovalStatus = request.getParameter("approval_status");

    // 기존 발주 상세 정보 조회
    PlaceOrderBranchDetailDto oldDto = PlaceOrderBranchDetailDao.getInstance().getDetailById(detailId);
    if (oldDto == null) {
%>
        <script>alert("해당 발주 상세 정보가 없습니다."); history.back();</script>
<%
        return;
    }

    int oldRequestQty = oldDto.getRequest_quantity();
    String oldApprovalStatus = oldDto.getApproval_status();
    String branchId = oldDto.getBranch_id();
    int inventoryId = oldDto.getInventory_id();

    StockRequestDao stockRequestDao = new StockRequestDao();
    IngredientDao ingredientDao = new IngredientDao();

    int requestNum = stockRequestDao.getNumByDetailId(detailId); // 이 메서드 구현 필요

    // 허용되지 않는 상태 변경 차단 (승인 → 승인)
    if ("승인".equals(oldApprovalStatus) && "승인".equals(newApprovalStatus)) {
%>
        <script>
            alert("승인 상태에서 수량만 변경은 허용되지 않습니다.");
            history.back();
        </script>
<%
        return;
    }

    // 상태 변경 처리
    if ("승인".equals(oldApprovalStatus) && "반려".equals(newApprovalStatus)) {
        // 승인 → 반려
        ingredientDao.decreaseQuantity(branchId, inventoryId, oldRequestQty);       // 지점 재고 원복
        stockRequestDao.increaseCurrentQuantity(requestNum, oldRequestQty);         // 창고 재고 원복
        stockRequestDao.updateStatus(requestNum, "반려");

    } else if ("반려".equals(oldApprovalStatus) && "승인".equals(newApprovalStatus)) {
        // 반려 → 승인
        ingredientDao.increaseQuantity(branchId, inventoryId, newRequestQty);       // 지점 재고 증가
        stockRequestDao.decreaseCurrentQuantity(requestNum, newRequestQty);         // 창고 재고 차감
        stockRequestDao.updateStatus(requestNum, "승인");
    }

    // 상세 발주 업데이트
    boolean result = PlaceOrderBranchDetailDao.getInstance()
                        .update(detailId, newRequestQty, newApprovalStatus);

    if (result) {
%>
        <script>
            alert("수정이 완료되었습니다.");
            location.href = "placeorder_branch_detail.jsp?order_id=<%= orderId %>";
        </script>
<%
    } else {
%>
        <script>
            alert("상세 정보 업데이트 실패. 다시 시도해주세요.");
            history.back();
        </script>
<%
    }

} catch (Exception e) {
    e.printStackTrace();
%>
    <script>alert("처리 중 오류가 발생했습니다."); history.back();</script>
<%
}
%>