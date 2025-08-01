<%@page import="java.sql.Timestamp"%>
<%@page import="java.util.List"%>
<%@page import="dao.WorkLogDao"%>
<%@page import="dto.WorkLogDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
WorkLogDao dao = new WorkLogDao();
// work_log 테이블에서 출근 기록 있는 지점만 셀렉트박스용으로 가져옴
List<String> branchList = dao.getBranchIdListFromLog();

String branchId = request.getParameter("branchId");
if(branchId == null && branchList.size() > 0) {
    branchId = branchList.get(0); // 기본값(첫 번째 지점)
}
List<WorkLogDto> logs = dao.getLogsByBranch(branchId);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>지점별 출퇴근 현황</title>
<jsp:include page="/WEB-INF/include/resource.jsp"></jsp:include>
<style>
.big-table th, .big-table td { padding:8px; }
select { font-size: 1.05em; padding: 4px 8px; }
</style>
</head>
<body>
	<jsp:include page="/WEB-INF/include/branchnavbar.jsp">
		<jsp:param value="work" name="thisPage"/>
	</jsp:include>
<h3>지점별 직원 출퇴근 현황</h3>

<!-- 셀렉트박스 form -->
<form method="get" style="margin-bottom:16px;">
    <label>지점 선택:
        <select name="branchId" onchange="this.form.submit()">
            <% for(String b : branchList) { %>
                <option value="<%= b %>" <%= b.equals(branchId) ? "selected" : "" %>><%= b %></option>
            <% } %>
        </select>
    </label>
</form>

<table border="1" class="big-table" style="width:100%;">
    <tr>
        <th>아이디</th>
        <th>날짜</th>
        <th>출근 시간</th>
        <th>퇴근 시간</th>
        <th>근무 시간</th>
    </tr>
<%
    for (WorkLogDto dto : logs) {
        Timestamp checkIn = dto.getStartTime();
        Timestamp checkOut = dto.getEndTime();
        long hours = 0, minutes = 0;
        if (checkIn != null && checkOut != null) {
            long millis = checkOut.getTime() - checkIn.getTime();
            hours = millis / (1000 * 60 * 60);
            minutes = (millis / (1000 * 60)) % 60;
        }
%>
    <tr>
        <td><%= dto.getUserId() %></td>
        <td><%= dto.getWorkDate() %></td>
        <td><%= checkIn != null ? checkIn.toString().substring(11, 16) : "-" %></td>
        <td><%= checkOut != null ? checkOut.toString().substring(11, 16) : "-" %></td>
        <td><%= (checkIn != null && checkOut != null) ? hours + "시간 " + minutes + "분" : "-" %></td>
    </tr>
<% } %>
</table>
</body>
</html>