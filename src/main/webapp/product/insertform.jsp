<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>상품 등록</title>
</head>
<body>
	<h1>상품 등록</h1>
	<form action="${pageContext.request.contextPath}/product/register" method="post" enctype="multipart/form-data" onsubmit="return validateForm()">


		<div>
			<label>상품명:</label>
			<input type="text" name="name">
		</div>
		<div>
			<label>설명:</label>
			<input type="text" name="description">
		</div>
		<div>
			<label>가격:</label>
			<input type="text" name="price">
		</div>
		<div>
			<label>상태:</label>
			<select name="status">
				<option value="일반">일반</option>
				<option value="기간 한정">기간 한정</option>
				<option value="이벤트">이벤트</option>
				<option value="판매 중지">판매 중지</option>
				<option value="판매 종료">판매 종료</option>
			</select>
		</div>
		 <div>
			<label>상품 이미지:</label>
			<input type="file" name="imagePath" accept="image/*">
		</div> 
		<button type="submit">등록</button>
	</form>
	
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
    return true;
}
</script>
	
</body>
</html>