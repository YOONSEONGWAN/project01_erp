<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="test.dao.SalesDao" %>
<%@ page import="test.dto.SalesDto" %>
<%
    request.setCharacterEncoding("UTF-8");
    String branch = request.getParameter("branch");
    SalesDao dao = new SalesDao();
    List<SalesDto> list = dao.getSalesByBranch(branch);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title><%= branch %> /sales2/detail.jsp</title>
</head>
<body>
    <h2><%= branch %> 지점의 일별 매출</h2>
    <p><a href="${pageContext.request.contextPath}/sales2/list.jsp">[목록으로]</a></p>
    <table border="1" cellpadding="8" cellspacing="0">
        <thead>
            <tr>
                <th>날짜</th>
                <th>총 매출</th>
                <th>수정</th>
                <th>삭제</th>
            </tr>
        </thead>
        <tbody>
            <% for (SalesDto dto : list) { %>
            <tr>
                <td><%= dto.getCreatedAt() %></td>
                <td><%= dto.getTotalAmount() %></td>
                <td><a href="${pageContext.request.contextPath}/sales2/update-form.jsp?salesId=<%= dto.getSalesId() %>">수정</a></td>
                <td><a href="${pageContext.request.contextPath}/sales2/delete.jsp?salesId=<%= dto.getSalesId() %>" onclick="return confirm('삭제하시겠습니까?')">삭제</a></td>
            </tr>
            <% } %>
        </tbody>
    </table>
</body>
</html>
