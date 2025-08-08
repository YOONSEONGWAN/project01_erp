<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>지점 인덱스 페이지</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.7/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-LN+7fdVzj6u52u30Kp6M/trliBMCMKTyK833zpbD+pXdCLuTusPj697FH4R/5mcr" crossorigin="anonymous">
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
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.7/dist/js/bootstrap.bundle.min.js" integrity="sha384-ndDqU0Gzau9qJ1lfW4pNLlhNTkCfHzAVBReH9diLvGRem5+R9g2FzA8ZGN954O5Q" crossorigin="anonymous"></script>
</body>
</html>