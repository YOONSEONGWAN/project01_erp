package servlet;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.UUID;

import dao.HqBoardFileDao;
import dto.HqBoardFileDto;

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
    fileSizeThreshold = 1024*1024*10,
    maxFileSize = 1024*1024*50,
    maxRequestSize = 1024*1024*60
)
public class FileUpServlet extends HttpServlet {
    String fileLocation;

    @Override
    public void init() throws ServletException {
        ServletContext context = getServletContext();
        fileLocation = context.getInitParameter("fileLocation");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        String caption = req.getParameter("caption");
        // <input type="file" name="myFile"
        Part filePart = req.getPart("myFile");

        // 게시글 번호 얻기 
        /*********************/
        int boardNum = 0; // 글쓰기/수정 시 실제로 저장된 글 번호를 여기에 넣어줘야 함!
        // 예: boardNum = (글 저장 후 가져온 글 번호)
        try {
            String boardNumStr = req.getParameter("boardNum");
            boardNum = Integer.parseInt(boardNumStr);
        } catch (Exception e) {
            // 파라미터 없음/변환실패 시 boardNum은 0 (테스트용)
        }
        /*********************/

        if (filePart != null && filePart.getSize() > 0) {
            String orgFileName = filePart.getSubmittedFileName();
            String uid = UUID.randomUUID().toString();
            String saveFileName = uid + orgFileName;
            String filePath = fileLocation + "/" + saveFileName;

            InputStream is = filePart.getInputStream();
            Files.copy(is, Paths.get(filePath));
            long fileSize = filePart.getSize();

            req.setAttribute("orgFileName", orgFileName);
            req.setAttribute("saveFileName", saveFileName);
            req.setAttribute("fileSize", fileSize);

            /*********************/
            // 첨부파일 정보를 DB(hqboard_file)에 저장
            HqBoardFileDto fileDto = new HqBoardFileDto();
            fileDto.setBoardNum(boardNum); // ★글번호 반드시 세팅
            fileDto.setOrgFileName(orgFileName);
            fileDto.setSaveFileName(saveFileName);
            fileDto.setFileSize(fileSize);
            // DB 저장 (실패시 예외 로그만)
            boolean isSuccess = HqBoardFileDao.getInstance().insert(fileDto);
            if (!isSuccess) {
                System.out.println("첨부파일 DB 저장 실패");
            }
            /*********************/
        }

        RequestDispatcher rd = req.getRequestDispatcher("/test/hq-save.jsp");
        rd.forward(req, resp);
    }
}
