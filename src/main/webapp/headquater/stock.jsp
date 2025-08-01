<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>메인 페이지</title>
    <jsp:include page="/WEB-INF/include/resource.jsp"></jsp:include>
</head>
<body>
	<jsp:include page="/WEB-INF/include/hqnavbar.jsp">
		<jsp:param value="stock" name="thisPage"/>
	</jsp:include>
    <h1>재고 관리 시스템</h1>

    <ul>
        <li><a href="${pageContext.request.contextPath}/stock/stock.jsp">재고 페이지</a></li>
        <li><a href="${pageContext.request.contextPath}/stock/placeorder.jsp">발주 페이지</a></li>
    </ul>
</body>
</html>