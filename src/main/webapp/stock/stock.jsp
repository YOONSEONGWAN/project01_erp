<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>재고 관리 메인</title>
<jsp:include page="/WEB-INF/include/resource.jsp"/>
<style>
    .menu-box {
        display: flex;
        justify-content: center;
        gap: 30px;
        margin-top: 50px;
        flex-wrap: wrap;
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

    .bg-gray { background-color: #6c757d; }   /* Bootstrap 'secondary' 색상 */
    .bg-blue { background-color: #007bff; }   /* Bootstrap 'primary' 색상 */
    .bg-green { background-color: #28a745; }  /* Bootstrap 'success' 색상 */

</style>
</head>
<body class="bg-light">

    <div class="container text-center py-5">
        <h1 class="fw-bold mb-3">재고 관리 시스템</h1>
        <p class="text-muted">원하는 메뉴를 선택하세요</p>

        <div class="menu-box">
            <a href="stocklist.jsp" class="menu-card bg-gray">
                재고 리스트
            </a>
            <a href="inandout.jsp" class="menu-card bg-blue">
                입고 / 출고
            </a>
            <a href="placeorder.jsp" class="menu-card bg-green">
            	발주
            </a>
        </div>
    </div>

</body>
</html>