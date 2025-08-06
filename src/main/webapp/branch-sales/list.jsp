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

    // 3. 현재 페이지 번호 처리
    int pageNum = 1;
    String strPageNum = request.getParameter("pageNum");
    if(strPageNum != null){
        pageNum = Integer.parseInt(strPageNum);
    }

    // 4. 페이지네이션 설정
    final int PAGE_ROW_COUNT = 10;      // 한 페이지 10개
    final int PAGE_DISPLAY_COUNT = 5;   // 하단에 5개 번호 표시

    int startRowNum = 1 + (pageNum-1)*PAGE_ROW_COUNT;
    int endRowNum   = pageNum*PAGE_ROW_COUNT;
    int startPageNum = 1 + ((pageNum-1)/PAGE_DISPLAY_COUNT)*PAGE_DISPLAY_COUNT;
    int endPageNum   = startPageNum + PAGE_DISPLAY_COUNT - 1;

    // 5. DAO 호출 (조건에 따라 전체 목록 가져옴)
    List<BranchSalesDto> allList;
    if(startDate != null && endDate != null && !startDate.isEmpty() && !endDate.isEmpty()){
        allList = BranchSalesDao.getInstance().getListByPeriod(branchId, startDate, endDate);
    } else {
        allList = BranchSalesDao.getInstance().getList(branchId);
    }

    // 6. 총 데이터 갯수 & 전체 페이지 계산
    int totalRow = allList.size();
    int totalPageCount = (int)Math.ceil(totalRow/(double)PAGE_ROW_COUNT);
    if(endPageNum > totalPageCount) endPageNum = totalPageCount;

    // 7. 현재 페이지에 해당하는 subList 추출
    int fromIndex = Math.min(startRowNum-1, totalRow);
    int toIndex   = Math.min(endRowNum, totalRow);
    List<BranchSalesDto> salesList = allList.subList(fromIndex, toIndex);

    // 8. 총매출 계산 (현재 페이지 기준)
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
<jsp:include page="/WEB-INF/include/resource.jsp"/>
</head>
<body>
<div class="container mt-3">

    <h2>매출 목록</h2>

    <!-- 기간 검색 폼 -->
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

    <!-- 총매출 표시 -->
    <div class="alert alert-info">
        현재 페이지 총 매출: <strong><%=totalAmount%></strong> 원
    </div>

    <!-- 매출 목록 테이블 -->
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
        <% for(BranchSalesDto dto : salesList){ %>
            <tr>
                <td><%=dto.getSalesId()%></td>
                <td><%=dto.getBranchId()%></td>
                <td><%=dto.getCreated_at()%></td>
                <td><%=dto.getTotalAmount()%></td>
                <td>
                    <a href="<%=cpath%>/branch-sales/detail.jsp?salesId=<%=dto.getSalesId()%>" 
                       class="btn btn-sm btn-outline-secondary">보기</a>
                </td>
            </tr>
        <% } %>
        </tbody>
    </table>

    <!-- 페이지네이션 -->
    <ul class="pagination justify-content-center">
        <% if(startPageNum != 1) { %>
            <li class="page-item">
                <a class="page-link" 
                   href="<%=cpath%>/branch-sales/list.jsp?pageNum=<%=startPageNum-1%>&startDate=<%=startDate != null ? startDate : ""%>&endDate=<%=endDate != null ? endDate : ""%>">&lsaquo;</a>
            </li>
        <% } %>

        <% for(int i=startPageNum; i<=endPageNum; i++){ %>
            <li class="page-item <%=i==pageNum ? "active" : "" %>">
                <a class="page-link" 
                   href="<%=cpath%>/branch-sales/list.jsp?pageNum=<%=i%>&startDate=<%=startDate != null ? startDate : ""%>&endDate=<%=endDate != null ? endDate : ""%>"><%=i%></a>
            </li>
        <% } %>

        <% if(endPageNum < totalPageCount) { %>
            <li class="page-item">
                <a class="page-link" 
                   href="<%=cpath%>/branch-sales/list.jsp?pageNum=<%=endPageNum+1%>&startDate=<%=startDate != null ? startDate : ""%>&endDate=<%=endDate != null ? endDate : ""%>">&rsaquo;</a>
            </li>
        <% } %>
    </ul>

</div>
</body>
</html>