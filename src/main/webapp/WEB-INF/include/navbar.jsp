<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String userId = (String) session.getAttribute("userId");
    String branchId = (String) session.getAttribute("branchId");
%>
<nav class="navbar navbar-expand-lg navbar-dark bg-primary py-1" style="min-height: 45px;">
  <div class="container-fluid" style="padding-top: 0.25rem; padding-bottom: 0.25rem;">
    <!-- 로고 -->
    <a class="navbar-brand" href="<%=request.getContextPath()%>/branch.jsp" 
       style="font-weight: bold; font-size: 1.2rem; padding-top: 0; padding-bottom: 0;">
      종복치킨 ERP
    </a>

    <!-- 오른쪽 메뉴 -->
    <div class="d-flex justify-content-end align-items-center" style="gap: 0.5rem;">
      <% if(userId != null) { %>
        <span class="navbar-text text-white" style="font-size: 0.9rem; padding: 0;">
        		<a class="nav-link  p-0"
				href="${pageContext.request.contextPath}/userp/userpinfo.jsp">
					      <%= userId %>님
			</a>
        
        </span>
        
        <% if(branchId != null && branchId.startsWith("BC")) { %>
          <a class="btn btn-outline-warning btn-sm py-0 px-2" 
             style="font-size: 0.8rem; line-height: 1.4;"
             href="<%=request.getContextPath()%>/branchinfo/info2.jsp">지점 정보수정</a>
        <% } %>
        
        <a class="btn btn-outline-light btn-sm py-0 px-2" 
           style="font-size: 0.8rem; line-height: 1.4;"
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
