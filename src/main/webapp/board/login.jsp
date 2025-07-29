<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
  String id = request.getParameter("id");
  String pwd = request.getParameter("pwd");

  // 테스트용 계정 (나중에 UserDao를 통해 DB 인증으로 바꿀 수 있음)
  if ("testuser".equals(id) && "1234".equals(pwd)) {
    // 로그인 성공 → 세션에 저장
    session.setAttribute("userName", id);

    response.sendRedirect(request.getContextPath() + "/index.jsp");
  } else {
%>
    <script>
      alert("로그인 실패: 아이디 또는 비밀번호가 올바르지 않습니다.");
      history.back();
    </script>
<%
  }
%>