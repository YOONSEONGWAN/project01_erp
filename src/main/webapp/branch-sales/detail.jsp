<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="test.dao.SalesDao" %>
<%@ page import="test.dto.SalesDto" %>
<%
    request.setCharacterEncoding("UTF-8");

    String branchId = (String)session.getAttribute("branchId");
    if(branchId == null){
        response.sendRedirect(request.getContextPath()+"/userp/branchlogin-form.jsp");
        return;
    }

    int salesId = Integer.parseInt(request.getParameter("salesId"));
    SalesDto dto = SalesDao.getInstance().getById(salesId, branchId);

    if(dto == null){
%>
    <script>
        alert("권한이 없거나 존재하지 않는 매출입니다.");
        history.back();
    </script>
<%
        return;
    }

    String cpath = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>/branch-sales/detail.jsp</title>
    <script>const cpath = "<%= cpath %>";</script>
</head>
<body>
    <h2>매출 상세 보기</h2>
    <table border="1" cellpadding="10">
        <tr><th>매출 ID</th><td><%= dto.getSalesId() %></td></tr>
        <tr><th>지점 ID</th><td><%= dto.getBranchId() %></td></tr>
        <tr><th>매출 발생일</th><td><%= dto.getCreated_at() %></td></tr>
        <tr><th>총 매출 금액</th><td><%= dto.getTotalAmount() %> 원</td></tr>
    </table>

    <p style="margin-top: 15px;">
        <button onclick="location.href = cpath + '/branch-sales/update-form.jsp?salesId=<%= dto.getSalesId() %>'">수정</button>
        <button onclick="location.href = cpath + '/branch-sales/delete.jsp?salesId=<%= dto.getSalesId() %>'">삭제</button>
        <button onclick="location.href = cpath + '/branch-sales/list.jsp'">목록</button>
    </p>
</body>
</html>