<%@page import="dao.UserDao"%>
<%@page import="dto.UserDto"%>
<%@page import="org.mindrot.jbcrypt.BCrypt"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    request.setCharacterEncoding("UTF-8");

    // 📌 입력값 수신
    String branchId = request.getParameter("branchId");
    String userId = request.getParameter("userId");
    String password = request.getParameter("password");
    String userName = request.getParameter("userName");

    System.out.println("📌 signup.jsp 진입");
    System.out.println("📌 userId = " + userId);
    System.out.println("📌 branchId = " + branchId);

    boolean isSuccess = false;

    // 입력값 모두 존재할 때만 실행
    if (branchId != null && userId != null && password != null && userName != null) {
        try {
            // 비밀번호 암호화
            String hashed = BCrypt.hashpw(password, BCrypt.gensalt());
            System.out.println("📌 비밀번호 암호화 성공");

            // 회원 DTO 생성
            UserDto dto = new UserDto();
            dto.setBranch_id(branchId);
            dto.setUser_id(userId);
            dto.setPassword(hashed);
            dto.setUser_name(userName);

            // DB에 insert 시도
            isSuccess = UserDao.getInstance().insert(dto);
            System.out.println("📌 INSERT 결과: " + isSuccess);
        } catch (Exception e) {
            e.printStackTrace(); // 콘솔에 예외 출력
        }
    } else {
        System.out.println("❌ 입력값 누락: branchId/userId/password/userName 중 하나 이상 null");
    }

    String branchType = "HQ".equalsIgnoreCase(branchId) ? "본사" : "지점";
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>/userp/signup.jsp</title>
</head>
<body>
    <div class="container">
        <% if (isSuccess) { %>
            <p>
                <strong><%= userId %>님 <%= branchType %> (<%= branchId %>) 회원가입 되었습니다.</strong><br>
                <a href="loginform.jsp">로그인 하러가기</a>
            </p>
        <% } else { %>
            <p style="color:red;">
                가입 실패: 입력값 누락 또는 DB 오류<br>
                📌 userId: <%= userId %><br>
                📌 branchId: <%= branchId %><br>
                <a href="signup-form.jsp">다시 회원가입</a>
            </p>
        <% } %>
    </div>
</body>
</html>