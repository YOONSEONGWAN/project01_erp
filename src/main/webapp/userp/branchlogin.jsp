<%@page import="java.net.URLEncoder"%>
<%@page import="org.mindrot.jbcrypt.BCrypt"%>
<%@page import="dao.UserDao"%>
<%@page import="dto.UserDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    request.setCharacterEncoding("UTF-8");

    String branchId = request.getParameter("branchId");
    String userId = request.getParameter("userId");
    String password = request.getParameter("password");

    boolean isBranch = branchId != null && branchId.matches("^BC-\\d{3}$");
    if (!isBranch) {
%>
    <script>
        alert("이 페이지는 지점 전용 로그인입니다. 지점 코드는 BC-001 형식으로 입력해주세요.");
        history.back();
    </script>
<%
        return; // 잘못된 지점코드면 로그인 시도 자체를 막음
    }

    boolean isValid = false;
    UserDto dto = UserDao.getInstance().getByBIandUI(branchId, userId);

    if (dto != null && BCrypt.checkpw(password, dto.getPassword())) {
        isValid = true;
    }

    if (isValid) {
        // 세션 저장
        session.setAttribute("userId", userId);
        session.setAttribute("branchId", branchId);
        session.setAttribute("role", dto.getRole());
        session.setMaxInactiveInterval(60*60); // 1시간 세션 유지

        // 로그인 성공 -> 지점 인덱스로 이동
        response.sendRedirect(request.getContextPath() + "/branch.jsp");
    } else {
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/userp/branchlogin.jsp</title>
</head>
<body>
    <script>
        alert("아이디 혹은 비밀번호가 잘못되었거나, 지점 계정이 아닙니다.");
        location.href = "<%= request.getContextPath() %>/userp/branchlogin-form.jsp";
    </script>
<%
    } 
%>
</body>
</html>
