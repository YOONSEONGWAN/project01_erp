<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    request.setCharacterEncoding("UTF-8");

    String branchId = (String)session.getAttribute("branchId");
    if(branchId == null){
        response.sendRedirect(request.getContextPath()+"/userp/branchlogin-form.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>/branch-sales/insert-form.jsp</title>
</head>
<body>
    <h2>매출 등록</h2>
    <form action="insert.jsp" method="post">
        <table border="1" cellpadding="10">
            <tr>
                <th>총 매출 금액</th>
                <td><input type="number" name="totalAmount" required></td>
            </tr>
        </table>
        <br>
        <button type="submit">등록</button>
        <button type="button" onclick="location.href='list.jsp'">취소</button>
    </form>
</body>
</html>