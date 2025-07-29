<%@page import="java.sql.Timestamp"%>
<%@page import="dto.WorkLogDto"%>
<%@page import="java.util.List"%>
<%@page import="dao.WorkLogDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
    
    <%
    String userId = (String)session.getAttribute("userId");
    WorkLogDao dao = new WorkLogDao();

    String action = request.getParameter("action");
    if ("checkin".equals(action)) {
        dao.insertStartTime(userId);
    } else if ("checkout".equals(action)) {
        dao.updateEndTime(userId);
    }

    List<WorkLogDto> logs = dao.getLogsByUser(userId);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<h3>출퇴근 기록</h3>
<form method="post">
    <button type="submit" name="action" value="checkin">출근</button>
    <button type="submit" name="action" value="checkout">퇴근</button>
</form>
<table border="1">
    <tr>
        <th>날짜</th>
        <th>출근 시간</th>
        <th>퇴근 시간</th>
        <th>근무 시간</th>
    </tr>
<%
    for (WorkLogDto dto : logs) {
        Timestamp CheckIn = dto.getCheckInTime();
        Timestamp CheckOut = dto.getCheckOutTime();
        long hours = 0;
        long minutes = 0;

        if (CheckIn != null && out != null) {
            long millis = CheckOut.getTime() - CheckIn.getTime();
            hours = millis / (1000 * 60 * 60);
            minutes = (millis / (1000 * 60)) % 60;
        }
%>
    <tr>
        <td><%= dto.getWorkDate() %></td>
        <td><%= CheckIn != null ? CheckIn.toString().substring(11, 16) : "-" %></td>
        <td><%= CheckOut != null ? CheckOut.toString().substring(11, 16) : "-" %></td>
        <td>
            <%= (CheckIn != null && CheckOut != null) ? hours + "시간 " + minutes + "분" : "-" %>
        </td>
    </tr>
<%
    }
%>
</table>
</body>
</html>