<%@page import="dao.HrmDao"%>
<%@page import="dto.HrmDto"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    request.setCharacterEncoding("UTF-8");

    int num = Integer.parseInt(request.getParameter("num"));
    HrmDto dto = new HrmDao().getByNum(num);

    if (dto == null) {
        out.println("ERROR: dto가 null입니다. 데이터를 확인하세요.");
        return;
    }

    String contextPath = request.getContextPath();
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>프로필 이미지 등록</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<style>
    .form-container {
        max-width: 650px;
        margin: 50px auto;
        background: white;
        padding: 30px;
        border-radius: 8px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    }
    .form-container h1 {
        text-align: center;
        margin-bottom: 30px;
        font-weight: bold;
    }
    .profile-img {
        max-width: 200px;
        max-height: 200px;
        border: 1px solid #ddd;
        border-radius: 4px;
        margin-bottom: 15px;
    }
    .btn-primary {
        background-color: #003366 !important;
        border-color: #003366 !important;
        color: white !important;
        font-weight: 500;
        border-radius: 6px;
        box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
    }
    .btn-primary:hover {
        background-color: #002244 !important;
        border-color: #002244 !important;
    }
    .btn-cancel {
        background-color: #7f8c8d;
        color: white;
        font-weight: 600;
        border-radius: 6px;
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
    <li class="breadcrumb-item"><a href="<%= contextPath %>/headquater.jsp">홈</a></li>
    <li class="breadcrumb-item active" aria-current="page">직원 관리</li>
    <li class="breadcrumb-item"><a href="<%= contextPath %>/headquater.jsp?page=hrm/list.jsp">직원 목록</a></li>
    <li class="breadcrumb-item active" aria-current="page">프로필 이미지 등록</li>
  </ol>
</nav>

<div class="form-container">
    <h1>프로필 이미지 등록</h1>
    <form action="<%= contextPath %>/hrm/register" method="post" enctype="multipart/form-data">

        <input type="hidden" name="num" value="<%= dto.getNum() %>">

        <div class="mb-3">
            <label class="form-label">이름</label>
            <input type="text" class="form-control" value="<%= dto.getName() %>" readonly>
        </div>

        <div class="mb-3">
            <label class="form-label">직급</label>
            <input type="text" class="form-control" value="<%= dto.getRole() %>" readonly>
        </div>

        <div class="mb-3">
            <label class="form-label">기존 이미지</label><br/>
            <% if (dto.getProfileImage() != null && !dto.getProfileImage().isEmpty()) { %>
                <img src="<%= contextPath %>/image?name=<%= dto.getProfileImage() %>" class="profile-img" alt="프로필 이미지">
            <% } else { %>
                <p class="text-muted">이미지가 없습니다.</p>
            <% } %>
        </div>

        <div class="mb-3">
            <label class="form-label">이미지 변경</label>
            <input type="file" name="profile_image" accept="image/*" class="form-control">
        </div>

        <div class="d-flex justify-content-between">
            <button type="submit" class="btn btn-primary">수정 확인</button>
            <button type="button" class="btn btn-cancel" onclick="location.href='<%= contextPath %>/headquater.jsp?page=hrm/detail.jsp&num=<%= dto.getNum() %>';">취소</button>
        </div>
    </form>
</div>

</body>
</html>
