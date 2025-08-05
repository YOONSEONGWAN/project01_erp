<%@page import="test.dao.BranchSalesDao"%>
<%@page import="test.dto.BranchSalesDto"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    request.setCharacterEncoding("UTF-8");

    String branchId = (String) session.getAttribute("branchId");
    if(branchId == null){
        response.sendRedirect(request.getContextPath()+"/userp/branchlogin-form.jsp");
        return;
    }

    int salesId = Integer.parseInt(request.getParameter("salesId"));
    BranchSalesDto dto = BranchSalesDao.getInstance().getData(salesId);

    if(dto == null || !branchId.equals(dto.getBranchId())){
        out.println("<script>alert('권한이 없습니다.'); location.href='list.jsp';</script>");
        return;
    }

    boolean isSuccess = BranchSalesDao.getInstance().delete(salesId);
%>
<script>
    alert("<%= isSuccess ? "삭제 성공" : "삭제 실패" %>");
    location.href = "summary.jsp";
</script>