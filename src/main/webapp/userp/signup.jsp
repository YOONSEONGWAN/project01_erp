<%@page import="dao.UserDao"%>
<%@page import="dto.UserDto"%>
<%@page import="org.mindrot.jbcrypt.BCrypt"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    request.setCharacterEncoding("UTF-8");

    // 입력값 수신
    String branchId = request.getParameter("branchId");
    String userId   = request.getParameter("userId");
    String password = request.getParameter("password");
    String userName = request.getParameter("userName");

    boolean isSuccess = false;

    if (branchId != null && userId != null && password != null && userName != null) {
        try {
            String hashed = BCrypt.hashpw(password, BCrypt.gensalt());
            UserDto dto = new UserDto();
            dto.setBranch_id(branchId);
            dto.setUser_id(userId);
            dto.setPassword(hashed);
            dto.setUser_name(userName);
            
            if ("HQ".equals(branchId)) {
                dto.setRole("admin");
            }

            isSuccess = UserDao.getInstance().insert(dto);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    String branchType = "HQ".equalsIgnoreCase(branchId) ? "본사" : "지점";
%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>/userp/signup.jsp</title>
<jsp:include page="/WEB-INF/include/resource.jsp"></jsp:include>
<style>
  body { background:#e9edf0; }
  .card-wrap { width:min(520px, 92vw); border-radius:12px; }
  .logo { width:200px; height:auto; }
  .btn-primary { background:#003366; border-color:#003366; }
  .btn-primary:hover { background:#002244; border-color:#002244; }
</style>
</head>
<body class="min-vh-100 d-flex align-items-center justify-content-center">
  <main class="card shadow-sm p-4 p-md-5 card-wrap">
    <div class="text-center mb-3">
      <img src="${pageContext.request.contextPath}/images/JB_logo.png" alt="종복치킨 ERP 로고" class="logo mb-2">
      <h1 class="h5 fw-bold mb-1">회원가입 결과</h1>
      <div class="text-muted small">ERP 시스템 포털</div>
    </div>

    <% if (isSuccess) { %>
      <div class="alert alert-success text-nowrap" role="alert">
        <strong><%= userId %></strong>님, <%= branchType %> (<%= branchId %>) 회원가입이 완료되었습니다.
      </div>
      <div class="d-grid gap-2">
        <a href="${pageContext.request.contextPath}/userp/loginform.jsp" class="btn btn-primary">로그인 하러가기</a>
        <a href="${pageContext.request.contextPath}/index.jsp" class="btn btn-outline-primary">메인으로</a>
      </div>
    <% } else { %>
      <div class="alert alert-danger" role="alert">
        가입에 실패했습니다.
        <div class="small mt-2">
          <div>📌 아이디: <%= userId %></div>
          <div>📌 지점 코드: <%= branchId %></div>
        </div>
      </div>
      <div class="d-grid gap-2">
        <a href="${pageContext.request.contextPath}/userp/signup-form.jsp" class="btn btn-primary">다시 회원가입</a>
        <a href="${pageContext.request.contextPath}/index.jsp" class="btn btn-outline-primary">메인으로</a>
      </div>
    <% } %>
  </main>
</body>
</html>
