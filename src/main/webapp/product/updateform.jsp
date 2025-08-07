<%@page import="dao.ProductDao"%>
<%@page import="dto.ProductDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    request.setCharacterEncoding("UTF-8");

    String numStr = request.getParameter("num");
    if (numStr == null || numStr.isEmpty()) {
        out.println("<h2 class='text-danger text-center mt-5'>⚠ 잘못된 접근입니다: 상품 번호가 없습니다.</h2>");
        return;
    }

    int num = Integer.parseInt(numStr);
    ProductDto dto = new ProductDao().getByNum(num);

    if (dto == null) {
        out.println("<h2 class='text-danger text-center mt-5'>⚠ 해당 상품이 존재하지 않습니다.</h2>");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>상품 정보 수정</title>
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
    .product-img {
        max-width: 200px;
        max-height: 200px;
        border: 1px solid #ddd;
        border-radius: 4px;
    }

    /* 상품 목록 검색 버튼 스타일과 동일하게 수정 */
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
        color: white !important;
    }

    /* 취소 버튼 스타일 유지 */
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
<!-- breadcrumb 추가 시작 -->
    <nav aria-label="breadcrumb" class="mb-3" style="margin: 0 15px;">
      <ol class="breadcrumb">
        <li class="breadcrumb-item"><a href="<%=request.getContextPath()%>/headquater.jsp">홈</a></li>
        <li class="breadcrumb-item"><a href="<%=request.getContextPath()%>/headquater.jsp?page=product/list.jsp">상품 목록</a></li>
        <li class="breadcrumb-item active" aria-current="page">상품 정보 수정</li>
      </ol>
    </nav>
    <!-- breadcrumb 추가 끝 -->

<div class="form-container">
    <h1>상품 정보 수정</h1>
    <form action="<%= request.getContextPath() %>/product/update" method="post" enctype="multipart/form-data" onsubmit="return validateForm()">
        
        <!-- 숨겨진 상품 번호 -->
        <input type="hidden" name="num" value="<%= dto.getNum() %>">

        <div class="mb-3">
            <label for="name" class="form-label">상품명</label>
            <input type="text" name="name" id="name" value="<%= dto.getName() %>" class="form-control" required>
        </div>

        <div class="mb-3">
            <label for="description" class="form-label">설명</label>
            <input type="text" name="description" id="description" value="<%= dto.getDescription() %>" class="form-control" required>
        </div>

        <div class="mb-3">
            <label for="price" class="form-label">가격</label>
            <input type="text" name="price" id="price" value="<%= dto.getPrice() %>" class="form-control" required>
        </div>

        <div class="mb-3">
            <label for="status" class="form-label">상태</label>
            <select name="status" id="status" class="form-select" required>
                <option value="일반" <%= "일반".equals(dto.getStatus()) ? "selected" : "" %>>일반</option>
                <option value="기간 한정" <%= "기간 한정".equals(dto.getStatus()) ? "selected" : "" %>>기간 한정</option>
                <option value="이벤트" <%= "이벤트".equals(dto.getStatus()) ? "selected" : "" %>>이벤트</option>
                <option value="판매 중지" <%= "판매 중지".equals(dto.getStatus()) ? "selected" : "" %>>판매 중지</option>
                <option value="판매 종료" <%= "판매 종료".equals(dto.getStatus()) ? "selected" : "" %>>판매 종료</option>
            </select>
        </div>

        <div class="mb-3">
            <label class="form-label">기존 이미지</label><br/>
            <% if (dto.getImagePath() != null && !dto.getImagePath().isEmpty()) { %>
                <img src="<%= request.getContextPath() + "/image?name=" + dto.getImagePath() %>" alt="기존 이미지" class="product-img">
            <% } else { %>
                <p class="text-muted">이미지가 없습니다.</p>
            <% } %>
        </div>

        <div class="mb-3">
            <label for="imagePath" class="form-label">새 이미지 선택</label>
            <input type="file" name="imagePath" id="imagePath" class="form-control" accept="image/*">
        </div>

        <div class="d-flex justify-content-between">
            <!-- 수정 확인 버튼 스타일 변경 -->
            <button type="submit" class="btn btn-primary">수정 확인</button>
            <button type="button" class="btn btn-cancel" onclick="window.location.href='<%=request.getContextPath()%>/headquater.jsp?page=product/list.jsp'">취소</button>
        </div>
    </form>
</div>

<script>
function validateForm() {
    const name = document.getElementById('name').value.trim();
    const description = document.getElementById('description').value.trim();
    const price = document.getElementById('price').value.trim();
    const status = document.getElementById('status').value.trim();

    if (!name) {
        alert('상품명을 입력해주세요.');
        return false;
    }
    if (!description) {
        alert('설명을 입력해주세요.');
        return false;
    }
    if (!price) {
        alert('가격을 입력해주세요.');
        return false;
    }
    if (isNaN(price) || Number(price) <= 0) {
        alert('가격은 0보다 큰 숫자로 입력해주세요.');
        return false;
    }
    if (!status) {
        alert('상태를 선택해주세요.');
        return false;
    }
    return true;
}
</script>

</body>
</html>
