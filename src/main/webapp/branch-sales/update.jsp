<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="test.dao.BranchSalesDao" %>
<%@ page import="test.dto.BranchSalesDto" %>
<%
request.setCharacterEncoding("UTF-8");

    // 로그인 세션 확인
    String branchId = (String)session.getAttribute("branchId");
    if(branchId == null){
        response.sendRedirect(request.getContextPath() + "/userp/branchlogin-form.jsp");
        return;
    }

    // 파라미터 수집
    int salesId = Integer.parseInt(request.getParameter("salesId"));
    int totalAmount = Integer.parseInt(request.getParameter("totalAmount"));

    // DTO 생성 및 DB 업데이트
    BranchSalesDto dto = new BranchSalesDto();
    dto.setSalesId(salesId);
    dto.setBranchId(branchId);
    dto.setTotalAmount(totalAmount);

    boolean isSuccess = BranchSalesDao.getInstance().update(dto);
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
        location.href = "<%= request.getContextPath() %>/branch-sales/list.jsp";
    </script>
</body>
</html>