<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    request.setCharacterEncoding("UTF-8");

    // 폼 데이터 받기
    String name = request.getParameter("name");
    String description = request.getParameter("description");
    int price = Integer.parseInt(request.getParameter("price"));
    String status = request.getParameter("status");
    String imagePath = request.getParameter("imagePath");

    // DTO, DAO 이용 DB 저장
    dto.ProductDto dto = new dto.ProductDto();
    dao.ProductDao dao = new dao.ProductDao();

    dto.setName(name);
    dto.setDescription(description);
    dto.setPrice(price);
    dto.setStatus(status);
    dto.setImagePath(imagePath);

    boolean isSuccess = dao.insert(dto);
%>

<!DOCTYPE html>
<html>
<head><meta charset="UTF-8"><title>상품 등록 결과</title></head>
<body>
<% if(isSuccess) { %>
    <p><strong><%=name%></strong> 상품이 성공적으로 등록되었습니다.</p>
    <a href="list.jsp">상품 목록 보기</a>
<% } else { %>
    <p>상품 등록에 실패했습니다.</p>
    <a href="insertform.jsp">다시 시도</a>
<% } %>
</body>
</html>
