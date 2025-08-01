<%@page import="dao.ProductDao"%>
<%@page import="dto.ProductDto"%>
<%@page import="jakarta.servlet.http.Part"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    request.setCharacterEncoding("UTF-8");

    int num = Integer.parseInt(request.getParameter("num"));
    String name = request.getParameter("name");
    String description = request.getParameter("description");
    int price = Integer.parseInt(request.getParameter("price"));
    String status = request.getParameter("status");

    // 이미지 관련
    Part filePart = null;
    try {
        filePart = request.getPart("imagePath");
    } catch (Exception e) {
        // Multipart 처리 안되는 경우 예외
        filePart = null;
    }

    String imageFileName = null;
    ProductDto oldDto = new ProductDao().getByNum(num);
    String oldImage = (oldDto != null) ? oldDto.getImagePath() : null;

    if (filePart != null && filePart.getSize() > 0) {
        // 새 이미지 업로드 처리 (서버 절대 경로 필요)
        String uploadPath = application.getInitParameter("FileLocation");
        java.nio.file.Path uploadDir = java.nio.file.Paths.get(uploadPath);

        String originalFileName = java.nio.file.Path.of(filePart.getSubmittedFileName()).getFileName().toString();
        imageFileName = System.currentTimeMillis() + "_" + originalFileName;

        java.nio.file.Path file = uploadDir.resolve(imageFileName);

        try (java.io.InputStream input = filePart.getInputStream()) {
            java.nio.file.Files.copy(input, file);
        }
    } else {
        // 새 이미지 없으면 기존 이미지 유지
        imageFileName = oldImage;
    }

    ProductDto dto = new ProductDto();
    dto.setNum(num);
    dto.setName(name);
    dto.setDescription(description);
    dto.setPrice(price);
    dto.setStatus(status);
    dto.setImagePath(imageFileName);

    boolean isSuccess = new ProductDao().update(dto);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/product/update.jsp</title>
</head>
<body>
<script>
    <% if (isSuccess) { %>
        alert("<%=name%> 상품의 정보를 성공적으로 수정했습니다");
        location.href = "list.jsp";
    <% } else { %>
        alert("수정 실패!");
        location.href = "updateform.jsp?num=<%=num%>";
    <% } %>
</script>
</body>
</html>
