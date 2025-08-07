<%@page import="java.sql.Timestamp"%>
<%@page import="dto.WorkLogDto"%>
<%@page import="java.util.List"%>
<%@page import="dao.WorkLogDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>


<%
String branchId = (String) session.getAttribute("branchId");
String userId = (String) session.getAttribute("userId");


String action = request.getParameter("action");
if ("checkin".equals(action)) {
	WorkLogDao.getInstance().insertStartTime(branchId, userId);
} else if ("checkout".equals(action)) {
	WorkLogDao.getInstance().updateEndTime(branchId, userId);
}
List<WorkLogDto> logs = WorkLogDao.getInstance().getLogsByUser(userId);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>출퇴근 하기</title>
<style>
table {
    border-collapse: collapse;
    width: 100%;
    background: #f8fbff;
}
th, td {
    border: 2px solid #136ec7;
    padding: 9px 4px;
    text-align: center;
    font-size: 1em;
}
th {
    background: #136ec7;
    color: #fff;
    font-weight: 700;
}
tr:nth-child(even) td {
    background: #e7f2fd;
}
tr:nth-child(odd) td {
    background: #f4faff;
}
.big-btn {
    font-size: 1.13em;
    padding: 10px 28px;
    min-width: 120px;
    border-radius: 8px;
    font-weight: bold;
    border: none;
    color: #fff;
    margin: 0 8px;
    background: #136ec7; /* 출근 기본 파랑 */
    transition: background 0.14s;
}

.button-left .big-btn {
    background: #136ec7;
}
.button-left .big-btn:hover {
    background: #125aad;
}

/* 퇴근: 단일 토마토(코랄)색 */
.button-right .big-btn {
    background: #f25c54;
}
.button-right .big-btn:hover {
    background: #d8433a;
}
</style>
</head>
<body>
<h3>출퇴근 기록</h3>
<div class="button-bar clearfix">
    <form method="post" class="button-left" style="display:inline;">
        <button class="big-btn" type="submit" name="action" value="checkin">출근</button>
    </form>
    <form method="post" class="button-right" style="display:inline;">
        <button class="big-btn" type="submit" name="action" value="checkout">퇴근</button>
    </form>
</div>
<table border="1" style="width:100%;">
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
        long hours = 0;
        long minutes = 0;
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
        <td>
            <%= (checkIn != null && checkOut != null) ? hours + "시간 " + minutes + "분" : "-" %>
        </td>
    </tr>
<%
    }
%>
</table>
<div style="margin-top: 18px; text-align: right;">
    <a href="${pageContext.request.contextPath}/branch.jsp?page=work-log/view-work_log.jsp&branchId=<%= branchId %>" style="font-size:1.05em; font-weight:bold; color:#1565c0;">
    	▶ 전직원 출퇴근 현황 보기
	</a>

</div>
</body>
</html>