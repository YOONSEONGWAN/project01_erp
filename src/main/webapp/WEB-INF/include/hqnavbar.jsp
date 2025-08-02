<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%-- /WEB-INF/include/navbar.jsp --%>
<%
	String thisPage = request.getParameter("thisPage");
	if (thisPage == null) thisPage = "";
	String userName = (String)session.getAttribute("userName");
%>
	<nav class="navbar navbar-expand-md bg-success" data-bs-theme="dark">
		<div class="container">
			<a class="navbar-brand" href="${pageContext.request.contextPath }/">Acorn</a>
			<button class="navbar-toggler" type="button"
				data-bs-toggle="collapse" data-bs-target="#navbarNav">
				<span class="navbar-toggler-icon"></span>
			</button>
			<div class="collapse navbar-collapse" id="navbarNav">
				<ul class="navbar-nav me-auto">
					<li class="nav-item">
						<a class="nav-link <%=thisPage.equals("member") ? "active":""%>" href="${pageContext.request.contextPath }/member/list.jsp">Member</a>
					</li>
					<li class="nav-item">
						<a class="nav-link <%=thisPage.equals("book") ? "active":""%>" href="${pageContext.request.contextPath }/book/list.jsp">Book</a>
					</li>
					<li class="nav-item">
						<a class="nav-link <%=thisPage.equals("board") ? "active":""%>" href="${pageContext.request.contextPath }/board/list.jsp">Board</a>
					</li>
					<li class="nav-item">
						<a class="nav-link <%=thisPage.equals("gallery") ? "active":""%>" href="${pageContext.request.contextPath }/gallery/list.jsp">Gallery</a>
					</li>					
				</ul>
	            <!-- 오른쪽 사용자 메뉴 -->
	            <ul class="navbar-nav">
                <%if (userName == null) {%>
	                <li class="nav-item">
	                    <a class="btn btn-outline-light btn-sm me-2"
	                       href="${pageContext.request.contextPath }/user/loginform.jsp">로그인</a>
	                </li>
	                <li class="nav-item">
	                    <a class="btn btn-warning btn-sm"
	                       href="${pageContext.request.contextPath }/user/signup-form.jsp">회원가입</a>
	                </li>
                <%}else {%>
	                <li class="nav-item  me-2">
					    <a class="nav-link  p-0"
					       href="${pageContext.request.contextPath}/user/info.jsp">
					        <strong><%= userName %></strong>
					    </a>
					</li>
	                <li class="nav-item me-2">
	                    <span class="navbar-text">Signed in</span>
	                </li>
	                <li class="nav-item">
	                    <a class="btn btn-danger btn-sm"
	                       href="${pageContext.request.contextPath }/user/logout.jsp">로그아웃</a>
	                </li>
                <%}%>
                </ul>
			</div>
		</div>
	</nav>
	