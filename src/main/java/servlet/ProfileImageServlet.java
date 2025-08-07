package servlet;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;

import dao.HrmDao;
import dto.HrmDto;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

@WebServlet("/hrm/register")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 10, maxFileSize = 1024 * 1024 * 50, maxRequestSize = 1024 * 1024
		* 60)
public class ProfileImageServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		request.setCharacterEncoding("UTF-8");

		// context-param 에서 절대 경로 읽기
		String uploadPath = getServletContext().getInitParameter("fileLocation");

		File uploadDir = new File(uploadPath);
		if (!uploadDir.exists())
			uploadDir.mkdirs();

		String name = request.getParameter("name");
		String grade = request.getParameter("role");

		Part filePart = request.getPart("profile_image");
		String imageFileName = null;

		if (filePart != null && filePart.getSize() > 0) {
			String originalFileName = Path.of(filePart.getSubmittedFileName()).getFileName().toString();
			imageFileName = System.currentTimeMillis() + "_" + originalFileName;

			File file = new File(uploadDir, imageFileName);
			try (InputStream input = filePart.getInputStream()) {
				Files.copy(input, file.toPath());
			}
		}
		String numParam = request.getParameter("num");
		if (numParam == null || numParam.trim().equals("")) {
			response.getWriter().println("ERROR: num 파라미터가 없습니다.");
			return;
		}
		int num = Integer.parseInt(numParam);

		HrmDto dto = new HrmDto();
		dto.setNum(num); // 🔥 이거 없으면 getNum() 못 써
		dto.setName(name);
		dto.setProfileImage(imageFileName);

		boolean isSuccess = new HrmDao().updateProfileImage(num, imageFileName);

		if (isSuccess) {
			response.sendRedirect(request.getContextPath() + "/hrm/detail.jsp?num=" + dto.getNum());
		} else {
			response.getWriter().println("DB SAVE FAIL");
		}
	}
}
