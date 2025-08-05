<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="test.dao.BranchSalesDao" %>
<%@ page import="test.dto.BranchSalesDto" %>
<%
request.setCharacterEncoding("UTF-8");

    String branchId = (String)session.getAttribute("branchId");
    if(branchId == null){
        response.sendRedirect(request.getContextPath()+"/userp/branchlogin-form.jsp");
        return;
    }

    List<BranchSalesDto> list = BranchSalesDao.getInstance().getList(branchId);
    String cpath = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>/branch-sales/list.jsp</title>
    <script>const cpath = "<%=cpath%>";</script>
</head>
<body>
    <h2>매출 목록 (지점: <%=branchId%>)</h2>
    <button onclick="location.href=cpath+'/branch-sales/insert-form.jsp'">매출 등록</button>
    <button onclick="location.href=cpath+'/branch-sales/summary.jsp'">매출 합계</button>
    <br><br>
    <table border="1" cellpadding="5">
        <tr>
            <th>ID</th>
            <th>날짜</th>
            <th>금액</th>
            <th>상세보기</th>
        </tr>
        <%
        for(BranchSalesDto dto : list){
        %>
        <tr>
            <td><%= dto.getSalesId() %></td>
            <td><%= dto.getCreated_at() %></td>
            <td><%= dto.getTotalAmount() %> 원</td>
            <td><a href="<%= cpath %>/branch-sales/detail.jsp?salesId=<%= dto.getSalesId() %>">보기</a></td>
        </tr>
        <%
            }
        %>
    </table>
</body>
</html>