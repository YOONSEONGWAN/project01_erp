<%@page import="java.sql.Timestamp"%>
<%@page import="java.util.List"%>
<%@page import="dao.WorkLogDao"%>
<%@page import="dto.WorkLogDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
String branchId = (String)session.getAttribute("branchId");
String branchName = WorkLogDao.getInstance().getBranchName(branchId); // 지점명 받아오기
List<WorkLogDto> logs = WorkLogDao.getInstance().getLogsByBranch(branchId);
List<String> branchList = WorkLogDao.getInstance().getBranchIdListFromLog();

/*WorkLogDao dao = new WorkLogDao();

List<String> branchList = dao.getBranchIdListFromLog();

String branchId = request.getParameter("branchId");
if(branchId == null && branchList.size() > 0) {
    branchId = branchList.get(0); // 기본값(첫 번째 지점)
}
List<WorkLogDto> logs = dao.getLogsByBranch(branchId);
*/


%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title><%= branchName %> 출퇴근 현황</title>
<jsp:include page="/WEB-INF/include/resource.jsp"></jsp:include>
<style>
.big-table th, .big-table td { padding:8px; }
select { font-size: 1.05em; padding: 4px 8px; }
</style>
</head>
<body>
<h3><%= branchName %> 출퇴근 현황</h3>

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
<div style="margin-top: 18px; text-align: right;">
    <a href="${pageContext.request.contextPath}/headquater.jsp?page=work-log/work_log.jsp">
        <button type="button" style="font-size:1.08em; font-weight:bold; color:#fff; background:#695cff; border:none; border-radius:7px; padding:10px 26px; cursor:pointer;">
            출퇴근 하러가기
        </button>
    </a>
</div>
</body>
</html>