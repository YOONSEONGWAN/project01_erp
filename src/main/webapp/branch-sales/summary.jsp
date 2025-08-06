<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="test.dto.BranchSalesSummaryDto" %>
<%@ page import="test.dao.BranchSalesDao" %>
<%
request.setCharacterEncoding("UTF-8");

    // 1. 로그인된 지점 확인
    String branchId = (String)session.getAttribute("branchId");
    if(branchId == null){
        response.sendRedirect(request.getContextPath() + "/userp/branchlogin-form.jsp");
        return;
    }

    // 2. 기간 검색 파라미터
    String startDate = request.getParameter("startDate");
    String endDate = request.getParameter("endDate");

    // 3. DAO 호출
    List<BranchSalesSummaryDto> summaryList;
    if(startDate != null && endDate != null && !startDate.isEmpty() && !endDate.isEmpty()){
        summaryList = BranchSalesDao.getInstance().getDailySummaryByBranchAndPeriod(branchId, startDate, endDate);
    } else {
        summaryList = BranchSalesDao.getInstance().getDailySummaryByBranch(branchId);
    }

    // 4. 총매출 계산
    int totalAmount = 0;
    for(BranchSalesSummaryDto dto : summaryList){
        totalAmount += dto.getTotalAmount();
    }

    String cpath = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/branch-sales/summary.jsp</title>
<jsp:include page="/WEB-INF/include/resource.jsp"/>
</head>
<body>
<div class="container mt-3">

    <h2>일자별 매출 요약</h2>

    <!-- 5. 기간 검색 폼 -->
    <form method="get" class="row g-2 mb-3">
        <div class="col-auto">
            <input type="date" name="startDate" class="form-control" value="<%=startDate != null ? startDate : ""%>">
        </div>
        <div class="col-auto">
            <input type="date" name="endDate" class="form-control" value="<%=endDate != null ? endDate : ""%>">
        </div>
        <div class="col-auto">
            <button type="submit" class="btn btn-outline-primary">조회</button>
            <a href="<%=cpath%>/branch-sales/summary.jsp" class="btn btn-outline-secondary">전체보기</a>
        </div>
    </form>

    <!-- 6. 총매출 표시 -->
    <div class="alert alert-info">
        총 매출: <strong><%=totalAmount%></strong> 원
    </div>

    <!-- 7. 일자별 매출 요약 테이블 -->
    <table class="table table-bordered table-hover mt-3">
        <thead class="table-light">
            <tr>
                <th>일자</th>
                <th>총 매출</th>
            </tr>
        </thead>
        <tbody>
        <%
        for(BranchSalesSummaryDto dto : summaryList){
        %>
            <tr>
                <td><%=dto.getSalesDate()%></td>
                <td><%=dto.getTotalAmount()%></td>
            </tr>
        <%
            }
        %>
        </tbody>
    </table>

</div>
</body>
</html>