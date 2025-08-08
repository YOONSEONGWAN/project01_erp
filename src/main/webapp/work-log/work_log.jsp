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
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
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



</style>
</head>
<body>
<h3 class="mb-4 ms-4">출퇴근 기록</h3>
<div class="row mb-4 ms-3" style="width:100%; margin:0;">
    <div class="col-6 d-grid">
        <form id="checkinForm" method="post">
            <button id="checkinBtn" type="submit" name="action" value="checkin" class="btn btn-lg fw-bold"
                style="background:#003366; color:#fff; border:none;">
                출근
            </button>
        </form>
    </div>
    <div class="col-6 d-grid text-end">
        <form id="checkoutForm" method="post">
            <button id="checkoutBtn" type="submit" name="action" value="checkout" class="btn btn-lg fw-bold"
                style="background:#80deea; color:#fff; border:none;">
                퇴근
            </button>
        </form>
    </div>
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
<script>
const checkinBtn = document.getElementById("checkinBtn");
const checkoutBtn = document.getElementById("checkoutBtn");

// 새로고침 시 출근 버튼 상태 세팅
if (localStorage.getItem("checkinLocked") === "true") {
    checkinBtn.disabled = true;
}

// 출근 버튼 클릭 시 상태 저장
document.getElementById("checkinForm").addEventListener("submit", function() {
    localStorage.setItem("checkinLocked", "true");
});

// 퇴근 버튼 클릭 시 상태 제거
document.getElementById("checkoutForm").addEventListener("submit", function() {
    localStorage.removeItem("checkinLocked");
});
</script>
</body>

</html>