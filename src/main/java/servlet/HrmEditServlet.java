package servlet;

import java.io.IOException;

import dao.HrmDao;
import dto.HrmDto;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/hrm/edit")
public class HrmEditServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String numParam = request.getParameter("num");

		if (numParam == null || numParam.trim().isEmpty()) {
			response.getWriter().println("ERROR: num 파라미터가 없습니다.");
			return;
		}

		int num;
		try {
			num = Integer.parseInt(numParam);
		} catch (NumberFormatException e) {
			response.getWriter().println("ERROR: num 파라미터가 숫자가 아닙니다.");
			return;
		}

		HrmDto dto = new HrmDao().getByNum(num); // DB에서 직원 정보 가져오기

		if (dto == null) {
			response.getWriter().println("ERROR: 해당 직원이 존재하지 않습니다.");
			return;
		}

		request.setAttribute("dto", dto); // JSP에 dto 넘기기
		request.getRequestDispatcher("/hrm/profileimage.jsp").forward(request, response);
	}
}
