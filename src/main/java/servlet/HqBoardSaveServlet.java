// servlet/HqBoardSaveServlet.java
package servlet;

import java.io.File;
import java.io.IOException;
import java.util.UUID;
import jakarta.servlet.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;
import dao.HqBoardDao;
import dao.HqBoardFileDao;  
import dto.HqBoardDto;
import dto.HqBoardFileDto;       

@WebServlet("/hqboard/save")
@MultipartConfig(
    fileSizeThreshold = 1024*1024*10,
    maxFileSize = 1024*1024*50,
    maxRequestSize = 1024*1024*100
)
public class HqBoardSaveServlet extends HttpServlet {
    private String fileLocation;

    @Override
    public void init() throws ServletException {
        fileLocation = getServletContext().getInitParameter("fileLocation");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
        throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        String writer = (String) req.getSession().getAttribute("userId");
        String title = req.getParameter("title");
        String content = req.getParameter("content");

        /* 시퀀스로 글번호 미리 확보 */
        int boardNum = HqBoardDao.getInstance().getSequence();

        // 글 DTO 세팅
        HqBoardDto dto = new HqBoardDto();
        dto.setNum(boardNum);     // 글번호 지정!
        dto.setWriter(writer);
        dto.setTitle(title);
        dto.setContent(content);

        // 글 insert
        boolean isSuccess = HqBoardDao.getInstance().insert(dto);

        /** 첨부파일 여러개 업로드 & DB 저장 **/
        if (isSuccess) {
            for (Part part : req.getParts()) {
            	  System.out.println("[첨부파일디버그] part name=" + part.getName() + ", size=" + part.getSize());
                if (part.getName().equals("myFile") && part.getSize() > 0) {
                	  System.out.println("[첨부파일디버그] 실제 파일 업로드: " + part.getSubmittedFileName());
                    String orgFileName = part.getSubmittedFileName();
                    String saveFileName = UUID.randomUUID() + "_" + orgFileName;
                    File uploadDir = new File(fileLocation);
                    if (!uploadDir.exists()) uploadDir.mkdirs();
                    part.write(fileLocation + File.separator + saveFileName);
                    long fileSize = part.getSize();

                    // 파일 DTO & DB 저장
                    HqBoardFileDto fileDto = new HqBoardFileDto();
                    fileDto.setBoardNum(boardNum);         // 글번호 FK
                    fileDto.setOrgFileName(orgFileName);
                    fileDto.setSaveFileName(saveFileName);
                    fileDto.setFileSize(fileSize);
                    System.out.println("[첨부파일디버그] boardNum=" + boardNum + ", orgFileName=" + orgFileName);
                    HqBoardFileDao.getInstance().insert(fileDto);
                }
            }
        }
        /** 첨부파일 처리 끝 **/

        if (isSuccess) {
            resp.sendRedirect(req.getContextPath() + "/headquater.jsp?page=/hqboard/hq-list.jsp");
        } else {
            req.setAttribute("errorMsg", "저장실패!");
            req.getRequestDispatcher("/hqboard/hq-new-form.jsp").forward(req, resp);
        }
    }
}
