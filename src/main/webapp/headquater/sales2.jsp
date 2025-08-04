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
    <jsp:include page="/WEB-INF/include/resource.jsp" />
</head>
<body>
<jsp:include page="/WEB-INF/include/hqnavbar.jsp">
    <jsp:param name="thisPage" value="sales"/>
</jsp:include>

<div class="container pt-4">
    <h1 class="mb-4">매출 통계 통합 페이지</h1>

    <!-- 필터 폼 -->
    <form class="row g-3 align-items-end mb-4" method="get" action="<%=request.getContextPath()%>/headquater/sales2.jsp">
        <div class="col-md-3">
            <label class="form-label">통계 보기</label>
            <select class="form-select" name="view">
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
        </div>

        <div class="col-md-3">
            <label class="form-label">시작일</label>
            <input type="date" name="start" class="form-control" value="<%=start != null ? start : ""%>">
        </div>

        <div class="col-md-3">
            <label class="form-label">종료일</label>
            <input type="date" name="end" class="form-control" value="<%=end != null ? end : ""%>">
        </div>

        <div class="col-md-3">
            <button type="submit" class="btn btn-primary w-100">조회</button>
        </div>
    </form>

    <!-- 요약 통계 -->
    <% if (dto != null) { %>
    <div class="card mb-4">
        <div class="card-body">
            <h5 class="card-title">날짜 범위 매출 통계</h5>
            <ul class="list-group list-group-flush">
                <li class="list-group-item">총 일수: <%=dto.getDayCount()%>일</li>
                <li class="list-group-item">총 매출: <%=nf.format(dto.getTotalSales())%>원</li>
                <li class="list-group-item">일 평균 매출: <%=nf.format(dto.getAverageSales())%>원</li>
                <li class="list-group-item">최고 매출 지점: <%=dto.getTopBranchName()%> (<%=nf.format(dto.getTopBranchSales())%>원)</li>
            </ul>
        </div>
    </div>
    <% } %>

    <!-- 선택한 통계 항목 include -->
    <% if (view != null && !view.isEmpty()) { 
        String includePath = "/headquater-sales/" + view + ".jsp";
    %>
        <jsp:include page="<%=includePath%>" />
    <% } %>

    <!-- 전체 매출 목록 -->
    <h3 class="mt-5">전체 매출 목록</h3>
    <div class="table-responsive">
        <table class="table table-striped table-bordered text-center">
            <thead class="table-light">
                <tr>
                    <th>매출 번호</th>
                    <th>지점 이름</th>
                    <th>매출 날짜</th>
                    <th>총 매출액</th>
                </tr>
            </thead>
            <tbody>
                <% for (SalesDto tmp : list) { %>
                <tr>
                    <td><%=tmp.getSales_id()%></td>
                    <td><%=tmp.getBranch_name()%></td>
                    <td><%=tmp.getCreated_at()%></td>
                    <td><%=nf.format(tmp.getTotalamount())%>원</td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>
</body>
</html>
