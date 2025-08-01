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

        // 재고 및 요청 관련 DAO
        StockRequestDao stockRequestDao = new StockRequestDao();
        IngredientDao ingredientDao = new IngredientDao();

        int requestNum = stockRequestDao.getNumByDetailId(detailId); // 반드시 구현되어 있어야 함

        // 상태 및 수량 변경 처리
        if ("승인".equals(oldApprovalStatus) && "반려".equals(newApprovalStatus)) {
            // 승인 → 반려: 기존 승인 수량만큼 원복
            stockRequestDao.decreaseCurrentQuantity(requestNum, oldRequestQty);
            ingredientDao.decreaseQuantity(branchId, inventoryId, oldRequestQty);

        } else if ("반려".equals(oldApprovalStatus) && "승인".equals(newApprovalStatus)) {
            // 반려 → 승인: 새로운 신청 수량만큼 증가
            stockRequestDao.increaseCurrentQuantity(requestNum, newRequestQty);
            ingredientDao.increaseQuantity(branchId, inventoryId, newRequestQty);

        } else if ("승인".equals(oldApprovalStatus) && "승인".equals(newApprovalStatus)) {
            int diff = newRequestQty - oldRequestQty;
            if (diff != 0) {
                stockRequestDao.adjustCurrentQuantity(requestNum, diff);
                ingredientDao.adjustQuantity(branchId, inventoryId, diff);
            }
        }

        // 최종 발주 상세 업데이트
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