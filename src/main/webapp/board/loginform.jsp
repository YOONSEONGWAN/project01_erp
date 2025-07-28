<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>/board/loginform.jsp</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
  <div class="container mt-5" style="max-width: 400px;">
    <h3 class="mb-4 text-center">로그인</h3>
    <form action="login.jsp" method="post">
      <div class="mb-3">
        <label class="form-label">아이디</label>
        <input type="text" name="id" class="form-control" required>
      </div>
      <div class="mb-3">
        <label class="form-label">비밀번호</label>
        <input type="password" name="pwd" class="form-control" required>
      </div>
      <button type="submit" class="btn btn-primary w-100">로그인</button>
    </form>
  </div>
</body>
</html>