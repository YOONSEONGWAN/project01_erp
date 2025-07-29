<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>/sales2/insert-form.jsp</title>
</head>
<body>
    <h2>매출 등록 폼</h2>
    <form action="${pageContext.request.contextPath}/sales2/insert.jsp" method="post">
        <p>
            지점명: <input type="text" name="branch" required>
        </p>
        <input type="hidden" name="createdAt" value="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>">
        <p>
            총매출(원): <input type="number" name="totalAmount" required>
        </p>
        <p>
            <button type="submit">등록</button>
        </p>
    </form>
    <p><a href="${pageContext.request.contextPath}/sales2/list.jsp">[목록 보기]</a></p>
</body>
</html>
