<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>ERP 인덱스</title>
<jsp:include page="/WEB-INF/include/resource.jsp"></jsp:include>
<style>
    body {
        background-color: #e9edf0;
        margin: 0;
        font-family: 'Noto Sans KR', sans-serif;
        display: flex;
        justify-content: center;
        align-items: center;
        height: 100vh;
    }

    .portal-card {
        background-color: #ffffff;
        padding: 40px 60px;
        border-radius: 12px;
        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
        text-align: center;
        width: 400px;
    }

    .portal-card .logo {
        display: block;
        margin: 0 auto 30px;
        width: 250px;
    }

    .portal-title {
        font-size: 20px;
        font-weight: bold;
        color: #333333;
        margin-bottom: 25px;
    }

    .btn-primary {
        background-color: #003366;
        border-color: #003366;
        font-weight: 500;
        border-radius: 6px;
        box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
    }

    .btn-primary:hover {
        background-color: #002244;
        border-color: #002244;
    } 
    

</style>
</head>
<body>
    <div class="portal-card">
        <img src="${pageContext.request.contextPath}/images/JB_logo.png" alt="치킨 로고" class="logo">
        <div class="portal-title">ERP 시스템 포털</div>
        <div class="d-grid gap-3">
            <a href="${pageContext.request.contextPath}/userp/loginform.jsp" class="btn btn-primary py-2">로그인</a>
            <a href="${pageContext.request.contextPath}/userp/signup-form.jsp" class="btn btn-primary py-2">회원가입</a>
        </div>
    </div>
</body>
</html>