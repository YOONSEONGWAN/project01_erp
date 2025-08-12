<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <title>발주 관리</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
</head>
<style>
    body {
        background-color: #f8f9fa;
    }
    .container {
        max-width: 600px;
        margin: 120px auto 0;
        text-align: center;
    }
    h1 {
        font-weight: 700;
        margin-bottom: 12px;
        color: #000;
    }
    p.subtitle {
        color: #666;
        margin-bottom: 48px;
        font-size: 1rem;
    }

    .btn-large {
        display: inline-flex;
        justify-content: center;
        align-items: center;
        width: 200px;
        height: 200px;
        font-size: 1.3rem;
        font-weight: 600;
        color: white;
        border-radius: 16px;
        text-decoration: none;
        user-select: none;
        margin: 0 16px;
        transition: all 0.3s ease;
        box-shadow: 0 4px 12px rgba(0,0,0,0.1);
    }

    .btn-large:hover {
        opacity: 0.9;
        text-decoration: none;
    }

    .btn-stock-list {
        background-color: #003366; /* 기준 남색 */
    }

    .btn-stock-list:hover {
        background-color: #002244;
    }

    .btn-inout {
        background-color: #6c757d; /* Bootstrap secondary */
    }

    .btn-inout:hover {
        background-color: #5c636a; /* Bootstrap secondary hover */
    }

    @media (max-width: 576px) {
        .btn-large {
            width: 100%;
            height: 140px;
            margin-bottom: 20px;
        }
    }
</style>
<body>
    <div class="container">
        <h1>발주 관리 메뉴</h1>
        <p class="subtitle">&nbsp;</p>

        <div class="d-flex justify-content-center flex-wrap gap-3">
            <a href="${pageContext.request.contextPath}/headquater.jsp?page=/stock/placeorder_head.jsp" class="btn-large btn-stock-list">
                본사 발주 관리
            </a>
            <a href="${pageContext.request.contextPath}/headquater.jsp?page=/stock/placeorder_branch.jsp" class="btn-large btn-inout">
                지점 발주 관리
            </a>
        </div>
    </div>

    <!-- Bootstrap JS Bundle (Popper 포함) -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>