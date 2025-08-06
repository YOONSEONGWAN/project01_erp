<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="test.dao.BranchSalesDao" %>
<%
request.setCharacterEncoding("UTF-8");

// 로그인 세션 확인
String branchId = (String)session.getAttribute("branchId");
if(branchId == null){
    response.sendRedirect(request.getContextPath() + "/userp/branchlogin-form.jsp");
    return;
}

// 삭제할 매출 번호
int salesId = Integer.parseInt(request.getParameter("salesId"));

// DB 삭제 수행
boolean isSuccess = BranchSalesDao.getInstance().delete(salesId, branchId);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/branch-sales/delete.jsp</title>
</head>
<body>
<script>
    <% if(isSuccess){ %>
        alert("삭제 성공");
        location.href="<%=request.getContextPath()%>/branch-sales/list.jsp";
    <% } else { %>
        alert("삭제 실패");
        history.back();
    <% } %>
</script>
</body>
</html>