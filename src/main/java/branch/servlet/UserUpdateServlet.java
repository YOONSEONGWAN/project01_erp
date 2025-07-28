package branch.servlet;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.UUID;

import branch.dao.UserDao;
import branch.dto.UserDto;
import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
/*
 *  enctype="multipart/form-data" 형식의 폼이 전송되었을때 처리할 서블릿 만들기 
 */
@WebServlet("/user2/update2")
@MultipartConfig(
	fileSizeThreshold = 1024*1024*10, //업로드 처리하기 위한 메모리 사이즈(10 Mega byte)
	maxFileSize = 1024*1024*50, //업로드되는 최대 파일 사이즈(50 Mega byte)
	maxRequestSize = 1024*1024*60 //이 요청의 최대 사이즈(60 Mega byte), 파일외의 다른 문자열도 전송되기 때문에
)
public class UserUpdateServlet extends HttpServlet{
	
	//업로드된 파일 저장경로를 저장할 필드 선언
	String fileLocation;
	
	//이 서블릿이 초기화되는 시점에 최초 1번 호출되는 메소드 
	@Override
	public void init() throws ServletException {
		//무언가 초기화 작업을 여기서 하면된다.
		ServletContext context = getServletContext();
		// web.xml 파일에 "fileLocation" 이라는 이름으로 저장된 정보 읽어와서 필드에 저장하기 
        fileLocation = context.getInitParameter("fileLocation");
        System.out.println("[UserUpdateServlet] fileLocation = " + fileLocation);
	}
	
	
	// post 방식 전송되었을때 호출되는 메소드 
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		// 폼 전송되는 내용 추출
		// JSP에서 넘어온 모든 파라미터들을 String 변수에 담아두자!
		String userName = req.getParameter("userName");
		String branchNum = req.getParameter("branchNum");
		String phoneNum = req.getParameter("phoneNum");
		String grade = req.getParameter("grade"); // 추가된 'grade' 파라미터
		String myLocation = req.getParameter("myLocation");
		String branchLocation = req.getParameter("branchLocation");
		
		// 파일데이터 (<input type="file" name="profileImage">)
		Part filePart = req.getPart("profileImage");
		
		// DB 에서 현재 사용자 정보를 불러온다.
		UserDto dto = UserDao.getInstance().getByUserName(userName);
		
		// DTO에 폼에서 받아온 최신 정보들을 먼저 설정한다.
		// 이렇게 하면 파일 업로드 여부와 관계없이 항상 최신 정보가 반영될 수 있어!
		dto.setBranchNum(branchNum);
		dto.setPhoneNum(phoneNum);
		dto.setGrade(grade); // DTO에도 'grade'를 설정하는 메소드가 필요해!
		dto.setMyLocation(myLocation);
		dto.setBranchLocation(branchLocation);

		// 만일 업로드된 프로필 이미지가 있다면 (파일이 선택되었다면)
		if(filePart != null && filePart.getSize() > 0) {
			// 원본 파일의 이름 얻어내기
			String orgFileName = filePart.getSubmittedFileName();
			// 파일명이 겹치지 않게 랜덤한 id 값 얻어내기
			String uid = UUID.randomUUID().toString();
			// 저장될 파일명을 구성한다 (고유한 이름 + 원본 파일 확장자)
            // orgFileName이 null 이거나 비어있을 수도 있으므로, 안전하게 처리
            String fileExtension = "";
            if (orgFileName != null && orgFileName.lastIndexOf(".") != -1) {
                fileExtension = orgFileName.substring(orgFileName.lastIndexOf("."));
            }
			String saveFileName = uid + fileExtension;
			// 저장할 파일의 전체 경로 구성하기
			String filePath = fileLocation + "/" + saveFileName;
			
			/*
			 * 업로드된 파일은 임시 폴더에 임시 파일로 저장이 된다.
			 * 해당 파일에서 byte 알갱이를 읽어 들일수 있는 InputStream 객체를 얻어내서 
			 */
			InputStream is = filePart.getInputStream();
			// 원하는 목적지 (filePath) 로 파일을 복사한다.
			Files.copy(is,  Paths.get(filePath));
			System.out.println("Saved: " + filePath);
			
			// 기존에 이미 저장된 프로필 사진이 있으면 파일 시스템에서 삭제하기 
			if(dto.getProfileImage() != null) {
				// 삭제할 파일의 전체 경로 
				String deleteFilePath = fileLocation + "/" + dto.getProfileImage();
				// Files 클래스의 delete() 메소드를 이용해서 삭제하기 
				Files.deleteIfExists(Paths.get(deleteFilePath)); // 파일이 없어도 에러나지 않도록 `deleteIfExists` 사용
			}
			
			// dto 에 저장된 파일명을 담는다. (이게 새 프로필 이미지 이름이 됨)
			dto.setProfileImage(saveFileName);
		} 
		// 모든 정보가 담긴 dto 객체를 DAO를 통해 DB에 업데이트한다.
		// 이제 이 메소드 하나로 프로필 이미지 유무와 상관없이 모든 사용자 정보가 업데이트돼!
		UserDao.getInstance().updateProfile(dto); // 이 메소드가 UserDto의 모든 필드를 업데이트하도록 설계되어야 해!
		
		// 리다이렉트 응답
		String cPath = req.getContextPath();
		resp.sendRedirect(cPath + "/user2/info2.jsp");
	}
}