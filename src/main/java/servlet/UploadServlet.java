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

@WebServlet("/product/register")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 10,
    maxFileSize = 1024 * 1024 * 50,
    maxRequestSize = 1024 * 1024 * 60
)
public class UploadServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // context-param 에서 절대 경로 읽기
        String uploadPath = getServletContext().getInitParameter("fileLocation");

        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdirs();

        String name = request.getParameter("name");
        String description = request.getParameter("description");
        int price = Integer.parseInt(request.getParameter("price"));
        String status = request.getParameter("status");

        Part filePart = request.getPart("imagePath");
        String imageFileName = null;

        if (filePart != null && filePart.getSize() > 0) {
            String originalFileName = Path.of(filePart.getSubmittedFileName()).getFileName().toString();
            imageFileName = System.currentTimeMillis() + "_" + originalFileName;

            File file = new File(uploadDir, imageFileName);
            try (InputStream input = filePart.getInputStream()) {
                Files.copy(input, file.toPath());
            }
        }

        ProductDto dto = new ProductDto();
        dto.setName(name);
        dto.setDescription(description);
        dto.setPrice(price);
        dto.setStatus(status);
        dto.setImagePath(imageFileName);

        int insertedNum = new ProductDao().insert1(dto);

        if (insertedNum > 0) {
        	response.sendRedirect(request.getContextPath() + "/product/detail.jsp?num=" + insertedNum);

        } else {
            response.getWriter().println("DB SAVE FAIL");
        }
    }
}

