<%@page import="dto.ProductDto"%>
<%@page import="dao.ProductDao"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    int num = Integer.parseInt(request.getParameter("num"));
    ProductDto dto = new ProductDao().getByNum(num);
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>상품 상세</title>
</head>
<body>
    <h1>상품 상세 정보</h1>
    
    <% if (dto != null) { %>
        <table border="1" cellpadding="10">
            <tr><th>번호</th><td><%=dto.getNum()%></td></tr>
            <tr><th>상품명</th><td><%=dto.getName()%></td></tr>
            <tr><th>설명</th><td><%=dto.getDescription()%></td></tr>
            <tr><th>가격</th><td><%=dto.getPrice()%></td></tr>
            <tr><th>상태</th><td><%=dto.getStatus()%></td></tr>
            <% if (dto.getImagePath() != null && !dto.getImagePath().isEmpty()) { %>
            <tr>
                <th>이미지</th>
                <td>
                    <img src="<%=request.getContextPath() + "/image?name=" + dto.getImagePath()%>" class="product-img">

                </td>
            </tr>
            <% } %>
        </table>
    <% } %>
    
    <br>
    <a href="list.jsp">← 목록으로</a>
</body>
</html>
