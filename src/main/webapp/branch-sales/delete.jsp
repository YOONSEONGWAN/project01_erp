<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="test.dao.BranchSalesDao" %>
<%
request.setCharacterEncoding("UTF-8");

    // 삭제할 매출 번호와 지점 ID 파라미터
    int salesId = Integer.parseInt(request.getParameter("salesId"));
    String branchId = request.getParameter("branchId");

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
        <%-- 삭제 성공 여부에 따라 알림창 후 이동 처리 --%>
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