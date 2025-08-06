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
<h3 class="text-center fw-semibold" style="font-family:var(--bs-body-font-family); font-size:2rem; color:#444;">
  <%= branchName %> 출퇴근 현황
</h3>
<jsp:include page="/WEB-INF/include/resource.jsp"></jsp:include>
<style>
.big-table {
    border-collapse: collapse;
    width: 100%;
    background: #f7fbfd;
}
.big-table th, .big-table td {
    padding: 9px 8px;
    border: 1.3px solid #93d1f7; /* 연한 하늘색 */
    color: #222;
}
.big-table th {
    background: #e3f2fd;   /* 연한 파스텔 블루 */
    color: #195e8d;        /* 차분한 진블루 */
    font-weight: 600;
}
.big-table tr:nth-child(even) td {
    background: #f3faff;
}
.big-table th:last-child, .big-table td:last-child {
    border-right: none;
}



</style>
</head>
<body>

<h3><%= branchName %> 출퇴근 현황</h3>



<table border="1" class="big-table mt-3" style="width:100%;">
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
    <a href="<%=request.getContextPath()%>/branch.jsp?page=work-log/work_log.jsp">
        <button type="button" style="font-size:1.08em; font-weight:bold; color:#fff; background:#695cff; border:none; border-radius:7px; padding:10px 26px; cursor:pointer;">
            출퇴근 하러가기
        </button>
    </a>
</div>
</body>
</html>