<%@page import="java.text.NumberFormat"%>
<%@page import="dao.SalesDao"%>
<%@page import="dto.SalesDto"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    request.setCharacterEncoding("utf-8");

    String start = request.getParameter("start");
    String end   = request.getParameter("end");
    String view  = request.getParameter("view");

    SalesDto dto = null;
    if (start != null && end != null && !start.isEmpty() && !end.isEmpty()) {
        dto = SalesDao.getInstance().getStatsBetweenDates(start, end);
    }

    NumberFormat nf = NumberFormat.getInstance();

    // 페이징 처리
    int pageNum  = 1;
    int pageSize = 10;

    if (request.getParameter("pageNum") != null) {
        pageNum = Integer.parseInt(request.getParameter("pageNum"));
    }

    int startRow = 1 + (pageNum - 1) * pageSize;
    int endRow   = pageNum * pageSize;

    int totalRow  = SalesDao.getInstance().getTotalCount();
    int totalPage = (int) Math.ceil(totalRow / (double) pageSize);

    List<SalesDto> list = SalesDao.getInstance().selectPage(startRow, endRow);
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>매출 통계 통합 페이지</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        .btn-primary {
            background-color: #003366 !important;
            border-color: #003366 !important;
            color: #fff !important;
            font-weight: 500;
            border-radius: 6px;
            box-shadow: 0 2px 6px rgba(0, 0, 0, .1);
        }
        .btn-primary:hover {
            background-color: #002244 !important;
            border-color: #002244 !important;
            color: #fff !important;
        }
    </style>
