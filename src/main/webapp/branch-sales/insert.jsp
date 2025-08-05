<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="test.dao.SalesDao" %>
<%@ page import="test.dto.SalesDto" %>
<%
    request.setCharacterEncoding("UTF-8");

    String branchId = (String)session.getAttribute("branchId");
    if(branchId == null){
        response.sendRedirect(request.getContextPath()+"/userp/branchlogin-form.jsp");
        return;
    }

    int totalAmount = Integer.parseInt(request.getParameter("totalAmount"));

    SalesDto dto = new SalesDto();
    dto.setBranchId(branchId);
    dto.setTotalAmount(totalAmount);

    boolean isSuccess = SalesDao.getInstance().insert(dto);
%>
<script>
    alert("<%= isSuccess ? "등록 성공" : "등록 실패" %>");
    location.href = "list.jsp";
</script>