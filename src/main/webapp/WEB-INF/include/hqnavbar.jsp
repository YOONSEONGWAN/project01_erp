<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%-- /WEB-INF/include/branchnavbar.jsp --%>
<% 
	String thisPage = request.getParameter("thisPage");
	String userId = (String)session.getAttribute("userId");
%>
	<nav class="navbar navbar-expand-md bg-success" data-bs-theme="dark">
		<div class="container">
			<a class="navbar-brand" href="${pageContext.request.contextPath }/index/headquaterindex.jsp">종복치킨</a>
			<button class="navbar-toggler" type="button"
				data-bs-toggle="collapse" data-bs-target="#navbarNav">
				<span class="navbar-toggler-icon"></span>
			</button>
			<div class="collapse navbar-collapse" id="navbarNav">
				<ul class="navbar-nav me-auto">
					<li class="nav-item">
						<a class="nav-link <%=thisPage.equals("product") ? "active":""%>" href="${pageContext.request.contextPath }/product/main.jsp">상품관리</a>
					</li>
					<li class="nav-item">
						<a class="nav-link <%=thisPage.equals("sales") ? "active":""%>" href="${pageContext.request.contextPath }/headquater/sales.jsp">매출/회계</a>
					</li>
					<li class="nav-item">
						<a class="nav-link <%=thisPage.equals("stock") ? "active":""%>" href="${pageContext.request.contextPath }/headquater/stock.jsp">재고</a>
					</li>
					<li class="nav-item">
						<a class="nav-link <%=thisPage.equals("branch-admin") ? "active":""%>" href="${pageContext.request.contextPath }/branch-admin/main.jsp">지점관리</a>
					</li>
				</ul>
	            <!-- 오른쪽 사용자 메뉴 -->
	            <ul class="navbar-nav">
                <%if (userId != null) {%>	                
	                <li class="nav-item  me-2">
					    <a class="nav-link  p-0"
					       href="${pageContext.request.contextPath}/userp/userinfo.jsp">
					        <strong><%=userId %></strong>
					    </a>
					</li>
	                <li class="nav-item me-2">
	                    <span class="navbar-text">님</span>
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