<%@page import="test.dao.SalesDao"%>
<%@page import="test.dto.SalesSummaryDto"%>
<%@page import="java.util.List"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>/branch-sales/summary.jsp</title>
</head>
<body>
    <h2>지점별 매출 요약</h2>
    <%
        List<SalesSummaryDto> branchList = SalesDao.getInstance().getBranchSalesSummary();
    %>
    <table border="1">
        <tr>
            <th>지점ID</th>
            <th>지점명</th>
            <th>총 매출</th>
        </tr>
        <% for(SalesSummaryDto dto : branchList){ %>
        <tr>
            <td><%= dto.getBranch() %></td>
            <td><%= dto.getBranchName() %></td>
            <td><%= dto.getTotalAmount() %> 원</td>
        </tr>
        <% } %>
    </table>

    <h2>일자 + 지점별 매출 요약</h2>
    <%
        List<SalesSummaryDto> dailyList = SalesDao.getInstance().getDailyBranchSummary();
    %>
    <table border="1">
        <tr>
            <th>날짜</th>
            <th>지점ID</th>
            <th>지점명</th>
            <th>매출합계</th>
        </tr>
        <% for(SalesSummaryDto dto : dailyList){ %>
        <tr>
            <td><%= dto.getSalesDate() %></td>
            <td><%= dto.getBranch() %></td>
            <td><%= dto.getBranchName() %></td>
            <td><%= dto.getTotalAmount() %> 원</td>
        </tr>
        <% } %>
    </table>

    <br>
    <button onclick="location.href='${pageContext.request.contextPath}/branch-sales/list.jsp'">← 매출 목록으로</button>
</body>
</html>