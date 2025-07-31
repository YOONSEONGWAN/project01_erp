<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="test.dao.SalesDao" %>
<%@ page import="test.dto.SalesSummaryDto" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>/sales2/list.jsp</title>
</head>
<body>
    <h2>지점별 총 매출</h2>
    <p><a href="${pageContext.request.contextPath}/sales2/insert-form.jsp">[매출 등록]</a></p>
    <table border="1" cellpadding="8" cellspacing="0">
        <thead>
            <tr>
                <th>지점명</th>
                <th>총 매출 (원)</th>
                <th>상세보기</th>
            </tr>
        </thead>
        <tbody>
            <%
                SalesDao dao = new SalesDao();
                List<SalesSummaryDto> list = dao.getBranchSalesSummary();

                for (SalesSummaryDto dto : list) {
            %>
            <tr>
                <td><%= dto.getBranch() %></td>
                <td><%= dto.getTotalAmount() %></td>
                <td><a href="${pageContext.request.contextPath}/sales2/detail.jsp?branch=<%= dto.getBranch() %>">통계보기</a></td>
            </tr>
            <% } %>
        </tbody>
    </table>
</body>
</html>
