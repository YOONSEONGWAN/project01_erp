<%@page import="test.dao.SalesDao"%>
<%@page import="test.dto.SalesDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    request.setCharacterEncoding("UTF-8");

    if (!request.getMethod().equals("POST")) {
        response.sendRedirect("list.jsp");
        return;
    }

    int salesId = Integer.parseInt(request.getParameter("salesId"));
    String branchId = request.getParameter("branchId");
    int totalAmount = Integer.parseInt(request.getParameter("totalAmount"));

    SalesDto dto = new SalesDto();
    dto.setSalesId(salesId);
    dto.setBranchId(branchId);
    dto.setTotalAmount(totalAmount);

    boolean isSuccess = SalesDao.getInstance().update(dto);
    String cpath = request.getContextPath(); // contextPath 저장
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>/branch-sales/update.jsp</title>
</head>
<body>
    <script>
        alert("<%= isSuccess ? "수정 성공!" : "수정 실패!" %>");
        location.href = "<%= cpath %>/branch-sales/list.jsp";
    </script>
</body>
</html>