package servlet;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.Collection;
import java.util.UUID;

import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import dao.GalleryDao;
import dto.GalleryDto;
import dto.GalleryImageDto;

@WebServlet("/gallery/save")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 10,
    maxFileSize = 1024 * 1024 * 50,
    maxRequestSize = 1024 * 1024 * 100
)
public class HqGallerySaveServlet extends HttpServlet {

    private String fileLocation;

    @Override
    public void init() throws ServletException {
        ServletContext context = getServletContext();
        fileLocation = context.getInitParameter("fileLocation");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
        throws ServletException, IOException {

        //글 작성자는 세션 객체로 부터 얻어낸다.
    	String writer=(String)req.getSession().getAttribute("userName");
    	
        String title = req.getParameter("title");
        String content = req.getParameter("content");

        // DAO 인스턴스 준비
        GalleryDao dao = GalleryDao.getInstance();

        // 시퀀스 미리 발급
        int galleryNum = dao.getSequence();

        // gallery 테이블에 저장
        GalleryDto dto = new GalleryDto();
        dto.setNum(galleryNum);
        dto.setTitle(title);
        dto.setWriter(writer);
        dto.setContent(content);
        
        dao.insert(dto);

        
        Collection<Part> parts=req.getParts();
        
        // 이미지 저장
        for (Part part : parts ) {
        	
            if (part.getName().equals("images") && part.getSize() > 0) {
                String orgFileName = part.getSubmittedFileName();
                String uuid = UUID.randomUUID().toString();
                String saveFileName = uuid + orgFileName;
                String filePath = fileLocation + "/" + saveFileName;

                try (InputStream is = part.getInputStream()) {
                    Files.copy(is, Paths.get(filePath));
                }

                // gallery_image 테이블에 저장
                GalleryImageDto imageDto = new GalleryImageDto();
                imageDto.setGalleryNum(galleryNum);
                imageDto.setSaveFileName(saveFileName);
                dao.insertImage(imageDto);
            }
        }

        // 성공 후 목록으로 리디렉션
        resp.sendRedirect(req.getContextPath() + "/hqboard/list.jsp");
    }
}