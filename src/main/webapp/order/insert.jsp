<%@page import="java.util.List"%>
<%@page import="dto.IngredientDto"%>
<%@page import="dao.IngredientDao"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String branchId = (String)session.getAttribute("branchId"); // 지점 로그인 세션
	List<IngredientDto> ingredientList = IngredientDao.getInstance().selectAll();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>발주 요청</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-4">
	<h2>재고 발주 요청</h2>
	<form action="insert-process.jsp" method="post">
		<input type="hidden" name="branchId" value="<%=branchId %>"/>
		
		<div class="mb-3">
			<label for="ingredientId" class="form-label">재료 선택</label>
			<select name="ingredientId" id="ingredientId" class="form-select" required>
				<option value="">-- 선택하세요 --</option>
				<% for(IngredientDto dto : ingredientList){ %>
					<option value="<%=dto.getIngredientId()%>">
						<%=dto.getName()%> (<%=dto.getUnit()%>)
					</option>
				<% } %>
			</select>
		</div>
		
		<div class="mb-3">
			<label for="quantity" class="form-label">수량</label>
			<input type="number" name="quantity" id="quantity" class="form-control" required min="1"/>
		</div>
		
		<button type="submit" class="btn btn-primary">발주 요청</button>
		<a href="list.jsp" class="btn btn-secondary">목록으로</a>
	</form>
</div>
</body>
</html>
