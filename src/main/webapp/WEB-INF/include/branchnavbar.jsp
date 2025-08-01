<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%-- /WEB-INF/include/branchnavbar.jsp --%>
<% 
	String thisPage = request.getParameter("thisPage");
	String userId = (String)session.getAttribute("userId");
	String branchId = (String)session.getAttribute("branchId");
%>
	<nav class="navbar navbar-expand-md bg-success" data-bs-theme="dark">
		<div class="container">
			<a class="navbar-brand" href="${pageContext.request.contextPath }/index/branchindex.jsp">종복치킨</a>
			<button class="navbar-toggler" type="button"
				data-bs-toggle="collapse" data-bs-target="#navbarNav">
				<span class="navbar-toggler-icon"></span>
			</button>
			<div class="collapse navbar-collapse" id="navbarNav">
				<ul class="navbar-nav me-auto">
					<li class="nav-item">
						<a class="nav-link <%=thisPage.equals("order") ? "active":""%>" href="${pageContext.request.contextPath }/order/list.jsp">발주신청</a>
					</li>
					<li class="nav-item">
						<a class="nav-link <%=thisPage.equals("board") ? "active":""%>" href="${pageContext.request.contextPath }/board/list.jsp">통합게시판</a>
					</li>
					<li class="nav-item">
						<a class="nav-link <%=thisPage.equals("work") ? "active":""%>" href="${pageContext.request.contextPath }/work-log/view-work_log.jsp">출퇴근</a>
					</li>
				</ul>
	            <!-- 오른쪽 사용자 메뉴 -->
	            <ul class="navbar-nav">
                <%if (userId != null) {%>
	                <li class="nav-item  me-2">
					    <a class="nav-link  p-0"
					       href="${pageContext.request.contextPath}/userp/userpinfo.jsp">
					        <strong><%=userId %></strong>
					    </a>
					</li>
	                <li class="nav-item me-2">
	                    <span class="navbar-text">님</span>
	                </li>
	                <li class="nav-item  me-2">
					    <a class="nav-link  p-0"
					       href="${pageContext.request.contextPath}/branchinfo/info2.jsp">
					        <strong><%=branchId %></strong> 점 정보변경
					    </a>
					</li>
	                <li class="nav-item">
	                    <a class="btn btn-danger btn-sm"
	                       href="${pageContext.request.contextPath }/userp/logout.jsp">로그아웃</a>
	                </li>
                <%}%>
                </ul>
			</div>
		</div>
	</nav>