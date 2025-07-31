<%@page import="dto.ProductDto"%>
<%@page import="dao.ProductDao"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%
	// 출력해줄 상품 목록 얻어오기
	List<ProductDto> list = new ProductDao().selectAll();
%>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/Product/list.jsp</title>
</head>
<body>
	<div class="container">
		<a href="insertform.jsp">상품 등록</a>
		<h1>상품 목록</h1>
		<table>
			<thead>
				<tr>
					<th>번호</th>
					<th>상품명</th>
					<th>설명</th>
					<th>가격</th>
					<th>상태</th>
					<th>수정</th>
					<th>삭제</th>
				</tr>
			</thead>
			<tbody>
			<%for(ProductDto dto : list){ %>
				<tr>
					<td><%=dto.getNum() %></td>
					<td>
    				  <a href="detail.jsp?num=<%=dto.getNum()%>">
        				<%=dto.getName()%>
      				</a>
					<td><%=dto.getDescription() %></td>
					<td><%=dto.getPrice() %></td>
					<td><%=dto.getStatus() %></td>
					<td><a href="updateform.jsp?num=<%=dto.getNum()%>">수정</a></td>	
					<td><a href="<%=request.getContextPath()%>/product/delete.jsp?num=<%=dto.getNum()%>" 
  					 onclick="return confirm('삭제하시겠습니까?');">삭제</a></td>	
				</tr>
			<%} %>
			</tbody>
		</table>
	</div>
</body>
</html>