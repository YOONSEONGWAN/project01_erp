<%@page import="java.util.List"%>
<%@page import="dao.stock.InAndOutDao"%>
<%@page import="dto.stock.InAndOutDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
    List<InAndOutDto> list = InAndOutDao.getInstance().selectAll();

    int latestOrderId = -1;
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
<title>입고 / 출고 관리</title>
</head>
<body>
    <div class="container">

        <h2>입고 현황</h2>
        <% if (list.isEmpty()) { %>
            <p>입고 내역이 없습니다.</p>
        <% } else { %>
            <table border="1" cellpadding="5" cellspacing="0">
                <thead>
                    <tr>
                        <th>입고 여부</th>
                        <th>승인 상태</th>
                        <th>입고 날짜</th>
                        <th>담당자</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (InAndOutDto tmp : list) {
                        if (tmp.getOrderId() != latestOrderId) continue;
                    %>
                    <tr>
                        <td><%= tmp.isInOrder() ? "YES" : "NO" %></td>
                        <td><%= tmp.getInApproval() != null ? tmp.getInApproval() : "-" %></td>
                        <td><%= tmp.getIn_date() != null ? tmp.getIn_date() : "-" %></td>
                        <td><%= tmp.getManager() != null ? tmp.getManager() : "-" %></td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        <% } %>

        <h2>출고 현황</h2>
        <% if (list.isEmpty()) { %>
            <p>출고 내역이 없습니다.</p>
        <% } else { %>
            <table border="1" cellpadding="5" cellspacing="0">
                <thead>
                    <tr>
                        <th>출고 여부</th>
                        <th>승인 상태</th>
                        <th>출고 날짜</th>
                        <th>담당자</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (InAndOutDto tmp : list) {
                        if (tmp.getOrderId() != latestOrderId) continue;
                    %>
                    <tr>
                        <td><%= tmp.isOutOrder() ? "YES" : "NO" %></td>
                        <td><%= tmp.getOutApproval() != null ? tmp.getOutApproval() : "-" %></td>
                        <td><%= tmp.getOut_date() != null ? tmp.getOut_date() : "-" %></td>
                        <td><%= tmp.getManager() != null ? tmp.getManager() : "-" %></td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        <% } %>

        <h2>입출고 종합 목록</h2>
        <% if (list.isEmpty()) { %>
            <p>입출고 내역이 없습니다.</p>
        <% } else { %>
            <table border="1" cellspacing="0" cellpadding="5">
                <thead>
                    <tr>
                        <th>주문ID</th>
                        <th>재고ID</th>
                        <th>입고 여부</th>
                        <th>입고 승인 상태</th>
                        <th>입고 날짜</th>
                        <th>출고 여부</th>
                        <th>출고 승인 상태</th>
                        <th>출고 날짜</th>
                        <th>담당자</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (InAndOutDto dto : list) { %>
                    <tr>
                        <td><%= dto.getOrderId() %></td>
                        <td><%= dto.getInventoryId() %></td>
                        <td><%= dto.isInOrder() ? "YES" : "NO" %></td>
                        <td><%= dto.getInApproval() != null ? dto.getInApproval() : "-" %></td>
                        <td><%= dto.getIn_date() != null ? dto.getIn_date() : "-" %></td>
                        <td><%= dto.isOutOrder() ? "YES" : "NO" %></td>
                        <td><%= dto.getOutApproval() != null ? dto.getOutApproval() : "-" %></td>
                        <td><%= dto.getOut_date() != null ? dto.getOut_date() : "-" %></td>
                        <td><%= dto.getManager() != null ? dto.getManager() : "-" %></td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        <% } %>

        <div style="text-align:center; margin-top:30px;">
            <a href="inandout_in.jsp">입고 신청/처리</a>
            <a href="inandout_out.jsp">출고 신청/처리</a>
        </div>
    </div>
</body>
</html>