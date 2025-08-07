<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String userId = (String) session.getAttribute("userId");
    String branchId = (String) session.getAttribute("branchId");
%>
<style>
  body {
    margin: 0; /* 페이지 전체 상단 여백 제거 */
  }
  .custom-navbar {
    background-color: #003366 !important; /* 남색 */
    margin-top: 0 !important; /* 네비바 상단 여백 제거 */
  }
</style>
	<nav class="navbar navbar-expand-lg navbar-dark bg-primary py-1" style="min-height: 45px;">
	  <div class="container-fluid" style="padding-top: 0.25rem; padding-bottom: 0.25rem;">
	    <!-- 로고 -->
	    <a class="navbar-brand" 
		   href="<%= (branchId != null && branchId.startsWith("BC")) ? request.getContextPath() + "/branch.jsp" : request.getContextPath() + "/headquater.jsp" %>"
		   style="font-weight: bold; font-size: 1.2rem; padding-top: 0; padding-bottom: 0;">
		  종복치킨 ERP
		</a>
	
	    <div class="d-flex justify-content-end align-items-center" style="gap: 1rem;">
	      <% if(userId != null) { %>
	        <span class="navbar-text text-white align-self-center"><%= userId %>님</span>
	
	        <% if(branchId != null && branchId.startsWith("BC")) { %>
	          <a class="btn btn-outline-warning btn-sm" href="<%=request.getContextPath()%>/branchinfo/info2.jsp">지점 정보수정</a>
	        <% } %>
	
	        <a class="btn btn-outline-light btn-sm" href="<%=request.getContextPath()%>/userp/logout.jsp">로그아웃</a>
	
	      <% } else { %>
	        <a class="btn btn-outline-light btn-sm" href="<%=request.getContextPath()%>/login.jsp">로그인</a>
	        <a class="btn btn-outline-light btn-sm" href="<%=request.getContextPath()%>/register.jsp">회원가입</a>
	      <% } %>
	    </div>
	  </div>
	</nav>
