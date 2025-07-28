<%@page import="java.util.List"%>
<%@page import="dao.stock.InAndOutDao"%>
<%@page import="dto.stock.InAndOutDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
    List<InAndOutDto> list = InAndOutDao.getInstance().selectAll();

    int latestOrderId = 0;
    if (!list.isEmpty()) {
        latestOrderId = list.get(0).getOrderId();
        for (InAndOutDto dto : list) {
            if (dto.getOrderId() > latestOrderId) {
                latestOrderId = dto.getOrderId();
            }
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>출고 신청/처리</title>
</head>
<body>
    <div class="container">

        <h2>출고 신청 / 처리 화면 (최신 주문 ID: <%= latestOrderId %>)</h2>
        <table border="1" cellpadding="5" cellspacing="0">
            <thead>
                <tr>
                    <th>출고 여부</th>
                    <th>승인 상태</th>
                    <th>출고 날짜</th>
                    <th>담당자</th>
                    <th>처리</th>
                </tr>
            </thead>
            <tbody>
                <% for (InAndOutDto dto : list) {
                    if (dto.getOrderId() != latestOrderId) continue;
                %>
                <tr>
                    <td><%= dto.isOutOrder() ? "YES" : "NO" %></td>
                    <td><%= dto.getOutApproval() != null ? dto.getOutApproval() : "-" %></td>
                    <td><%= dto.getOut_date() != null ? dto.getOut_date() : "-" %></td>
                    <td><%= dto.getManager() != null ? dto.getManager() : "-" %></td>
                    <td>
                        <% if ("대기".equals(dto.getOutApproval())) { %>
                            <form action="approve_update.jsp" method="post">
                            	<input type="hidden" name="pageName" value="inandout_out.jsp">
                                <input type="hidden" name="orderId" value="<%= dto.getOrderId() %>">
                                <select name="outApproval">
                                    <option value="승인">승인</option>
                                    <option value="반려">반려</option>
                                </select>
                                <input type="submit" value="처리">
                            </form>
                        <% } else { %>
                            처리 완료
                        <% } %>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>

        <h2>출고 승인된 목록 (최근 10개)</h2>
        <table border="1" cellpadding="5" cellspacing="0">
            <thead>
                <tr>
                    <th>주문ID</th>
                    <th>출고 여부</th>
                    <th>출고 날짜</th>
                    <th>담당자</th>
                </tr>
            </thead>
            <tbody>
                <%
                int approvedCount = 0;
                for (InAndOutDto dto : list) {
                    if ("승인".equals(dto.getOutApproval())) {
                        if (approvedCount++ >= 10) break;
                %>
                <tr>
                    <td><%= dto.getOrderId() %></td>
                    <td><%= dto.isOutOrder() ? "YES" : "NO" %></td>
                    <td><%= dto.getOut_date() != null ? dto.getOut_date() : "-" %></td>
                    <td><%= dto.getManager() != null ? dto.getManager() : "-" %></td>
                </tr>
                <% }
                } %>
            </tbody>
        </table>
        <div style="margin-top:10px;">
            <a href="inandout_out_approved.jsp">전체 목록 보기</a>
        </div>

        <h2>출고 반려된 목록 (최근 10개)</h2>
        <table border="1" cellpadding="5" cellspacing="0">
            <thead>
                <tr>
                    <th>주문ID</th>
                    <th>출고 여부</th>
                    <th>출고 날짜</th>
                    <th>담당자</th>
                </tr>
            </thead>
            <tbody>
                <%
                int rejectedCount = 0;
                for (InAndOutDto dto : list) {
                    if ("반려".equals(dto.getOutApproval())) {
                        if (rejectedCount++ >= 10) break;
                %>
                <tr>
                    <td><%= dto.getOrderId() %></td>
                    <td><%= dto.isOutOrder() ? "YES" : "NO" %></td>
                    <td><%= dto.getOut_date() != null ? dto.getOut_date() : "-" %></td>
                    <td><%= dto.getManager() != null ? dto.getManager() : "-" %></td>
                </tr>
                <% }
                } %>
            </tbody>
        </table>
        <div style="margin-top:10px;">
            <a href="inandout_out_rejected.jsp">전체 목록 보기</a>
        </div>

        <div style="margin-top: 20px;">
            <a href="inandout.jsp">돌아가기</a>
        </div>

    </div>
</body>
</html>