<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>본사 인덱스 페이지</title>
<style>
    /* 직원 상세 스타일 */
    .hrm-detail-table {
        margin: 0 auto;
        border-collapse: collapse;
        width: 80%;
        max-width: 700px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        background-color: white;
        border-radius: 8px;
        overflow: hidden;
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        color: #333;
    }
    .hrm-detail-table th, .hrm-detail-table td {
        padding: 14px 20px;
        text-align: left;
        border-bottom: 1px solid #ddd;
        font-size: 1rem;
    }
    .hrm-detail-table th {
        background-color: #34495e;
        color: #ecf0f1;
        font-weight: 600;
        width: 150px;
    }
    .hrm-detail-table tr:hover {
        background-color: #f1f8ff;
    }
    .hrm-img {
        display: block;
        margin: 0 auto;
        max-width: 150px;
        height: auto;
        border-radius: 8px;
        box-shadow: 0 2px 6px rgba(0,0,0,0.15);
    }
    .btn-link {
        display: inline-block;
        margin: 20px auto;
        padding: 10px 25px;
        background-color: #2980b9;
        color: white;
        text-decoration: none;
        font-weight: 600;
        border-radius: 5px;
        transition: background-color 0.3s ease;
    }
    .btn-link:hover {
        background-color: #1c5980;
    }
    .btn-back {
        background-color: #7f8c8d;
    }
    .btn-back:hover {
        background-color: #636e72;
    }
    .error-message {
        text-align: center;
        color: #e74c3c;
        font-weight: 700;
        font-size: 1.2rem;
        margin-top: 50px;
    }
    .btn-container {
        text-align: center;
        margin-top: 30px;
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
	    if (pages == null || pages.isEmpty()) {
	        pages = "/index/headquaterindex.jsp";
	    } else if (!pages.startsWith("/")) {
	        pages = "/" + pages;
	    }
	    pageContext.include(pages);
    %>
    </main>

  </div>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
  
</body>
</html>
