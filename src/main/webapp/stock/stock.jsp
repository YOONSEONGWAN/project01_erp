<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>재고 관리 메인</title>
<jsp:include page="/WEB-INF/include/resource.jsp"/>
<!-- 부트스트랩 CDN이 resource.jsp에 없다면 아래 추가하세요 -->
<!-- <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"> -->

<style>
    html, body {
        height: 100%;
        margin: 0;
        padding: 0;
    }

    body {
        background-color: #f8f9fa; /* Bootstrap의 bg-light */
    }

    .main-wrapper {
        min-height: calc(100vh - 70px); /* 네비바 높이 고려 (예: 70px) */
        display: flex;
        justify-content: center;
        align-items: center;
        padding-top: 70px; /* 네비바 높이만큼 위쪽 여백 확보 */
        padding-bottom: 30px;
    }

    .menu-box {
        display: flex;
        justify-content: center;
        gap: 30px;
        flex-wrap: wrap;
        margin-top: 30px;
    }

    .menu-card {
        width: 180px;
        height: 200px;
        border-radius: 12px;
        color: white;
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        font-weight: bold;
        font-size: 1.2rem;
        text-decoration: none;
        transition: transform 0.2s ease-in-out;
    }

    .menu-card:hover {
        transform: scale(1.05);
        text-decoration: none;
    }

    .bg-gray { background-color: #6c757d; }   /* Bootstrap 'secondary' */
    .bg-blue { background-color: #007bff; }   /* Bootstrap 'primary' */
    .bg-green { background-color: #28a745; }  /* Bootstrap 'success' */
</style>
</head>
<body>

    <!-- 나중에 네비바가 들어올 자리 -->
    <!-- <jsp:include page="/WEB-INF/include/navbar.jsp" /> -->

    <div class="main-wrapper">
        <div class="container text-center">
            <h1 class="fw-bold mb-3">재고 관리 시스템</h1>
            <p class="text-muted">원하는 메뉴를 선택하세요</p>

            <div class="menu-box">
                <a href="stocklist.jsp" class="menu-card bg-gray">
                    재고 리스트
                </a>
                <a href="inandout.jsp" class="menu-card bg-blue">
                    입고 / 출고
                </a>
            </div>
        </div>
    </div>

</body>
</html>