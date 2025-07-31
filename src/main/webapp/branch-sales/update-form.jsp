<%@page import="test.dao.SalesDao"%>
<%@page import="test.dto.SalesDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    request.setCharacterEncoding("UTF-8");
    int salesId = Integer.parseInt(request.getParameter("salesId"));
    SalesDto dto = SalesDao.getInstance().getById(salesId);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>/branch-sales/update-form.jsp</title>
</head>
<body>
    <h2>매출 수정</h2>
    <form action="${pageContext.request.contextPath}/branch-sales/update.jsp" method="post">
        <input type="hidden" name="salesId" value="<%= dto.getSalesId() %>">
        <p>
            <label>지점 ID:
                <input type="text" name="branchId" value="<%= dto.getBranchId() %>" required>
            </label>
        </p>
        <p>
            <label>매출 금액:
                <input type="number" name="totalAmount" value="<%= dto.getTotalAmount() %>" required>
            </label>
        </p>
        <p>
            <button type="submit">수정</button>
            <button type="button" onclick="location.href='${pageContext.request.contextPath}/branch-sales/list.jsp'">취소</button>
        </p>
    </form>
</body>
</html>