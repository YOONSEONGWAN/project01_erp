<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>본사 인덱스 페이지</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
<style>
  body {
    background-color: #f8f9fa;
  }
</style>
</head>
<body>
  <!-- 네비바 -->
  <jsp:include page="/WEB-INF/include/navbar.jsp" />

  <div class="d-flex">
    <!-- 사이드바 -->
    <jsp:include page="/WEB-INF/include/sidebar.jsp" />

    <!-- 메인 컨텐츠 -->
    <main class="flex-grow-1 p-3">
      <%
        String pages = request.getParameter("page");
        String branchId = (String)session.getAttribute("branchId");

        if (pages == null || pages.isEmpty()) {
            if ("HQ".equals(branchId)) {
                pages = "/index/headquaterindex.jsp";
            } else if (branchId != null && branchId.startsWith("BC")) {
                pages = "/index/branchindex.jsp";
            } else {
                pages = "/index/error.jsp";
            }
        } else if (!pages.startsWith("/")) {
            pages = "/" + pages;
        }

        // 컨텐츠 페이지 include
        pageContext.include(pages);
      %>
    </main>
  </div>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
