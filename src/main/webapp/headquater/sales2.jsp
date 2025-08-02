<%@page import="java.text.NumberFormat"%>
<%@page import="dao.SalesDao"%>
<%@page import="dto.SalesDto"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    request.setCharacterEncoding("utf-8");

    String start = request.getParameter("start");
    String end = request.getParameter("end");
    String view = request.getParameter("view");

    SalesDto dto = null;
    if (start != null && end != null && !start.isEmpty() && !end.isEmpty()) {
        dto = SalesDao.getInstance().getStatsBetweenDates(start, end);
    }

    List<SalesDto> list = SalesDao.getInstance().selectAll();
    NumberFormat nf = NumberFormat.getInstance();
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>매출 통계 통합 페이지</title>
    <jsp:include page="/WEB-INF/include/resource.jsp"></jsp:include>
</head>
<body>
	<jsp:include page="/WEB-INF/include/resource.jsp">
		<jsp:param value="sa" name=""/>
	</jsp:include>
    <h1>매출 통계 통합 페이지</h1>

    <form method="get" action="<%=request.getContextPath()%>/headquater/sales.jsp">
        <label>통계 보기:</label>
        <select name="view">
            <option value="">--선택--</option>

            <optgroup label="총 매출">
                <option value="weekly">주간 총 매출</option>
                <option value="monthly">월간 총 매출</option>
                <option value="yearly">연간 총 매출</option>
            </optgroup>

            <optgroup label="평균 매출">
                <option value="weekly-avg">주간 평균 매출</option>
                <option value="monthly-avg">월간 평균 매출</option>
                <option value="daily-avg">일 평균 매출</option>
            </optgroup>

            <optgroup label="최고 매출일">
                <option value="weekly-max">주간 최고 매출일</option>
                <option value="monthly-max">월간 최고 매출일</option>
                <option value="yearly-max">연간 최고 매출일</option>
            </optgroup>

            <optgroup label="최저 매출일">
                <option value="weekly-min">주간 최저 매출일</option>
                <option value="monthly-min">월간 최저 매출일</option>
                <option value="yearly-min">연간 최저 매출일</option>
            </optgroup>

            <optgroup label="매출 순위">
                <option value="weekly-rank">주간 매출 순위</option>
                <option value="monthly-rank">월간 매출 순위</option>
                <option value="yearly-rank">연간 매출 순위</option>
            </optgroup>
        </select>
        <button type="submit">보기</button>
    </form>

    <hr />

    <h2>날짜 범위 매출 통계</h2>
    <form method="get" action="<%=request.getContextPath()%>/headquater/sales.jsp">
        시작일: <input type="date" name="start" value="<%=start != null ? start : ""%>">
        종료일: <input type="date" name="end" value="<%=end != null ? end : ""%>">
        <input type="hidden" name="view" value="<%=view != null ? view : ""%>">
        <button type="submit">조회</button>
    </form>

    <% if (dto != null) { %>
        <ul>
            <li>총 일수: <%=dto.getDayCount()%>일</li>
            <li>총 매출: <%=nf.format(dto.getTotalSales())%>원</li>
            <li>일 평균 매출: <%=nf.format(dto.getAverageSales())%>원</li>
            <li>🏆 최고 매출 지점: <%=dto.getTopBranchName()%> (<%=nf.format(dto.getTopBranchSales())%>원)</li>
        </ul>
    <% } %>

    <hr />

    <% if (view != null && !view.isEmpty()) { 
        String includePath = "/sales/" + view + ".jsp";
    %>
        <jsp:include page="<%=includePath%>" />
    <% } else { %>

        <h2>전체 매출 목록</h2>
        <table border="1" cellpadding="5">
            <tr>
                <th>매출 번호</th>
                <th>지점 이름</th>
                <th>매출 날짜</th>
                <th>총 매출액</th>
            </tr>
            <% for (SalesDto tmp : list) { %>
                <tr>
                    <td><%=tmp.getSales_id()%></td>
                    <td><%=tmp.getBranch_name()%></td>
                    <td><%=tmp.getCreated_at()%></td>
                    <td><%=nf.format(tmp.getTotalamount())%>원</td>
                </tr>
            <% } %>
        </table>
    <% } %>
</body>
</html>
