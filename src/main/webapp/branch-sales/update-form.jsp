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
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/branch-sales/update-form.jsp</title>
</head>
<body>
    <h2>매출 수정 (내 지점: <%=branchId%>)</h2>
    <form action="update.jsp" method="post">
        <input type="hidden" name="salesId" value="<%= salesId %>">
        <input type="hidden" name="branchId" value="<%= branchId %>">
        금액: <input type="number" name="totalAmount" value="<%= dto.getTotalAmount() %>" required> 원
        <button type="submit">수정</button>
        <button type="button" onclick="location.href='list.jsp'">목록으로</button>
    </form>
</body>
</html>