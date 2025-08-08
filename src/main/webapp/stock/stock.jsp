<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <title>발주 관리</title>
    <!-- Bootstrap CSS CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <style>
        body {
            background-color: #f8f9fa;
        }
        .container {
            max-width: 480px;
            margin: 100px auto 0;
            text-align: center;
        }
        h1 {
            font-weight: 700;
            margin-bottom: 8px;
            color: #333;
        }
        p.subtitle {
            color: #666;
            margin-bottom: 40px;
            font-size: 1rem;
        }
        .btn-large {
            display: inline-block;
            width: 180px;
            height: 180px;
            line-height: 180px;
            margin: 0 10px;
            font-size: 1.3rem;
            font-weight: 700;
            color: white;
            border-radius: 12px;
            text-decoration: none;
            user-select: none;
            transition: background-color 0.3s ease;
        }
        .btn-large:hover {
            opacity: 0.85;
            text-decoration: none;
        }
        .btn-stock-list {
            background-color: #6c757d; /* 짙은 회색 */
        }
        .btn-inout {
            background-color: #007bff; /* 파란색 */
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>재고 관리 메뉴</h1>
        <!-- 필요하면 설명 텍스트 넣어도 됨 -->
        <p class="subtitle">&nbsp;</p>

        <a href="${pageContext.request.contextPath}/headquater.jsp?page=/stock/stocklist.jsp" class="btn-large btn-stock-list">재고 현황</a>
        <a href="${pageContext.request.contextPath}/headquater.jsp?page=/stock/inandout.jsp" class="btn-large btn-inout"> 입고 / 출고</a>
    	
    </div>
    
    <div class="text-center mt-4">
    	<a href="${pageContext.request.contextPath}/headquater.jsp" class="btn btn-outline-secondary">
        뒤로 가기
    	</a>
	</div>

    <!-- Bootstrap JS Bundle (Popper 포함) -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>