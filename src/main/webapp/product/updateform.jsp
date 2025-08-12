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
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <style>
        html, body {
            margin: 0; padding: 0; height: 100%; width: 100%;
        }
        body {
            padding: 0 !important;
            background-color: #f8f9fa;
        }
        .container {
            max-width: 600px !important;
            margin: 30px auto !important;
            padding: 0 15px !important;
        }
        .card {
            border-radius: 8px;
            box-shadow: 0 4px 8px rgb(0 0 0 / 0.1);
            background: white;
        }
        .card-header {
            background-color: #003366;
            color: white;
            font-weight: 600;
            font-size: 1.5rem;
            padding: 1rem 1.5rem;
            border-radius: 8px 8px 0 0;
        }
        .card-body {
            padding: 1.5rem;
        }
        .btn-submit {
            background-color: #003366;
            color: white;
            border-radius: 6px;
            padding: 8px 20px;
            border: none;
            font-weight: 600;
            box-shadow: 0 2px 6px rgba(0,51,102,0.5);
            transition: background-color 0.3s ease;
        }
        .btn-submit:hover {
            background-color: #002244;
            color: white;
        }
        .btn-cancel {
            background-color: #6c757d;
            color: white;
            border-radius: 6px;
            padding: 8px 20px;
            border: none;
            font-weight: 600;
            transition: background-color 0.3s ease;
        }
        .btn-cancel:hover {
            background-color: #5a6268;
            color: white;
        }
        img.product-img {
            max-width: 200px;
            margin-bottom: 15px;
            border: 1px solid #ddd;
            border-radius: 4px;
            display: block;
        }
    </style>
</head>
<body>

<div class="container">
    <div class="card">
        <div class="card-header">
            상품 수정
        </div>
        <div class="card-body">
            <form action="<%=request.getContextPath()%>/product/update" method="post" enctype="multipart/form-data" onsubmit="return validateForm()">
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
                        <img src="<%=request.getContextPath()%>/image?name=<%= dto.getImagePath() %>" alt="상품 이미지" class="product-img" />
                    <% } else { %>
                        <p class="text-muted">이미지가 없습니다.</p>
                    <% } %>
                    <input type="file" name="imagePath" class="form-control" accept="image/*">
                </div>

                <div class="d-flex justify-content-end gap-2">
                    <button type="button" class="btn-cancel" onclick="window.location.href='<%=request.getContextPath()%>/headquater.jsp?page=product/list.jsp'">취소</button>
                    <button type="submit" class="btn-submit">수정 확인</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
function validateForm() {
    const form = document.forms[0];
    const name = form["name"].value.trim();
    const description = form["description"].value.trim();
    const price = form["price"].value.trim();
    const status = form["status"].value.trim();

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

    return confirm("수정 하시겠습니까?");
}
</script>

<script>
  document.addEventListener('DOMContentLoaded', function() {
    // 무조건 productMenu 열기
    const productMenu = document.getElementById('productMenu');
    if(productMenu && !productMenu.classList.contains('open')) {
      productMenu.classList.add('open');
      productMenu.style.height = 'auto';
      const toggleBtn = document.getElementById('toggleProductMenu');
      if(toggleBtn) {
        toggleBtn.querySelectorAll('i')[0].className = 'bi bi-caret-down-fill';
        toggleBtn.querySelectorAll('i')[1].className = 'bi bi-folder2-open';
      }
    }
  });
</script>


</body>
</html>
