<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="test.dao.SalesDao" %>
<%@ page import="test.dto.SalesDto" %>
<%
    request.setCharacterEncoding("UTF-8");
    int salesId = Integer.parseInt(request.getParameter("salesId"));
    SalesDao dao = new SalesDao();
    SalesDto dto = dao.getData(salesId);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>/sales2/update-form.jsp</title>
</head>
<body>
    <h2>매출 수정</h2>
    <form action="${pageContext.request.contextPath}/sales2/update.jsp" method="post">
        <input type="hidden" name="salesId" value="<%= dto.getSalesId() %>">
        <p>
            지점명: <input type="text" name="branch" value="<%= dto.getBranch() %>" required>
        </p>
        <p>
            날짜: <input type="date" name="createdAt" value="<%= dto.getCreatedAt() %>" required>
        </p>
        <p>
            총매출(원): <input type="number" name="totalAmount" value="<%= dto.getTotalAmount() %>" required>
        </p>
        <p>
            <button type="submit">수정</button>
        </p>
    </form>
    <p><a href="${pageContext.request.contextPath}/sales2/detail.jsp?branch=<%= dto.getBranch() %>">[돌아가기]</a></p>
</body>
</html>
