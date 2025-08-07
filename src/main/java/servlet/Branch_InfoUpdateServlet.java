package servlet;

import java.io.IOException;

import dao.BranchInfoDao;
import dto.BranchInfoDto;
import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/branchinfo/update")
@MultipartConfig(
	fileSizeThreshold = 1024 * 1024 * 10,
	maxFileSize = 1024 * 1024 * 50,
	maxRequestSize = 1024 * 1024 * 60
)
public class Branch_InfoUpdateServlet extends HttpServlet {

	String fileLocation;

	@Override
	public void init() throws ServletException {
		ServletContext context = getServletContext();
		fileLocation = context.getInitParameter("fileLocation");
		System.out.println("[UserUpdateServlet] fileLocation = " + fileLocation);
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		req.setCharacterEncoding("UTF-8");

		String user_id = req.getParameter("userId");
		String user_address = req.getParameter("branchAddress");
		String branch_phone = req.getParameter("branchPhone");
		String user_role = req.getParameter("userRole");

		// DB에서 사용자 정보 조회
		BranchInfoDto dto = BranchInfoDao.getInstance().getByUserId(user_id);

		// 폼에서 받은 정보로 DTO 업데이트
		dto.setUser_id(user_id);
		dto.setBranch_address(user_address);
		dto.setBranch_phone(branch_phone);
		dto.setUser_role(user_role);

		// DB 업데이트 수행
		boolean isSuccess = BranchInfoDao.getInstance().BranchupdateInfo(
			    dto.getUser_id(),
			    dto.getBranch_address(),
			    dto.getBranch_phone(),
			    dto.getUser_role()
			);

		// 결과에 따른 리다이렉트
		String cPath = req.getContextPath();
		if (isSuccess) {
			resp.sendRedirect(cPath + "/branchinfo/info2.jsp?success=1");
		} else {
			resp.sendRedirect(cPath + "/branchinfo/info2.jsp?error=1");
		}
	}
}