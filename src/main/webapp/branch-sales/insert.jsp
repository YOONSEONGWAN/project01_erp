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

    // 입력값 수집
    int totalAmount = Integer.parseInt(request.getParameter("totalAmount"));

    // DTO 생성 및 DB 저장
    BranchSalesDto dto = new BranchSalesDto();
    dto.setBranchId(branchId);
    dto.setTotalAmount(totalAmount);

    boolean isSuccess = BranchSalesDao.getInstance().insert(dto);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/branch-sales/save.jsp</title>
</head>
<body>
    <script>
        alert("<%= isSuccess ? "등록 성공" : "등록 실패" %>");
        location.href = "<%=request.getContextPath()%>/branch.jsp?page=branch-sales/list.jsp";
    </script>
</body>
</html>