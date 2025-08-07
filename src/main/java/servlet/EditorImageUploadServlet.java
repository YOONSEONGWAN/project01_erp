// servlet/EditorImageUploadServlet.java
package servlet;

import java.io.File;
import java.io.IOException;
import java.util.UUID;
import jakarta.servlet.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;

@WebServlet("/image-upload")
@MultipartConfig(
    fileSizeThreshold = 1024*1024*10,
    maxFileSize = 1024*1024*50,
    maxRequestSize = 1024*1024*100
)
public class EditorImageUploadServlet extends HttpServlet {
    private String fileLocation;

    @Override
    public void init() throws ServletException {
        fileLocation = getServletContext().getInitParameter("fileLocation");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
        throws ServletException, IOException {

        Part filePart = req.getPart("myFile");  // 에디터에서 'myFile'로 전송
        String url = "";
        if (filePart != null && filePart.getSize() > 0) {
            String orgFileName = filePart.getSubmittedFileName();
            String saveFileName = UUID.randomUUID() + "_" + orgFileName;
            File uploadDir = new File(fileLocation);
            if (!uploadDir.exists()) uploadDir.mkdirs();
            filePart.write(fileLocation + File.separator + saveFileName);

         // 절대경로(풀 URL)로 이미지 URL 생성
            String scheme = req.getScheme(); // http 또는 https
            String serverName = req.getServerName(); // ex: localhost
            int serverPort = req.getServerPort(); // ex: 8888
            String contextPath = req.getContextPath(); // ex: /project01_erp
            
            String baseUrl = scheme + "://" + serverName + ":" + serverPort + contextPath;
            url = baseUrl + "/image?name=" + saveFileName;
        }
        // JSON 응답 (ToastUI 에디터의 callback에 사용됨)
        resp.setContentType("application/json; charset=UTF-8");
        resp.getWriter().write("{\"url\":\"" + url + "\"}");
    }
}
