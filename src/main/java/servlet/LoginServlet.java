package servlet;

import java.io.IOException;

import dao.UserDao;
import dto.UserDto;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String userId = request.getParameter("userId");
		String password = request.getParameter("password");

		// DAO 를 통해 사용자 정보 조회
		UserDto user = UserDao.getInstance().getByCredentials(userId, password);

		if (user != null) {
			// ✅ 로그인 성공 → 세션에 저장
			HttpSession session = request.getSession();
			session.setAttribute("user_name", user.getUser_name());
			session.setAttribute("branch_id", user.getBranch_id()); // 지점회원 여부 확인용
			session.setAttribute("role", user.getRole()); // 선택적: HQ, branch 등

			response.sendRedirect(request.getContextPath() + "/index.jsp");
		} else {
			// ❌ 로그인 실패
			request.setAttribute("error", "아이디 또는 비밀번호가 일치하지 않습니다.");
			request.getRequestDispatcher("/userp/loginform.jsp").forward(request, response);
		}
		
	}
	
	@Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // JSP 위치에 맞춰 경로 지정
        req.getRequestDispatcher("/board/view.jsp").forward(req, resp);
        // 또는 req.getRequestDispatcher("/login.jsp").forward(req, resp);
    }
    // doPost는 기존 로그인 처리 그대로
}
