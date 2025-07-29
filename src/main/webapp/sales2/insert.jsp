<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="test.dao.SalesDao" %>
<%@ page import="test.dto.SalesDto" %>
<%
    request.setCharacterEncoding("UTF-8");

    String branch = request.getParameter("branch");
    String createdAt = request.getParameter("createdAt");
    int totalAmount = Integer.parseInt(request.getParameter("totalAmount"));

    SalesDto dto = new SalesDto();
    dto.setBranch(branch);
    dto.setCreatedAt(createdAt);
    dto.setTotalAmount(totalAmount);

    SalesDao dao = new SalesDao();
    boolean isSuccess = dao.insert(dto);

    if (isSuccess) {
%>
    <script>
        alert("등록 성공");
        location.href = "list.jsp";
    </script>
<%
    } else {
%>
    <script>
        alert("등록 실패");
        history.back();
    </script>
<%
    }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/sales2/insert.jsp</title>
</head>
<body>
	
</body>
</html>