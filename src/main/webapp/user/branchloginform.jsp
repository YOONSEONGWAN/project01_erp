<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    // GET 형식 파라미터 url이 있는지 확인
    String url = request.getParameter("url");
    if(url == null || url.equals("")){
        url = request.getContextPath() + "/order/list.jsp"; // 기본 이동 경로
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>지점 로그인</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<div class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-md-5">
            <div class="card shadow">
                <div class="card-header bg-primary text-white text-center">
                    <h4>지점 로그인</h4>
                </div>
                <div class="card-body">
                    <form action="branchlogin.jsp" method="post">
                        <!-- 로그인 성공 후 이동할 URL -->
                        <input type="hidden" name="url" value="<%=url%>"/>

                        <!-- 아이디 -->
                        <div class="mb-3">
                            <label for="user_id" class="form-label">아이디</label>
                            <input type="text" name="user_id" id="user_id" class="form-control" required>
                        </div>

                        <!-- 비밀번호 -->
                        <div class="mb-3">
                            <label for="password" class="form-label">비밀번호</label>
                            <input type="password" name="password" id="password" class="form-control" required>
                        </div>

                        <button type="submit" class="btn btn-primary w-100">로그인</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>
