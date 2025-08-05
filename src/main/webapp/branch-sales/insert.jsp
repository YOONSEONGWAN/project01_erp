<%@page import="test.dao.BranchSalesDao"%>
<%@page import="test.dto.BranchSalesDto"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    request.setCharacterEncoding("UTF-8");

    String branchId = request.getParameter("branchId");
    if(branchId == null){
        response.sendRedirect(request.getContextPath()+"/userp/branchlogin-form.jsp");
        return;
    }

    int totalAmount = Integer.parseInt(request.getParameter("totalAmount"));

    BranchSalesDto dto = new BranchSalesDto();
    dto.setBranchId(branchId);
    dto.setTotalAmount(totalAmount);

    boolean isSuccess = BranchSalesDao.getInstance().insert(dto);
%>
<script>
    alert("<%= isSuccess ? "등록 성공" : "등록 실패" %>");
    location.href = "summary.jsp";
</script>