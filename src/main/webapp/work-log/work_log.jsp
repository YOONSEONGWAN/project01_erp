<%@page import="java.sql.Timestamp"%>
<%@page import="dto.WorkLogDto"%>
<%@page import="java.util.List"%>
<%@page import="dao.WorkLogDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>


<%
String branchId = (String) session.getAttribute("branchId");
String userId = (String) session.getAttribute("userId");
WorkLogDao dao = new WorkLogDao();

//디버깅용 값 찍기
out.println("DEBUG: checkout 클릭 branchId=" + branchId + ", userId=" + userId);

String action = request.getParameter("action");
if ("checkin".equals(action)) {
	dao.insertStartTime(branchId, userId);
} else if ("checkout".equals(action)) {
	dao.updateEndTime(branchId, userId);
}

List<WorkLogDto> logs = dao.getLogsByUser(userId);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>출퇴근 하기</title>
<style>
.button-bar {
    width: 100%;
    margin-bottom: 12px;
}
.button-left {
    float: left;
}
.button-right {
    float: right;
}
.big-btn {
    font-size: 1.2em;
    padding: 10px 28px;
    height: 48px;
    min-width: 120px;
    border-radius: 8px;
    font-weight: bold;
}
.clearfix::after {
    content: "";
    display: table;
    clear: both;
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
    <a href="view-work_log.jsp?branchId=<%= branchId %>" style="font-size:1.05em; font-weight:bold; color:#1565c0;">
        ▶ 전직원 출퇴근 현황 보기
    </a>
</div>
</body>
</html>