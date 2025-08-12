<%@page import="dao.BranchDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String branchId = BranchDao.getInstance().generate();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/branch-admin/insert-form.jsp</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />

<style>
    .form-container {
        max-width: 600px;
        margin: 50px auto;
        background: white;
        padding: 30px;
        border-radius: 8px;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    }
    .form-container h1 {
        text-align: center;
        margin-bottom: 30px;
        font-weight: bold;
    }
    .btn-submit {
        background-color: #003366 !important;
        border-color: #003366 !important;
        color: white !important;
        font-weight: 600;
    }
    .btn-submit:hover {
        background-color: #002244 !important;
        border-color: #002244 !important;
        color: white !important;
    }
    .btn-cancel {
        background-color: #7f8c8d;
        color: white;
        font-weight: 600;
    }
    .btn-cancel:hover {
        background-color: #636e72;
    }
</style>
</head>
<body>

<!-- breadcrumb -->
<nav aria-label="breadcrumb" class="mb-3" style="margin: 0 15px;">
  <ol class="breadcrumb">
    <li class="breadcrumb-item"><a href="<%=request.getContextPath()%>/headquater.jsp">홈</a></li>
    <li class="breadcrumb-item active" aria-current="page">지점 관리</li>
    <li class="breadcrumb-item active" aria-current="page">지점 등록</li>
  </ol>
</nav>

<div class="form-container">
    <h1>지점 등록</h1>
    <form action="<%=request.getContextPath()%>/headquater.jsp" method="post">
        <input type="hidden" name="page" value="branch-admin/insert.jsp" />

        <div class="mb-3">
            <label class="form-label" for="branchId">지점 아이디</label>
            <input class="form-control" type="text" name="branchId" id="branchId" value="<%=branchId%>" readonly />
            <div class="form-text text-muted" style="font-size: 0.75rem;">지점 아이디는 수정할 수 없습니다.</div>
        </div>

        <div class="mb-3">
            <label class="form-label" for="name">지점 이름</label>
            <input class="form-control" type="text" name="name" id="name" placeholder="지점 이름을 입력하세요" />
        </div>

        <div class="mb-3">
            <label class="form-label" for="address">지점 주소</label>
            <input class="form-control" type="text" name="address" id="address" placeholder="지점 주소를 입력하세요" />
        </div>

        <div class="mb-3">
            <label class="form-label" for="phone">지점 연락처</label>
            <input class="form-control" type="text" name="phone" id="phone" placeholder="예: 02-1234-5678" />
        </div>

        <div class="d-flex justify-content-end">
            <button type="button" class="btn btn-cancel me-2" onclick="history.back()">취소</button>
            <button class="btn btn-submit" type="submit">등록</button>
        </div>
    </form>
</div>

</body>
</html>
