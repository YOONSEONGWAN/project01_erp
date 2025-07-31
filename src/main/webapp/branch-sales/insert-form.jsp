<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>/branch-sales/insert-form.jsp</title>
</head>
<body>
    <h2>매출 등록</h2>
    <form action="${pageContext.request.contextPath}/branch-sales/insert.jsp" method="post">
        <p>
            <label>지점 ID: <input type="text" name="branchId" required></label>
        </p>
        <p>
            <label>매출 금액: <input type="number" name="totalAmount" required></label>
        </p>
        <p>
            <button type="submit">등록</button>
            <button type="button" onclick="location.href='${pageContext.request.contextPath}/branch-sales/list.jsp'">목록</button>
        </p>
    </form>
</body>
</html>