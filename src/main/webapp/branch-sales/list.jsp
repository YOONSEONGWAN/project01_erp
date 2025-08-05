<%@page import="test.dao.BranchSalesDao"%>
<%@page import="test.dto.BranchSalesDto"%>
<%@page import="java.util.List"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    request.setCharacterEncoding("UTF-8");

    String branchId = (String) session.getAttribute("branchId");
    if(branchId == null){
        response.sendRedirect(request.getContextPath()+"/userp/branchlogin-form.jsp");
        return;
    }

    // 기간 필터
    String startDate = request.getParameter("startDate");
    String endDate = request.getParameter("endDate");

    List<BranchSalesDto> salesList =
        BranchSalesDao.getInstance().getListByBranchAndPeriod(branchId, startDate, endDate);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/branch-sales/list.jsp</title>
</head>
<body>
    <h2>내 지점(<%=branchId%>) 매출 목록</h2>

    <!-- 기간 조회 폼 -->
    <form method="get" action="list.jsp" style="margin-bottom:10px;">
        시작일: <input type="date" name="startDate" value="<%= startDate==null?"":startDate %>">
        종료일: <input type="date" name="endDate" value="<%= endDate==null?"":endDate %>">
        <button type="submit">조회</button>
        <button type="button" onclick="location.href='list.jsp'">초기화</button>
    </form>

    <button onclick="location.href='insert-form.jsp'">매출 등록</button>
    <button onclick="location.href='summary.jsp'">일별 합계 보기</button>
    <br><br>

    <table border="1">
        <tr>
            <th>번호</th>
            <th>날짜</th>
            <th>금액</th>
            <th>관리</th>
        </tr>
        <%
        if(salesList.isEmpty()){
        %>
        <tr>
            <td colspan="4">조회된 매출 데이터가 없습니다.</td>
        </tr>
        <%
        } else {
            for(BranchSalesDto dto : salesList){
        %>
        <tr>
            <td><%= dto.getSalesId() %></td>
            <td><%= dto.getCreated_at() %></td>
            <td><%= String.format("%,d 원", dto.getTotalAmount()) %></td>
            <td>
                <button onclick="location.href='detail.jsp?salesId=<%=dto.getSalesId()%>'">상세</button>
                <button onclick="location.href='update-form.jsp?salesId=<%=dto.getSalesId()%>'">수정</button>
                <button onclick="if(confirm('삭제할까요?')) location.href='delete.jsp?salesId=<%=dto.getSalesId()%>'">삭제</button>
            </td>
        </tr>
        <%
            }
        }
        %>
    </table>
</body>
</html>