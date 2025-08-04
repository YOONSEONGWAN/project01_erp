<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String branchType = request.getParameter("branch");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>회원가입</title>
</head>
<body>

<h1>회원가입</h1>

<form action="signup.jsp" method="post">
	<%
        if ("HQ".equals(branchType)) {
    %>
        <p><strong>※ 본사 회원으로 가입합니다.</strong></p>
        본사 코드 (branch_id): <input type="text" name="branchId" placeholder="예: HQ"><br>
    <%
        } else {
    %>
        <p><strong>※ 지점 회원으로 가입합니다.</strong></p>
        지점 코드 (branch_id): <input type="text" name="branchId" placeholder="예: B001"><br>
    <%
        }
    %>
    <br />
    아이디: <input type="text" name="userId"><br>
    비밀번호: <input type="password" name="password"><br>
    이름: <input type="text" name="userName"><br>

    <input type="submit" value="회원가입">
</form>

</body>
</html>