<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // 로그인 상태 체크
    String userId = (String) session.getAttribute("userId");
%>
<nav class="navbar navbar-expand-lg navbar-dark bg-primary">
  <div class="container-fluid">
    <!-- 글자 로고: 클릭하면 인덱스로 -->
    <a class="navbar-brand" href="<%=request.getContextPath()%>/headquater.jsp" style="font-weight: bold; font-size: 1.5rem;">
      종복치킨 ERP
    </a>

    <!-- 토글 버튼 제거 -->

    <!-- 로그인/회원가입 또는 환영 + 로그아웃 메뉴 항상 보이기 -->
    <div class="d-flex justify-content-end" style="gap: 1rem;">
      <% if(userId != null) { %>
        <span class="navbar-text text-white align-self-center">환영합니다, <%= userId %>님</span>
        <a class="btn btn-outline-light btn-sm" href="<%=request.getContextPath()%>/logout.jsp">로그아웃</a>
      <% } else { %>
        <a class="btn btn-outline-light btn-sm" href="<%=request.getContextPath()%>/login.jsp">로그인</a>
        <a class="btn btn-outline-light btn-sm" href="<%=request.getContextPath()%>/register.jsp">회원가입</a>
      <% } %>
    </div>
  </div>
</nav>
