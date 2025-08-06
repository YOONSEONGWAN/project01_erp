<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>발주 관리 메뉴</title>
  
    <style>
        .menu-button {
            width: 180px;
            height: 180px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 18px;
            font-weight: bold;
            border-radius: 12px;
            text-decoration: none;
            transition: all 0.3s ease;
        }

        .hq {
            background-color: #5a646e;
        }

        .branch {
            background-color: #0080ff;
        }

        .menu-button:hover {
            transform: scale(1.05);
            opacity: 0.9;
        }
    </style>
</head>
<body>

    <!-- 중앙 정렬 컨테이너 -->
    <div class="d-flex flex-column justify-content-center align-items-center min-vh-100">
        <div>
            <h1 class="mb-5 text-center">발주 관리 메뉴</h1>
            <div class="d-flex justify-content-center gap-4">
                <a href="${pageContext.request.contextPath}/stock/stock.jsp" class="menu-button hq">
                    재고 관리
                </a>
                <a href="${pageContext.request.contextPath}/stock/placeorder.jsp" class="menu-button branch">
                    발주 관리
                </a>
            </div>
        </div>
    </div>
</body>
</html>