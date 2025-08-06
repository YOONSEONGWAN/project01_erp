<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>지점 인덱스 페이지</title>
<jsp:include page="/WEB-INF/include/resource.jsp"></jsp:include>
</head>
<body>
	<!-- 네비바 -->
	<jsp:include page="/WEB-INF/include/navbar.jsp" />
	<div class="d-flex">

		<!-- 사이드바 -->
		<jsp:include page="/WEB-INF/include/sidebar2.jsp" />

		<!-- 메인 컨텐츠 -->
		<main class="flex-grow-1 p-3">
			<%
				String pages = request.getParameter("page");
				if (pages == null || pages.isEmpty()) {
					pages = "/index/branchindex.jsp";
				} else if (!pages.startsWith("/")) {
					pages = "/" + pages;
				}
				pageContext.include(pages);
			%>
		</main>

	</div>
</body>
</html>