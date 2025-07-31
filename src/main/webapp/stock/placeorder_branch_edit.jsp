<%@ page import="dao.stock.InventoryDao" %>
<%@ page import="dao.stock.PlaceOrderBranchDetailDao" %>
<%@ page import="dto.stock.PlaceOrderBranchDetailDto" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    try {
        int detailId = Integer.parseInt(request.getParameter("detail_id"));
        int orderId = Integer.parseInt(request.getParameter("order_id"));
        int newRequestQty = Integer.parseInt(request.getParameter("request_quantity"));
        String newApprovalStatus = request.getParameter("approval_status");

        
        PlaceOrderBranchDetailDto oldDto = PlaceOrderBranchDetailDao.getInstance().getByDetailId(detailId);
        int oldRequestQty = oldDto.getRequest_quantity();
        String oldApprovalStatus = oldDto.getApproval_status();
        String product = oldDto.getProduct();
        int currentQty = oldDto.getCurrent_quantity(); //

       
        int productNum = //BranchStockDao.getInstance().getNumByProduct(product);

        
        boolean BranchStockUpdated = //BranchStock.getInstance()
            .updateQuantityByApproval(productNum, oldRequestQty, newRequestQty, oldApprovalStatus, newApprovalStatus, currentQty); 

        if (!BranchStockUpdated) {
%>
            <script>
                alert("재고 업데이트 실패. 다시 시도해주세요.");
                history.back();
            </script>
<%
            return;
        }

       
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
        <script>
            alert("처리 중 오류가 발생했습니다.");
            history.back();
        </script>
<%
    }
%>