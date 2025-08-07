<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String userId = (String) session.getAttribute("userId");
    String branchId = (String) session.getAttribute("branchId");
%>
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> origin/main
<style>
  body {
    margin: 0; /* 페이지 전체 상단 여백 제거 */
  }
  .custom-navbar {
    background-color: #003366 !important; /* 로그인 버튼과 동일한 남색 */
    margin-top: 0 !important; /* 네비바 상단 여백 제거 */
  }
</style>

<nav class="navbar navbar-expand-lg navbar-dark custom-navbar">
  <div class="container-fluid">
    <a class="navbar-brand" href="<%=request.getContextPath()%>/headquater.jsp" style="font-weight: bold; font-size: 1.5rem;">
      종복치킨 ERP
    </a>

    <div class="d-flex justify-content-end align-items-center" style="gap: 1rem;">
      <% if(userId != null) { %>
        <span class="navbar-text text-white align-self-center"><%= userId %>님</span>
        <% if(branchId != null && branchId.startsWith("BC")) { %>
          <a class="btn btn-outline-warning btn-sm" href="<%=request.getContextPath()%>/branchinfo/info2.jsp">지점 정보수정</a>
        <% } %>
        <a class="btn btn-outline-light btn-sm d-flex align-items-center" 
           style="padding-left: 0.5rem; padding-right: 0.5rem; white-space: nowrap;" 
<<<<<<< HEAD
=======
<nav class="navbar navbar-expand-lg navbar-dark bg-primary py-1" style="min-height: 45px;">
  <div class="container-fluid" style="padding-top: 0.25rem; padding-bottom: 0.25rem;">
    <!-- 로고 -->
    <a class="navbar-brand" href="<%=request.getContextPath()%>/headquater.jsp" 
       style="font-weight: bold; font-size: 1.2rem; padding-top: 0; padding-bottom: 0;">
      종복치킨 ERP
    </a>

    <!-- 오른쪽 메뉴 -->
    <div class="d-flex justify-content-end align-items-center" style="gap: 0.5rem;">
      <% if(userId != null) { %>
        <span class="navbar-text text-white" style="font-size: 0.9rem; padding: 0;"><%= userId %>님</span>
        
        <% if(branchId != null && branchId.startsWith("BC")) { %>
          <a class="btn btn-outline-warning btn-sm py-0 px-2" 
             style="font-size: 0.8rem; line-height: 1.4;"
             href="<%=request.getContextPath()%>/branchinfo/info2.jsp">지점 정보수정</a>
        <% } %>
        
        <a class="btn btn-outline-light btn-sm py-0 px-2" 
           style="font-size: 0.8rem; line-height: 1.4;"
>>>>>>> 72e7f5dc9479ee103b005f61aab18dc366d19d59
=======
>>>>>>> origin/main
           href="<%=request.getContextPath()%>/userp/logout.jsp">로그아웃</a>
      <% } else { %>
        <a class="btn btn-outline-light btn-sm py-0 px-2" 
           style="font-size: 0.8rem; line-height: 1.4;"
           href="<%=request.getContextPath()%>/login.jsp">로그인</a>
        <a class="btn btn-outline-light btn-sm py-0 px-2" 
           style="font-size: 0.8rem; line-height: 1.4;"
           href="<%=request.getContextPath()%>/register.jsp">회원가입</a>
      <% } %>
    </div>
  </div>
</nav>
