<%@page import="test.dao.SalesDao"%>
<%@page import="test.dto.SalesDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    request.setCharacterEncoding("UTF-8");

    String branchId = (String)session.getAttribute("branchId");
    if(branchId == null){
        response.sendRedirect(request.getContextPath()+"/userp/branchlogin-form.jsp");
        return;
    }

    int salesId = Integer.parseInt(request.getParameter("salesId"));
    int totalAmount = Integer.parseInt(request.getParameter("totalAmount"));

    SalesDto dto = new SalesDto();
    dto.setSalesId(salesId);
    dto.setBranchId(branchId);
    dto.setTotalAmount(totalAmount);

    boolean isSuccess = SalesDao.getInstance().update(dto);
    String msg = isSuccess ? "수정 성공!" : "수정 실패!";
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>/branch-sales/update.jsp</title>
</head>
<body>
    <script>
        alert("<%= msg %>");
        location.href = "<%= request.getContextPath() %>/branch-sales/list.jsp";
    </script>
</body>
</html>