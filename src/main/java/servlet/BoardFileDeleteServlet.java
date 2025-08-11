package servlet;

import java.io.File;
import java.io.IOException;

import dao.BoardFileDao;
import dto.BoardFileDto;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/board/file-delete")
public class BoardFileDeleteServlet extends HttpServlet {
    private String fileLocation;

    @Override
    public void init() throws ServletException {
        fileLocation = getServletContext().getInitParameter("fileLocation");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String fileIdParam = req.getParameter("fileId");
        String boardNumParam = req.getParameter("boardNum");
        String boardType = req.getParameter("boardType");

        if (fileIdParam == null || boardNumParam == null || boardType == null) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        int fileId = Integer.parseInt(fileIdParam);

        // 1) DB에서 파일 정보 조회
        BoardFileDto fileDto = BoardFileDao.getInstance().getByNum(fileId);
        if (fileDto != null) {
            // 2) DB에서 삭제
            BoardFileDao.getInstance().delete(fileId);

            // 3) 실제 파일 삭제
            File file = new File(fileLocation, fileDto.getSaveFileName());
            if (file.exists()) {
                file.delete();
            }
        }

        // 4) 원래 글 보기로 리다이렉트
        resp.sendRedirect(req.getContextPath() + "/board/view.jsp?num=" + boardNumParam + "&board_type=" + boardType);
    }
}