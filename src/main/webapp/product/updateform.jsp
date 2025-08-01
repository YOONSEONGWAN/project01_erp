<%@page import="dao.ProductDao"%>
<%@page import="dto.ProductDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    request.setCharacterEncoding("UTF-8");

    String numStr = request.getParameter("num");
    if (numStr == null || numStr.isEmpty()) {
        out.println("<h2>⚠ 잘못된 접근입니다: 상품 번호가 없습니다.</h2>");
        return;
    }

    int num = Integer.parseInt(numStr);
    ProductDto dto = new ProductDao().getByNum(num);

    if (dto == null) {
        out.println("<h2>⚠ 해당 상품이 존재하지 않습니다.</h2>");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>상품 정보 수정</title>
</head>
<body>
    <div class="container">
        <h1>상품 정보 수정 양식</h1>
        <form action="<%= request.getContextPath() %>/product/update" method="post" enctype="multipart/form-data" onsubmit="return validateForm()">


            <!-- num은 숨겨서 보낸다 -->
            <input type="hidden" name="num" value="<%= dto.getNum() %>">

            <div>
                <label for="name">상품명</label>
                <input type="text" name="name" id="name" value="<%= dto.getName() %>" required>
            </div>

            <div>
                <label for="description">설명</label>
                <input type="text" name="description" id="description" value="<%= dto.getDescription() %>">
            </div>

            <div>
                <label for="price">가격</label>
                <input type="text" name="price" id="price" value="<%= dto.getPrice() %>" required>
            </div>

            <div>
                <label for="status">상태</label>
                <select name="status" id="status" required>
                    <option value="일반" <%= "일반".equals(dto.getStatus()) ? "selected" : "" %>>일반</option>
                    <option value="기간 한정" <%= "기간 한정".equals(dto.getStatus()) ? "selected" : "" %>>기간 한정</option>
                    <option value="이벤트" <%= "이벤트".equals(dto.getStatus()) ? "selected" : "" %>>이벤트</option>
                    <option value="판매 중지" <%= "판매 중지".equals(dto.getStatus()) ? "selected" : "" %>>판매 중지</option>
                    <option value="판매 종료" <%= "판매 종료".equals(dto.getStatus()) ? "selected" : "" %>>판매 종료</option>
                </select>
            </div>
		
		
            <div>
   			 <label>기존 이미지:</label><br/>
   				 <% if (dto.getImagePath() != null && !dto.getImagePath().isEmpty()) { %>
     			   <img src="<%= request.getContextPath() + "/image?name=" + dto.getImagePath() %>" alt="기존 이미지" style="max-width:200px; max-height:200px;">
   				 <% } else { %>
   				   <p>이미지가 없습니다.</p>
    			 <% } %>
			</div>

			<div>
			    <label for="imagePath">이미지 파일 선택</label>
			    <input type="file" name="imagePath" id="imagePath" accept="image/*">
			</div>
            <button type="submit">수정 확인</button>
			<button type="button" onclick="location.href='<%= request.getContextPath() %>/product/list.jsp'">취소</button>

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
		    return true;  // 모두 통과했으면 폼 제출 허용
		}
</script>
</body>
</html>