</head>
<body>
<div class="container-fluid">
    <nav aria-label="breadcrumb">
        <ol class="breadcrumb">
            <li class="breadcrumb-item">
                <a href="<%=request.getContextPath()%>/headquater.jsp?page=index/headquaterindex.jsp">Home</a>
            </li>
            <li class="breadcrumb-item">
                <a href="<%=request.getContextPath()%>/headquater.jsp?page=headquater/slaes.jsp">매출 관리</a>
            </li>
            <li class="breadcrumb-item active" aria-current="page">매출 목록</li>
        </ol>
    </nav>

    <div class="row">
        <main class="col-md-12 px-4">
            <div class="container-fluid">
                <h1 class="fw-bold">지점별 매출 분석 대시보드</h1>
            </div>

            <form class="row g-3 align-items-end mb-4" method="get"
                  action="<%=request.getContextPath()%>/headquater.jsp">
                <input type="hidden" name="page" value="headquater/sales.jsp"/>

                <div class="col-md-4">
                    <label class="form-label">통계 보기</label>
                    <select name="view" class="form-select stat-select">
                        <option value="">통계 항목 선택</option>

                        <optgroup label="총 매출">
                            <option value="weekly"  <%= "weekly".equals(view)  ? "selected" : "" %>>주간 총 매출</option>
                            <option value="monthly" <%= "monthly".equals(view) ? "selected" : "" %>>월간 총 매출</option>
                            <option value="yearly"  <%= "yearly".equals(view)  ? "selected" : "" %>>연간 총 매출</option>
                        </optgroup>

                        <optgroup label="평균 매출">
                            <option value="weekly-avg"  <%= "weekly-avg".equals(view)  ? "selected" : "" %>>주간 평균 매출</option>
                            <option value="monthly-avg" <%= "monthly-avg".equals(view) ? "selected" : "" %>>월간 평균 매출</option>
                            <option value="daily-avg"   <%= "daily-avg".equals(view)   ? "selected" : "" %>>일 평균 매출</option>
                        </optgroup>

                        <optgroup label="최고 매출일">
                            <option value="weekly-max"  <%= "weekly-max".equals(view)  ? "selected" : "" %>>주간 최고 매출일</option>
                            <option value="monthly-max" <%= "monthly-max".equals(view) ? "selected" : "" %>>월간 최고 매출일</option>
                            <option value="yearly-max"  <%= "yearly-max".equals(view)  ? "selected" : "" %>>연간 최고 매출일</option>
                        </optgroup>

                        <optgroup label="최저 매출일">
                            <option value="weekly-min"  <%= "weekly-min".equals(view)  ? "selected" : "" %>>주간 최저 매출일</option>
                            <option value="monthly-min" <%= "monthly-min".equals(view) ? "selected" : "" %>>월간 최저 매출일</option>
                            <option value="yearly-min"  <%= "yearly-min".equals(view)  ? "selected" : "" %>>연간 최저 매출일</option>
                        </optgroup>

                        <optgroup label="매출 순위">
                            <option value="weekly-rank"  <%= "weekly-rank".equals(view)  ? "selected" : "" %>>주간 매출 순위</option>
                            <option value="monthly-rank" <%= "monthly-rank".equals(view) ? "selected" : "" %>>월간 매출 순위</option>
                            <option value="yearly-rank"  <%= "yearly-rank".equals(view)  ? "selected" : "" %>>연간 매출 순위</option>
                        </optgroup>
                    </select>
                </div>

                <div class="col-md-3">
                    <label class="form-label">시작일</label>
                    <input type="date" name="start" value="<%= start != null ? start : "" %>" class="form-control">
                </div>

                <div class="col-md-3">
                    <label class="form-label">종료일</label>
                    <input type="date" name="end" value="<%= end != null ? end : "" %>" class="form-control">
                </div>

                <div class="col-md-2">
                    <button type="submit" class="btn btn-primary w-100 mt-2">조회</button>
                    <a href="<%=request.getContextPath()%>/headquater.jsp?page=headquater/sales.jsp"
                       class="btn btn-primary w-100 mt-2">초기화</a>
                </div>
            </form>

            <% if (dto != null) { %>
                <div class="alert alert-light border">
                    <strong>조회 범위:</strong> <%= start %> ~ <%= end %><br/>
                    <strong>총 일수:</strong> <%= dto.getDayCount() %>일 /
                    <strong>총 매출:</strong> <%= nf.format(dto.getTotalSales()) %>원
                </div>
            <% } %>

            <%
                if (view != null && !view.isEmpty()) {
                    String includePath = "/headquater-sales/" + view + ".jsp";
            %>
                <jsp:include page="<%= includePath %>">
                    <jsp:param name="start"   value="<%= start %>"   />
                    <jsp:param name="end"     value="<%= end %>"     />
                    <jsp:param name="pageNum" value="<%= pageNum %>" />
                </jsp:include>
            <% } %>

            <% if (view == null || view.isEmpty()) { %>
                <h4 class="mt-5">전체 매출 목록</h4>
                <div class="table-responsive">
                    <table class="table table-hover align-middle">
                        <thead class="table-secondary">
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
                                    <td><%= tmp.getSales_id() %></td>
                                    <td><%= tmp.getBranch_name() %></td>
                                    <td><%= tmp.getCreated_at() %></td>
                                    <td><%= nf.format(tmp.getTotalamount()) %> 원</td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            <% } else if (dto == null) { %>
            <% } %>
        </main>
    </div>

    <% if (view == null || view.isEmpty()) { %>
        <nav aria-label="Page navigation">
            <ul class="pagination justify-content-center">
                <% if (pageNum > 1) { %>
                    <li class="page-item">
                        <a class="page-link" href="?page=headquater/sales.jsp&pageNum=<%= pageNum - 1 %>">이전</a>
                    </li>
                <% } else { %>
                    <li class="page-item disabled"><span class="page-link">이전</span></li>
                <% } %>

                <%
                    int blockSize = 5;
                    int startPage = ((pageNum - 1) / blockSize) * blockSize + 1;
                    int endPage   = Math.min(startPage + blockSize - 1, totalPage);

                    for (int i = startPage; i <= endPage; i++) {
                %>
                    <li class="page-item <%= (i == pageNum) ? "active" : "" %>">
                        <a class="page-link" href="?page=headquater/sales.jsp&pageNum=<%= i %>"><%= i %></a>
                    </li>
                <% } %>

                <% if (pageNum < totalPage) { %>
                    <li class="page-item">
                        <a class="page-link" href="?page=headquater/sales.jsp&pageNum=<%= pageNum + 1 %>">다음</a>
                    </li>
                <% } else { %>
                    <li class="page-item disabled"><span class="page-link">다음</span></li>
                <% } %>
            </ul>
        </nav>
    <% } %>
</div>
</body>
</html>
