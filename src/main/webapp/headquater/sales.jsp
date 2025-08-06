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
	String view = request.getParameter("view");
	
	SalesDto dto = null;
	if (start != null && end != null && !start.isEmpty() && !end.isEmpty()) {
	    dto = SalesDao.getInstance().getStatsBetweenDates(start, end);
	}
	
	List<SalesDto> list = null;
	if (view == null || view.isEmpty()) {
	    list = SalesDao.getInstance().selectAll();
	}
	
	NumberFormat nf = NumberFormat.getInstance();
	boolean hasViewQuery = (view != null && !view.isEmpty());
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>매출 통계 통합 페이지</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
	rel="stylesheet">
<jsp:include page="/WEB-INF/include/resource.jsp" />
</head>
<body>

	<div class="container-fluid">
		<div class="row">
			<main class="col-12 col-md-10 offset-md-1 mt-4">

				<div class="text-center mb-4">
					<h1 class="fw-bold">지점별 매출 분석 대시보드</h1>
				</div>

				<form class="row g-3 align-items-end mb-4" method="get"
					action="<%=request.getContextPath()%>/headquater.jsp">
					<input type="hidden" name="page" value="headquater/sales.jsp" />

					<div class="col-md-4">
						<label class="form-label">통계 보기</label> <select name="view"
							class="form-select">
							<option value="">통계 항목 선택</option>
							<optgroup label="총 매출">
								<option value="weekly"
									<%= "weekly".equals(view) ? "selected" : "" %>>주간 총 매출</option>
								<option value="monthly"
									<%= "monthly".equals(view) ? "selected" : "" %>>월간 총
									매출</option>
								<option value="yearly"
									<%= "yearly".equals(view) ? "selected" : "" %>>연간 총 매출</option>
							</optgroup>
							<optgroup label="평균 매출">
								<option value="weekly-avg"
									<%= "weekly-avg".equals(view) ? "selected" : "" %>>주간
									평균 매출</option>
								<option value="monthly-avg"
									<%= "monthly-avg".equals(view) ? "selected" : "" %>>월간
									평균 매출</option>
								<option value="daily-avg"
									<%= "daily-avg".equals(view) ? "selected" : "" %>>일 평균
									매출</option>
							</optgroup>
							<optgroup label="최고 매출일">
								<option value="weekly-max"
									<%= "weekly-max".equals(view) ? "selected" : "" %>>주간
									최고 매출일</option>
								<option value="monthly-max"
									<%= "monthly-max".equals(view) ? "selected" : "" %>>월간
									최고 매출일</option>
								<option value="yearly-max"
									<%= "yearly-max".equals(view) ? "selected" : "" %>>연간
									최고 매출일</option>
							</optgroup>
							<optgroup label="최저 매출일">
								<option value="weekly-min"
									<%= "weekly-min".equals(view) ? "selected" : "" %>>주간
									최저 매출일</option>
								<option value="monthly-min"
									<%= "monthly-min".equals(view) ? "selected" : "" %>>월간
									최저 매출일</option>
								<option value="yearly-min"
									<%= "yearly-min".equals(view) ? "selected" : "" %>>연간
									최저 매출일</option>
							</optgroup>
							<optgroup label="매출 순위">
								<option value="weekly-rank"
									<%= "weekly-rank".equals(view) ? "selected" : "" %>>주간
									매출 순위</option>
								<option value="monthly-rank"
									<%= "monthly-rank".equals(view) ? "selected" : "" %>>월간
									매출 순위</option>
								<option value="yearly-rank"
									<%= "yearly-rank".equals(view) ? "selected" : "" %>>연간
									매출 순위</option>
							</optgroup>
						</select>
					</div>
					<div class="col-md-3">
						<label class="form-label">시작일</label> <input type="date"
							name="start" value="<%=start != null ? start : ""%>"
							class="form-control">
					</div>
					<div class="col-md-3">
						<label class="form-label">종료일</label> <input type="date"
							name="end" value="<%=end != null ? end : ""%>"
							class="form-control">
					</div>
					<div class="col-md-2">
						<button type="submit" class="btn btn-outline-secondary w-100 mt-2">조회</button>
						<a
							href="<%=request.getContextPath()%>/headquater.jsp?page=headquater/sales.jsp"
							class="btn btn-outline-secondary w-100 mt-2">초기화</a>
					</div>
				</form>

				<% if (dto != null) { %>
				<div class="alert alert-light border">
					<strong>조회 범위:</strong>
					<%=start%>
					~
					<%=end%><br /> <strong>총 일수:</strong>
					<%=dto.getDayCount()%>일 / <strong>총 매출:</strong>
					<%=nf.format(dto.getTotalSales())%>원
				</div>
				<% } %>

				<% if (hasViewQuery) {
                String includePath = "/headquater-sales/" + view + ".jsp";
            %>
				<jsp:include page="<%=includePath%>" />
				<% } %>

				<% if (!hasViewQuery) { %>
				<h2 class="mb-4">매출 목록</h2>
				<div class="table-responsive">
					<table class="table table-bordered">
						<thead class="table-light">
							<tr>
								<th>매출 번호</th>
								<th>지점 이름</th>
								<th>매출 날짜</th>
								<th>총 매출액</th>
							</tr>
						</thead>
						<tbody>
							<% if (list != null) {
                                for (SalesDto tmp : list) { %>
							<tr>
								<td><%=tmp.getSales_id()%></td>
								<td><%=tmp.getBranch_name()%></td>
								<td><%=tmp.getCreated_at()%></td>
								<td><%=nf.format(tmp.getTotalamount())%> 원</td>
							</tr>
							<% }
                               } %>
						</tbody>
					</table>
				</div>

				<%-- 데이터가 비어있을 때 메시지 출력 --%>
				<% if (list != null && list.isEmpty()) { %>
				<p class="text-muted mt-5">해당 조건에 맞는 매출 데이터가 없습니다.</p>
				<% } %>
				<% } %>

			</main>
		</div>
	</div>

</body>
</html>
