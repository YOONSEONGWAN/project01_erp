<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="test.dao.SalesDao" %>
<%
    request.setCharacterEncoding("UTF-8");

    String branchId = (String)session.getAttribute("branchId");
    if(branchId == null){
        response.sendRedirect(request.getContextPath()+"/userp/branchlogin-form.jsp");
        return;
    }

    int salesId = Integer.parseInt(request.getParameter("salesId"));
    boolean isSuccess = SalesDao.getInstance().delete(salesId, branchId);
%>
<script>
    alert("<%= isSuccess ? "삭제 성공" : "삭제 실패" %>");
    location.href = "list.jsp";
</script>