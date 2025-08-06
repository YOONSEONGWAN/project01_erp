<%@page import="java.text.NumberFormat"%>
<%@page import="dao.SalesDao"%>
<%@page import="dto.SalesDto"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    request.setCharacterEncoding("utf-8");

    String start = request.getParameter("start");
    String end = request.getParameter("end");

    List<SalesDto> list;
    if (start != null && end != null && !start.isEmpty() && !end.isEmpty()) {
        list = SalesDao.getInstance().getYearlySalesRankingBetween(start, end);
    } else {
        list = SalesDao.getInstance().getYearlySalesRanking();
    }

    NumberFormat nf = NumberFormat.getInstance();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>/sales/Yearly-rank.jsp</title>
</head>
<body class="container-fluid px-0">
    <h2 class="mb-4">지점별 연간 매출 순위</h2>
    <table class="table table-bordered">
        <thead class="table-light">
            <tr>
                <th>순위</th>
                <th>연도</th>
                <th>지점명</th>
                <th>총 매출액</th>
            </tr>
        </thead>
        <tbody>
            <%
                for (SalesDto dto : list) {
            %>
            <tr>
                <td><%=dto.getRank()%></td>
                <td><%=dto.getPeriod()%></td>
                <td><%=dto.getBranch_name()%></td>
                <td><%=nf.format(dto.getTotalSales())%> 원</td>
            </tr>
            <% } %>
        </tbody>
    </table>
</body>
</html>
