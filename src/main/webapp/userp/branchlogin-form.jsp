<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>지점 로그인</title>
<jsp:include page="/WEB-INF/include/resource.jsp"></jsp:include>
<style>
    body {
        margin: 0;
        height: 100vh;
        background-color: #f0f2f5;
        display: flex;
        justify-content: center;
        align-items: center;
        font-family: 'Noto Sans KR', sans-serif;
    }
    .login-card {
        background-color: white;
        padding: 40px 50px;
        border-radius: 12px;
        box-shadow: 0 6px 25px rgba(0, 40, 85, 0.2);
        width: 380px;
    }
    .login-card h1 {
        text-align: center;
        color: #002855;
        margin-bottom: 30px;
        font-weight: 700;
        font-size: 28px;
        letter-spacing: 1.2px;
    }
    .btn-primary {
        background-color: #002855;
        border-color: #002855;
        font-weight: 700;
        border-radius: 10px;
    }
    .btn-primary:hover {
        background-color: #001f3f;
        border-color: #001f3f;
        box-shadow: 0 0 12px #001f3f;
    }
</style>
</head>
<body>
    <div class="login-card">
        <h1>지점 로그인</h1>
        <form action="branchlogin.jsp" method="post">
            <div class="mb-3">
                <label for="branchId" class="form-label">지점 코드</label>
                <input type="text" class="form-control" id="branchId" name="branchId" required>
            </div>
            <div class="mb-3">
                <label for="userId" class="form-label">아이디</label>
                <input type="text" class="form-control" id="userId" name="userId" required>
            </div>
            <div class="mb-3">
                <label for="password" class="form-label">비밀번호</label>
                <input type="password" class="form-control" id="password" name="password" required>
            </div>
            <button type="submit" class="btn btn-primary w-100 py-2">로그인</button>
        </form>
    </div>
</body>
</html>