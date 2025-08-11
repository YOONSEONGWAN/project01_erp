<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dto.ProductDto" %>
<%
    ProductDto dto = (ProductDto) request.getAttribute("dto");
    if (dto == null) {
        out.println("상품 정보가 없습니다.");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>상품 수정</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

<style>
    .form-container {
        max-width: 600px;
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
    <li class="breadcrumb-item active" aria-current="page">상품 관리</li>
    <li class="breadcrumb-item"><a href="<%=request.getContextPath()%>/headquater.jsp?page=product/list.jsp">상품 목록</a></li>
    <li class="breadcrumb-item active" aria-current="page">상품 수정</li>
  </ol>
</nav>

<div class="form-container">
    <h1>상품 수정</h1>
    <form action="<%=request.getContextPath()%>/product/update" method="post" enctype="multipart/form-data" onsubmit="return validateForm()">


        <!-- 상품 번호(hidden) -->
        <input type="hidden" name="num" value="<%= dto.getNum() %>">

        <div class="mb-3">
            <label class="form-label">상품명</label>
            <input type="text" name="name" class="form-control" value="<%= dto.getName() %>" placeholder="상품명을 입력하세요">
        </div>

        <div class="mb-3">
            <label class="form-label">설명</label>
            <input type="text" name="description" class="form-control" value="<%= dto.getDescription() %>" placeholder="상품 설명을 입력하세요">
        </div>

        <div class="mb-3">
            <label class="form-label">가격</label>
            <input type="text" name="price" class="form-control" value="<%= dto.getPrice() %>" placeholder="가격을 입력하세요">
        </div>

        <div class="mb-3">
            <label class="form-label">상태</label>
            <select name="status" class="form-select">
                <option value="">-- 상태 선택 --</option>
                <option value="일반" <%= "일반".equals(dto.getStatus()) ? "selected" : "" %>>일반</option>
                <option value="기간 한정" <%= "기간 한정".equals(dto.getStatus()) ? "selected" : "" %>>기간 한정</option>
                <option value="이벤트" <%= "이벤트".equals(dto.getStatus()) ? "selected" : "" %>>이벤트</option>
                <option value="판매 중지" <%= "판매 중지".equals(dto.getStatus()) ? "selected" : "" %>>판매 중지</option>
                <option value="판매 종료" <%= "판매 종료".equals(dto.getStatus()) ? "selected" : "" %>>판매 종료</option>
            </select>
        </div>

        <div class="mb-3">
            <label class="form-label">상품 이미지</label><br/>
            <% if (dto.getImagePath() != null && !dto.getImagePath().isEmpty()) { %>
                <img src="<%=request.getContextPath()%>/image?name=<%= dto.getImagePath() %>" alt="상품 이미지" style="max-width: 200px; margin-bottom: 10px; border: 1px solid #ddd; border-radius: 4px;">
            <% } else { %>
                <p class="text-muted">이미지가 없습니다.</p>
            <% } %>
            <input type="file" name="imagePath" class="form-control" accept="image/*">
        </div>

        <div class="d-flex justify-content-end gap-2">
            <button type="button" class="btn btn-cancel" onclick="window.location.href='<%=request.getContextPath()%>/headquater.jsp?page=product/list.jsp'">취소</button>
            <button type="submit" class="btn btn-submit">수정 확인</button>
        </div>
    </form>
</div>

<script>
function validateForm() {
    const name = document.forms[0]["name"].value.trim();
    const description = document.forms[0]["description"].value.trim();
    const price = document.forms[0]["price"].value.trim();
    const status = document.forms[0]["status"].value.trim();

    if (!name) {
        alert("상품명을 입력해주세요.");
        return false;
    }
    if (!description) {
        alert("설명을 입력해주세요.");
        return false;
    }
    if (!price) {
        alert("가격을 입력해주세요.");
        return false;
    }
    if (isNaN(price) || Number(price) <= 0) {
        alert("가격은 0보다 큰 숫자로 입력해주세요.");
        return false;
    }
    if (!status) {
        alert("상태를 선택해주세요.");
        return false;
    }

    // 여기서 수정 확인창 추가
    return confirm("수정 하시겠습니까?");
}
</script>


</body>
</html>
