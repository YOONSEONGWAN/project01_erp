<%@page import="java.net.URLEncoder"%>
<%@page import="org.mindrot.jbcrypt.BCrypt"%>
<%@page import="dao.UserDao"%>
<%@page import="dto.UserDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    request.setCharacterEncoding("UTF-8");

    String userId = request.getParameter("user_id");  // 로그인용 ID
    String password = request.getParameter("password");
    String url = request.getParameter("url");
    if(url == null || url.equals("")) {
        url = request.getContextPath() + "/index.jsp"; // 기본 이동 페이지
    }
    String encodedUrl = URLEncoder.encode(url, "UTF-8");

    boolean isValid = false;
    UserDto dto = UserDao.getInstance().getByUserId(userId); // 아이디로 조회

    if(dto != null) {
        isValid = BCrypt.checkpw(password, dto.getPassword()); // 비밀번호 검증
    }

    if(isValid) {
        // 세션에 로그인 정보 저장
        session.setAttribute("userId", userId);
        session.setAttribute("userName", dto.getUserName());
        session.setAttribute("grade", dto.getGrade()); // 본사, 지점장, 직원 등
        session.setMaxInactiveInterval(60 * 60); // 1시간 세션 유지
        
    }
    if (dto == null) {
        System.out.println("로그인 실패: 아이디 없음 -> " + userId);
    } else {
        System.out.println("DB에서 가져온 비번: " + dto.getPassword());
    }

%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/user/login.jsp</title>
<jsp:include page="/WEB-INF/include/resource.jsp" />
</head>
<body>
    <jsp:include page="/WEB-INF/include/navbar2.jsp">
        <jsp:param value="login" name="thisPage"/>
    </jsp:include>
    <div class="container mt-5">
        <% if(isValid){ %>
            <div class="alert alert-success text-center">
                <strong><%=dto.getUserName()%></strong>님, 환영합니다! 로그인에 성공했습니다.<br/>
                잠시 후 이동하거나 <a href="<%=url%>" class="alert-link">여기</a>를 클릭하세요.
            </div>
        <% } else { %>
            <div class="alert alert-danger text-center">
                아이디 혹은 비밀번호가 잘못되었습니다.<br/>
                <a href="loginform.jsp?url=<%=encodedUrl%>" class="btn btn-danger mt-3">다시 로그인</a>
            </div>
        <% } %>
    </div>

    <jsp:include page="/WEB-INF/include/footer.jsp"/>
</body>
</html>
