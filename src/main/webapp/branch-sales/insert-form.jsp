<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    request.setCharacterEncoding("UTF-8");
    String branchId = (String) session.getAttribute("branchId");
    if(branchId == null){
        response.sendRedirect(request.getContextPath()+"/userp/branchlogin-form.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/branch-sales/insert-form.jsp</title>
</head>
<body>
    <h2>내 지점(<%=branchId%>) 매출 등록</h2>
    <form action="insert.jsp" method="post">
        <input type="hidden" name="branchId" value="<%= branchId %>">
        금액: <input type="number" name="totalAmount" required> 원
        <button type="submit">등록</button>
        <button type="button" onclick="location.href='list.jsp'">목록으로</button>
    </form>
</body>
</html>
