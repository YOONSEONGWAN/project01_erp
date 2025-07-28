package branch.servlet;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;

import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
/*
 * 	이 서블릿은 upload 폴더에 저장된 이미지 데이터를 응답하는 서블릿
 * 
 * -SecurityFileter 에 whiteList 에 "/upload/" 를 추가 해야 동작한다.
 * 
 * -upload/xx.png , /upload/xxx.jpg 형식의 요청을 이 서블릿에서 처리 합니다.
 * 
 * - img 요소에 특징 이미지를 보여주려면 <img src="컨택스트경로/upload/저장된파일명"> 형식으로 코딩하면 된다
 * 
 */

@WebServlet("/upload2/*")
public class ImageServlet extends HttpServlet{

	// 이미지 저장 경로 
    private  String fileLocation;
    
    @Override
    public void init() throws ServletException {
        ServletContext context = getServletContext();
        fileLocation = context.getInitParameter("fileLocation");
    }
    
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        
        // 1. URL 경로에서 이미지 이름 추출
        String pathInfo = request.getPathInfo(); // 예: /xxx.jpg
        if (pathInfo == null || pathInfo.equals("/")) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Image name missing.");
            return;
        }
        //맨앞에 / 제거
        String imageName = pathInfo.substring(1); // "xxx.jpg"

        // 2. 파일 전체 경로 구성
        File imageFile = new File(fileLocation, imageName);

        // 3. 파일 존재 여부 확인
        if (!imageFile.exists() || imageFile.isDirectory()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Image not found.");
            return;
        }

        // 4. MIME 타입 설정 (ex: image/jpeg)
        String mimeType = request.getServletContext().getMimeType(imageFile.getName());
        if (mimeType == null) mimeType = "application/octet-stream";
        response.setContentType(mimeType);
        response.setContentLengthLong(imageFile.length());

        // 5. 파일을 바이너리로 스트리밍
        try (
            FileInputStream fis = new FileInputStream(imageFile);
            OutputStream os = response.getOutputStream();
        ) {
            byte[] buffer = new byte[8192];
            while(true) {
            	int readedByte=fis.read(buffer);
            	if(readedByte == -1)break;
            	os.write(buffer, 0, readedByte);
            	os.flush();
            }
        }
    }
}


