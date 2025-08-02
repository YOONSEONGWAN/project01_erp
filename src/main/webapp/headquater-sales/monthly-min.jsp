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
        list = SalesDao.getInstance().getMonthlyMinSalesDatesBetween(start, end);
    } else {
        list = SalesDao.getInstance().getMonthlyMinSalesDates();
    }

    NumberFormat nf = NumberFormat.getInstance();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>/sales/monthly.jsp</title>
</head>
<body>
    <h1>지점별 월간 최저 매출일</h1>

    <!-- 날짜 필터 
    <form method="get" action="<%=request.getContextPath()%>/sales/yearly-max.jsp">
        시작일: <input type="date" name="start" value="<%=start != null ? start : "" %>">
        종료일: <input type="date" name="end" value="<%=end != null ? end : "" %>">
        <button type="submit">조회</button>
    </form>
    -->

    <br />

    <table border="1">
        <thead>
            <tr>
                <th>번호</th>
                <th>월차</th>
                <th>지점</th>
                <th>최저 매출일</th>
                <th>매출액</th>
            </tr>
        </thead>
        <tbody>
            <%
                int index = 1;
                for (SalesDto dto : list) {
            %>
                <tr>
                    <td><%= index++ %></td>
                    <td><%= dto.getPeriod() %></td>
                    <td><%= dto.getBranch_name() %></td>
                    <td><%= dto.getMinSalesDate() %></td>
                    <td><%= nf.format(dto.getTotalSales()) %> 원</td>
                </tr>
            <% } %>
        </tbody>
    </table>
</body>
</html>
