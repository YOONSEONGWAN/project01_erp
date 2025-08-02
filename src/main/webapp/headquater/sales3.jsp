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
</head>
<body>
    <h1>매출 통계 통합 페이지</h1>

    <form method="get" action="<%=request.getContextPath()%>/headquater/sales.jsp">
        <label>통계 보기:</label>
        <select name="view">
            <option value="">--선택--</option>

            <optgroup label="총 매출">
                <option value="weekly" <%= "weekly".equals(view) ? "selected" : "" %>>주간 총 매출</option>
                <option value="monthly" <%= "monthly".equals(view) ? "selected" : "" %>>월간 총 매출</option>
                <option value="yearly" <%= "yearly".equals(view) ? "selected" : "" %>>연간 총 매출</option>
            </optgroup>

            <optgroup label="평균 매출">
                <option value="weekly-avg" <%= "weekly-avg".equals(view) ? "selected" : "" %>>주간 평균 매출</option>
                <option value="monthly-avg" <%= "monthly-avg".equals(view) ? "selected" : "" %>>월간 평균 매출</option>
                <option value="daily-avg" <%= "daily-avg".equals(view) ? "selected" : "" %>>일 평균 매출</option>
            </optgroup>

            <optgroup label="최고 매출일">
                <option value="weekly-max" <%= "weekly-max".equals(view) ? "selected" : "" %>>주간 최고 매출일</option>
                <option value="monthly-max" <%= "monthly-max".equals(view) ? "selected" : "" %>>월간 최고 매출일</option>
                <option value="yearly-max" <%= "yearly-max".equals(view) ? "selected" : "" %>>연간 최고 매출일</option>
            </optgroup>

            <optgroup label="최저 매출일">
                <option value="weekly-min" <%= "weekly-min".equals(view) ? "selected" : "" %>>주간 최저 매출일</option>
                <option value="monthly-min" <%= "monthly-min".equals(view) ? "selected" : "" %>>월간 최저 매출일</option>
                <option value="yearly-min" <%= "yearly-min".equals(view) ? "selected" : "" %>>연간 최저 매출일</option>
            </optgroup>

            <optgroup label="매출 순위">
                <option value="weekly-rank" <%= "weekly-rank".equals(view) ? "selected" : "" %>>주간 매출 순위</option>
                <option value="monthly-rank" <%= "monthly-rank".equals(view) ? "selected" : "" %>>월간 매출 순위</option>
                <option value="yearly-rank" <%= "yearly-rank".equals(view) ? "selected" : "" %>>연간 매출 순위</option>
            </optgroup>
        </select>
        <br/>
        시작일: <input type="date" name="start" value="<%=start != null ? start : ""%>">
        종료일: <input type="date" name="end" value="<%=end != null ? end : ""%>">
        <button type="submit">조회</button>
    </form>

    <hr/>

    <%-- 날짜 범위에 따른 요약 통계 --%>
    <% if (dto != null) { %>
        <h3>날짜 범위 매출 통계</h3>
        <ul>
            <li>총 일수: <%=dto.getDayCount()%>일</li>
            <li>총 매출: <%=nf.format(dto.getTotalSales())%>원</li>
            <li>일 평균 매출: <%=nf.format(dto.getAverageSales())%>원</li>
            <li>최고 매출 지점: <%=dto.getTopBranchName()%> (<%=nf.format(dto.getTopBranchSales())%>원)</li>
        </ul>
    <% } %>

    <hr/>

    <%-- 선택한 통계 항목 view에 따라 include --%>
    <% if (view != null && !view.isEmpty()) { 
        String includePath = "/sales/" + view + ".jsp";
    %>
        <jsp:include page="<%=includePath%>" />
    <% } %>

    <%-- ✅ 전체 매출 목록은 항상 보여줌 --%>
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
<meta charset="UTF-8">
<title>/headquater/sales.jsp</title>
<jsp:include page="/WEB-INF/include/resource.jsp"></jsp:include>
</head>
<body>
	<jsp:include page="/WEB-INF/include/hqnavbar.jsp">
		<jsp:param value="sales" name="thisPage"/>
	</jsp:include>
	<h1>매출 통계조회</h1>
	<div class="container">
		<li>
			<a href="${pageContext.request.contextPath }/sales/weekly.jsp">주간 총 매출</a>
		</li>
		
		<li>
			<a href="${pageContext.request.contextPath }/sales/monthly.jsp">월간 총 매출</a>
		</li>
		<li>
		
			<a href="${pageContext.request.contextPath }/sales/annual.jsp">연간 총 매출</a>
		</li>
		
		<br />
		<li>
		
			<a href="${pageContext.request.contextPath }/sales/monthly-avg.jsp">월 평균 매출</a>
		</li>
		<li>
		
			<a href="${pageContext.request.contextPath }/sales/weekly-avg.jsp">주간 평균 매출</a>
		</li>
		<li>
		
			<a href="${pageContext.request.contextPath }/sales/daily-avg.jsp">일 평균 매출</a>
		</li>
		
		<br />
		<li>
		
			<a href="${pageContext.request.contextPath }/sales/weekly-max.jsp">주간 최고 매출일</a>
		</li>
		<li>
		
			<a href="${pageContext.request.contextPath }/sales/monthly-max.jsp">월간 최고 매출일</a>
		</li>						
				
						
		<h1>전체 매출 목록</h1>
		<table border = "1">
			<tr>
				<th>매출 번호</th>
				<th>지점 이름</th>
				<th>매출 날짜</th>
				<th>총 매출 액</th>
			</tr>
			 <tbody>
			 	<%for(SalesDto tmp:list) {%>
			 		<tr>
			 			<td><%=tmp.getSales_id() %></td>
			 			<td><%=tmp.getBranch_id() %></td>
			 			<td><%=tmp.getCreated_at() %></td>
			 			<td><%= nf.format(tmp.getTotalamount()) %></td>
			 		</tr>
			 	<%} %>
			 </tbody>
		</table>
	</div>
</body>
</html>
