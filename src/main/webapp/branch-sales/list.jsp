<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="test.dto.BranchSalesDto" %>
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
    List<BranchSalesDto> salesList;
    if(startDate != null && endDate != null && !startDate.isEmpty() && !endDate.isEmpty()){
        salesList = BranchSalesDao.getInstance().getListByPeriod(branchId, startDate, endDate);
    } else {
        salesList = BranchSalesDao.getInstance().getList(branchId);
    }

    // 4. 총매출 계산
    int totalAmount = 0;
    for(BranchSalesDto dto : salesList){
        totalAmount += dto.getTotalAmount();
    }

    String cpath = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/branch-sales/list.jsp</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-3">

    <h2>매출 목록</h2>

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
            <a href="<%=cpath%>/branch-sales/list.jsp" class="btn btn-outline-secondary">전체보기</a>
            <a href="<%=cpath%>/branch-sales/insert-form.jsp" class="btn btn-primary">매출 등록</a>
        </div>
    </form>

    <!-- 6. 총매출 표시 -->
    <div class="alert alert-info">
        총 매출: <strong><%=totalAmount%></strong> 원
    </div>

    <!-- 7. 매출 목록 테이블 -->
    <table class="table table-bordered table-hover">
        <thead class="table-light">
            <tr>
                <th>매출번호</th>
                <th>지점</th>
                <th>날짜</th>
                <th>총금액</th>
                <th>상세보기</th>
            </tr>
        </thead>
        <tbody>
        <%
        for(BranchSalesDto dto : salesList){
        %>
            <tr>
                <td><%=dto.getSalesId()%></td>
                <td><%=dto.getBranchId()%></td>
                <td><%=dto.getCreated_at()%></td>
                <td><%=dto.getTotalAmount()%></td>
                <td>
                    <a href="<%=cpath%>/branch-sales/detail.jsp?salesId=<%=dto.getSalesId()%>" class="btn btn-sm btn-outline-secondary">보기</a>
                </td>
            </tr>
        <%
            }
        %>
        </tbody>
    </table>

</div>
</body>
</html>