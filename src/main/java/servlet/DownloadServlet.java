package servlet;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.net.URLEncoder;

import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/test/download")
public class DownloadServlet extends HttpServlet {
	// 필드 선언 (
		String fileLocation; // c:/playground/upload 이걸 여기에 하드코딩하면 번거로워진다.
		
		// 서블릿이 초기화 되는 시점에 최초 1번 호출되는 메소드 
	@Override
	public void init() throws ServletException { 
		ServletContext context = getServletContext();
		// web.xml 파일에 "fileLocation" 으로 저장된 정보 읽어와서 필드에 저장
		fileLocation = context.getInitParameter("fileLocation");
		// (web.xml에서 지정해둔 경로)
	}
	
	// 파일 다운로드 코드 템플릿 -> 파라미터명과 변수만 바꾸면 됨 
	@Override
	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// get 방식 파라미터로 전달되는 다운로드 파일 값 받기
		String orgFileName=request.getParameter("orgFileName");
		String saveFileName=request.getParameter("saveFileName");
		long fileSize = Long.parseLong(request.getParameter("fileSize"));
		
		//응답 헤더 정보 설정
		response.setHeader("Content-Type", "application/octet-stream; charset=UTF-8");
		//다운로드 시켜줄 파일명 인코딩  
			String encodedName=URLEncoder.encode(orgFileName, "utf-8");
		//파일명에 공백이있는 경우 처리 
		encodedName=encodedName.replaceAll("\\+"," ");
		
		response.setHeader("Content-Disposition", "attachment;filename="+encodedName);
		response.setHeader("Content-Transfer-Encoding", "binary");
		
		//다운로드할 파일의 크기
		response.setContentLengthLong(fileSize);
		
		//다운로드 시켜줄 파일의 실제 경로
		String path=fileLocation+File.separator+saveFileName;
		
		FileInputStream fis=null;
		BufferedOutputStream bos=null;
		try {
			//파일에서 byte 을 읽어들일 객체
			fis=new FileInputStream(path);
			//클라이언트에게 출력할수 있는 스트림 객체 얻어오기
			bos=new BufferedOutputStream(response.getOutputStream());
			//한번에 최대 1M byte 씩 읽어올수 있는 버퍼
		   	byte[] buffer=new byte[1024*1024];
		   	int readedByte=0;
		   	//반복문 돌면서 출력해주기
		   	while(true) {
		   		//byte[] 객체를 이용해서 파일에서 byte 알갱이 읽어오기
		   		readedByte = fis.read(buffer);
		   		if(readedByte == -1)break; //더이상 읽을 데이터가 없다면 반복문 빠져 나오기
		   		//읽은 만큼 출력하기
		   		bos.write(buffer, 0, readedByte);
		   		bos.flush(); //출력
		   	}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			if(fis!=null)fis.close();
			if(bos!=null)bos.close();
		}		
	}
}
		
