package servlet;

import java.io.IOException;
import dao.ProductDao;
import dto.ProductDto;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/product/updateform")
public class UpdateFormServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        String numStr = request.getParameter("num");
        if (numStr == null || numStr.isEmpty()) {
            response.getWriter().println("상품 번호가 없습니다.");
            return;
        }

        int num;
        try {
            num = Integer.parseInt(numStr);
        } catch (NumberFormatException e) {
            response.getWriter().println("잘못된 상품 번호입니다.");
            return;
        }

        ProductDto dto = new ProductDao().getByNum(num);
        if (dto == null) {
            response.getWriter().println("존재하지 않는 상품입니다.");
            return;
        }

        // JSP에 데이터 전달
        request.setAttribute("dto", dto);

        // headquater.jsp로 포워드하면서 page 파라미터에 updateform.jsp 지정
        request.getRequestDispatcher("/headquater.jsp?page=/product/updateform.jsp").forward(request, response);
    }
}
