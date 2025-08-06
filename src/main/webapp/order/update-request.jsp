<%@ page import="dao.StockRequestDao" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
request.setCharacterEncoding("UTF-8");
int orderId = Integer.parseInt(request.getParameter("orderId"));
String product = request.getParameter("product");
int requestQuantity = Integer.parseInt(request.getParameter("requestQuantity"));

boolean isSuccess = StockRequestDao.getInstance().updateRequest(orderId, product, requestQuantity);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>수정 처리</title>
    <script>
    <% if(isSuccess) { %>
        alert('수정되었습니다.');
        location.href = '<%=request.getContextPath()%>/headquater.jsp?page=order/list.jsp';
    <% } else { %>
        alert('수정 실패!');
        history.back();
    <% } %>
    </script>
</head>
<body>
</body>
</html>