<%@page import="test.dao.SalesDao"%>
<%@page import="test.dto.SalesSummaryDto"%>
<%@page import="java.util.List"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    request.setCharacterEncoding("UTF-8");

    String branchId = (String)session.getAttribute("branchId");
    if(branchId == null){
        response.sendRedirect(request.getContextPath()+"/userp/branchlogin-form.jsp");
        return;
    }

    List<SalesSummaryDto> myDailyList = SalesDao.getInstance().getDailySummaryByBranch(branchId);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>/branch-sales/summary.jsp</title>
</head>
<body>
    <h2>내 지점(<%= branchId %>) 일자별 매출 요약</h2>
    <table border="1">
        <tr>
            <th>날짜</th>
            <th>매출합계</th>
        </tr>
        <% for(SalesSummaryDto dto : myDailyList){ %>
        <tr>
            <td><%= dto.getSalesDate() %></td>
            <td><%= dto.getTotalAmount() %> 원</td>
        </tr>
        <% } %>
    </table>

    <br>
    <button onclick="location.href='<%= request.getContextPath() %>/branch-sales/list.jsp'">← 매출 목록으로</button>
</body>
</html>