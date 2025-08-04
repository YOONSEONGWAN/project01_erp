<%@page import="test.dao.SalesDao"%>
<%@page import="test.dto.SalesDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    request.setCharacterEncoding("UTF-8");

    // GET 방식 접근 차단
    if (!request.getMethod().equals("POST")) {
        response.sendRedirect("insert-form.jsp");
        return;
    }

    String branchId = (String)session.getAttribute("branchId");
    int totalAmount = Integer.parseInt(request.getParameter("totalAmount"));

    SalesDto dto = new SalesDto();
    dto.setBranchId(branchId);
    dto.setTotalAmount(totalAmount);

    boolean isSuccess = SalesDao.getInstance().insert(dto);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>/branch-sales/insert.jsp</title>
</head>
<body>
    <script>
        const cpath = "<%= request.getContextPath() %>";
        alert("<%= isSuccess ? "등록 성공!" : "등록 실패!" %>");
        location.href = cpath + "/branch-sales/list.jsp";
    </script>
</body>
</html>