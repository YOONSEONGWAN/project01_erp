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
        list = SalesDao.getInstance().getMonthlyAvgStatsBetween(start, end);
    } else {
        list = SalesDao.getInstance().getMonthlyAvgStats();
    }

    NumberFormat nf = NumberFormat.getInstance();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>/sales/monthly-avg.jsp</title>
</head>
<body>
    <h1>월 평균 매출 통계</h1>

    <!-- 날짜 필터 -->
    <form method="get" action="<%=request.getContextPath()%>/sales/monthly-avg.jsp">
        시작일: <input type="date" name="start" value="<%=start != null ? start : ""%>">
        종료일: <input type="date" name="end" value="<%=end != null ? end : ""%>">
        <button type="submit">조회</button>
    </form>

    <br />

    <table border="1">
        <thead>
            <tr>
                <th>번호</th>
                <th>기간</th>
                <th>지점</th>
                <th>총 매출</th>
                <th>평균 매출</th>
            </tr>
        </thead>
        <tbody>
            <%
                int index = 1;
                for(SalesDto dto : list) {
            %>
                <tr>
                    <td><%= index++ %></td>
                    <td><%= dto.getPeriod() %></td>
                    <td><%= dto.getBranch_name() %></td>
                    <td><%= nf.format(dto.getTotalSales()) %> 원</td>
                    <td><%= nf.format(dto.getAverageSales()) %> 원</td>
                </tr>
            <% } %>
        </tbody>
    </table>
</body>
</html>
