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

    boolean hasQuery =
        (view != null && !view.isEmpty()) ||
        (start != null && !start.isEmpty()) ||
        (end != null && !end.isEmpty());
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>매출 통계 통합 페이지</title>
    <!-- ✅ Bootstrap CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <jsp:include page="/WEB-INF/include/resource.jsp" />
</head>
<body>

<div class="container-fluid">
    <div class="row">
        <!-- ✅ 본문 시작 -->
        <main class="col-12 col-md-10 offset-md-1 mt-4">

            <!-- ✅ 제목 영역 -->
            <div class="text-center mb-4">
                <h1 class="fw-bold">지점별 매출 분석 대시보드</h1>
            </div>

            <!-- ✅ 통계 필터 폼 -->
            <form class="row g-3 align-items-end mb-4" method="get" action="<%=request.getContextPath()%>/headquater/sales.jsp">
                <div class="col-md-4">
                    <label class="form-label">통계 보기</label>
                    <select name="view" class="form-select">
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
                    <input type="date" name="start" value="<%=start != null ? start : ""%>" class="form-control">
                </div>
                <div class="col-md-3">
                    <label class="form-label">종료일</label>
                    <input type="date" name="end" value="<%=end != null ? end : ""%>" class="form-control">
                </div>
                <div class="col-md-2">
                    <button type="submit" class="btn btn-outline-secondary w-100 mt-2">조회</button>
                    <a href="<%=request.getContextPath()%>/headquater/sales.jsp" class="btn btn-outline-secondary w-100 mt-2">초기화</a>
                </div>
            </form>

            <!-- ✅ 통계 요약 정보 -->
            <% if (dto != null) { %>
                <div class="alert alert-light border">
                    <strong>조회 범위:</strong> <%=start%> ~ <%=end%><br/>
                    <strong>총 일수:</strong> <%=dto.getDayCount()%>일 /
                    <strong>총 매출:</strong> <%=nf.format(dto.getTotalSales())%>원
                </div>
            <% } %>

            <!-- ✅ 통계 include -->
            <% if (view != null && !view.isEmpty()) {
                String includePath = "/headquater-sales/" + view + ".jsp";
            %>
                <jsp:include page="<%=includePath%>" />
            <% } %>

            <!-- ✅ 전체 매출 목록 -->
            <% if (!hasQuery) { %>
                <h4 class="mt-5">전체 매출 목록</h4>
                <div class="table-responsive">
                    <table class="table table-bordered table-striped">
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
                                    <td><%=nf.format(tmp.getTotalamount())%> 원</td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            <% } else if (dto == null && (view == null || view.isEmpty())) { %>
                <p class="text-muted">해당 기간에 매출 데이터가 없습니다.</p>
            <% } %>
        </main>
    </div>
</div>

</body>
</html>
