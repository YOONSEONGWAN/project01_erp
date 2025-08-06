package servlet;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;

import dao.ProductDao;
import dto.ProductDto;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

@WebServlet("/product/update")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 10, // 10MB
    maxFileSize = 1024 * 1024 * 50,       // 50MB
    maxRequestSize = 1024 * 1024 * 60     // 60MB
)
public class UpdateServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String uploadPath = getServletContext().getInitParameter("fileLocation");
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdirs();

        // 파라미터 받기
        String numStr = request.getParameter("num");
        if (numStr == null || numStr.isEmpty()) {
            response.getWriter().println("상품 번호가 없습니다.");
            return;
        }
        int num = Integer.parseInt(numStr);

        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String priceStr = request.getParameter("price");
        int price = 0;
        try {
            price = Integer.parseInt(priceStr);
        } catch (Exception e) {
            price = 0; // 기본값
        }
        String status = request.getParameter("status");

        // 이미지 처리
        Part filePart = request.getPart("imagePath");
        String imageFileName = null;

        if (filePart != null && filePart.getSize() > 0) {
            String originalFileName = Path.of(filePart.getSubmittedFileName()).getFileName().toString();
            imageFileName = System.currentTimeMillis() + "_" + originalFileName;

            File file = new File(uploadDir, imageFileName);
            try (InputStream input = filePart.getInputStream()) {
                Files.copy(input, file.toPath());
            }
        } else {
            // 이미지 안 바꾸면 기존 이미지 유지
            // 기존 이미지 경로는 DB에서 직접 가져오자
            ProductDto existing = new ProductDao().getByNum(num);
            if (existing != null) {
                imageFileName = existing.getImagePath();
            }
        }

        ProductDto dto = new ProductDto();
        dto.setNum(num);
        dto.setName(name);
        dto.setDescription(description);
        dto.setPrice(price);
        dto.setStatus(status);
        dto.setImagePath(imageFileName);

        boolean success = new ProductDao().update(dto);

        if (success) {
            response.sendRedirect(request.getContextPath() + "/headquater.jsp?page=product/detail.jsp?num=" + num);
        } else {
            response.getWriter().println("Update Fail");
        }
    }
}
