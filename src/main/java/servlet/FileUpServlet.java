package servlet;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.UUID;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

@WebServlet("/test/fileup")
@MultipartConfig(
		fileSizeThreshold = 1024*1024*10, // 업로드 처리하기 위한 메모리 사이즈(10MB)
		maxFileSize = 1024*1024*50, // 업로드 되는 최대 파일 사이즈 (50MB)
		maxRequestSize = 1024*1024*60 // 이 요청의 최대 사이즈 (60MB), 파일 외에 다른 문자열도 전송되기 때문에 
	)// 멀티파트 어노테이션이 필요.
public class FileUpServlet extends HttpServlet {
	// 필드 선언 
	String fileLocation; 
	
	// 이 서블릿이 초기화 되는 시점에 최초 1번 호출
		@Override
		public void init() throws ServletException {
			ServletContext context = getServletContext();
			// web.xml 파일에 "fileLocation" 이란 이름으로 저장된 정보 읽어와서 필드에 저장
			fileLocation = context.getInitParameter("fileLocation");
			// web.xml에서 지정해둔 경로
		}
		@Override
		protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
			
			String caption=req.getParameter("caption");
			// <input type="file" name="myFile"
			Part filePart = req.getPart("myFile");
			
			// 파일 이름과 경로 구성
			if(filePart!=null && filePart.getSize()>0) {
				
				// 원본 파일의 이름
				String orgFileName=filePart.getSubmittedFileName(); 
				// 파일명이 겹치지 않게 랜덤한 id 값 얻기
				String uid=UUID.randomUUID().toString();
				// 저장될 파일명 구성
				String saveFileName=uid+orgFileName;
				// 저장할 파일의 경로 구성하기. 이걸 아래 filePath 매개변수로 보냄. 
				String filePath=fileLocation+"/"+saveFileName;
				
				
				InputStream is=filePart.getInputStream(); 
				Files.copy(is, Paths.get(filePath)); 
				long fileSize = filePart.getSize();
				
				req.setAttribute("orgFileName", orgFileName); // String type
				req.setAttribute("saveFileName", saveFileName); // String type
				req.setAttribute("fileSize", fileSize); // long type
				
				
			} // end if
			
			// 요청 전달자 객체 얻어내기
			RequestDispatcher rd=req.getRequestDispatcher("/test/hq-save.jsp");
			// 응답을 위임하기
			rd.forward(req, resp); // req resp 객체를 전달해준다. 
			
		} // end method
} // end class
