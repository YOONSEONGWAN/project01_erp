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
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>/branch-sales/update-form.jsp</title>
</head>
<body>
    <h2>매출 수정</h2>
    <form action="update.jsp" method="post">
        <input type="hidden" name="salesId" value="<%= dto.getSalesId() %>">
        <table border="1" cellpadding="10">
            <tr>
                <th>총 매출 금액</th>
                <td><input type="number" name="totalAmount" value="<%= dto.getTotalAmount() %>" required></td>
            </tr>
        </table>
        <br>
        <button type="submit">수정</button>
        <button type="button" onclick="location.href='list.jsp'">취소</button>
    </form>
</body>
</html>