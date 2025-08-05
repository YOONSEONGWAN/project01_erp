<%@page import="test.dao.BranchSalesDao"%>
<%@page import="test.dto.BranchSalesSummaryDto"%>
<%@page import="java.util.List"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    request.setCharacterEncoding("UTF-8");

    // 로그인 지점 확인
    String branchId = (String)session.getAttribute("branchId");
    if(branchId == null){
        response.sendRedirect(request.getContextPath()+"/userp/branchlogin-form.jsp");
        return;
    }

    // 조회 기간
    String startDate = request.getParameter("startDate");
    String endDate = request.getParameter("endDate");

    // DAO 호출
    List<BranchSalesSummaryDto> myDailyList =
        BranchSalesDao.getInstance().getDailySalesByBranch(branchId, startDate, endDate);

    // 선택 기간 총합계 계산
    int totalSum = 0;
    for(BranchSalesSummaryDto dto : myDailyList){
        totalSum += dto.getTotalAmount();
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>/branch-sales/summary.jsp</title>
</head>
<body>
    <h2>내 지점(<%=branchId%>) 일자별 매출 요약</h2>

    <!-- 기간 조회 폼 -->
    <form method="get" action="summary.jsp" style="margin-bottom:10px;">
        시작일: <input type="date" name="startDate" value="<%= startDate==null?"":startDate %>">
        종료일: <input type="date" name="endDate" value="<%= endDate==null?"":endDate %>">
        <button type="submit">조회</button>
        <button type="button" onclick="location.href='summary.jsp'">초기화</button>
    </form>

    <table border="1">
        <tr>
            <th>날짜</th>
            <th>매출합계</th>
        </tr>
        <%
        if(myDailyList.isEmpty()){
        %>
        <tr>
            <td colspan="2">조회된 매출 데이터가 없습니다.</td>
        </tr>
        <%
        } else {
            for(BranchSalesSummaryDto dto : myDailyList){
        %>
        <tr>
            <td><%= dto.getSalesDate() %></td>
            <td><%= String.format("%,d 원", dto.getTotalAmount()) %></td>
        </tr>
        <%
            }
        %>
        <!-- 선택 기간 총합계 -->
        <tr>
            <td><b>선택 기간 총합계</b></td>
            <td><b><%= String.format("%,d 원", totalSum) %></b></td>
        </tr>
        <%
        }
        %>
    </table>

    <br>
    <button onclick="location.href='<%= request.getContextPath() %>/branch-sales/list.jsp'">← 매출 목록으로</button>
</body>
</html>