// servlet/HqBoardUpdateServlet.java
package servlet;

import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.UUID;
import jakarta.servlet.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;
import dao.HqBoardDao;
import dao.HqBoardFileDao;
import dto.HqBoardDto;
import dto.HqBoardFileDto;

@WebServlet("/hqboard/update")
@MultipartConfig(
    fileSizeThreshold = 1024*1024*10,
    maxFileSize = 1024*1024*50,
    maxRequestSize = 1024*1024*100
)
public class HqBoardUpdateServlet extends HttpServlet {
    private String fileLocation;

    @Override
    public void init() throws ServletException {
        fileLocation = getServletContext().getInitParameter("fileLocation");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
        throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        int num = Integer.parseInt(req.getParameter("num"));
        String title = req.getParameter("title");
        String content = req.getParameter("content");
        String writer = (String) req.getSession().getAttribute("userId");

        // 1. 글 내용만 업데이트 (파일정보 X)
        HqBoardDto dto = new HqBoardDto();
        dto.setNum(num);
        dto.setTitle(title);
        dto.setContent(content);
        dto.setWriter(writer);
        boolean isSuccess = HqBoardDao.getInstance().update(dto);

        /*** 직접 삭제/추가 로직 ***/
        if (isSuccess) {
            // (1) 삭제 체크된 파일만 삭제
            String[] deleteFileNums = req.getParameterValues("deleteFile");
            if (deleteFileNums != null) {
                for (String fileNumStr : deleteFileNums) {
                    int fileNum = Integer.parseInt(fileNumStr);
                    // 실제 파일 삭제
                    HqBoardFileDto fileDto = HqBoardFileDao.getInstance().getByNum(fileNum);
                    if (fileDto != null) {
                        File delFile = new File(fileLocation, fileDto.getSaveFileName());
                        if (delFile.exists()) delFile.delete();
                        // DB에서 삭제
                        HqBoardFileDao.getInstance().delete(fileNum);
                    }
                }
            }

            // (2) 새로 첨부된 파일만 추가
            for (Part part : req.getParts()) {
                if (part.getName().equals("myFile") && part.getSize() > 0) {
                    String orgFileName = part.getSubmittedFileName();
                    String saveFileName = UUID.randomUUID() + "_" + orgFileName;
                    File uploadDir = new File(fileLocation);
                    if (!uploadDir.exists()) uploadDir.mkdirs();
                    part.write(fileLocation + File.separator + saveFileName);

                    // DB에 저장
                    HqBoardFileDto fileDto = new HqBoardFileDto();
                    fileDto.setBoardNum(num);
                    fileDto.setOrgFileName(orgFileName);
                    fileDto.setSaveFileName(saveFileName);
                    fileDto.setFileSize(part.getSize());
                    HqBoardFileDao.getInstance().insert(fileDto);
                }
            }
        }
        /*** 첨부파일 처리 끝 ***/

        if (isSuccess) {
            resp.sendRedirect(req.getContextPath() + "/headquater.jsp?page=/hqboard/hq-view.jsp?num=" + num);
        } else {
            req.setAttribute("errorMsg", "수정실패!");
            req.setAttribute("num", num);
            req.getRequestDispatcher("/hqboard/hq-edit.jsp").forward(req, resp);
        }
    }
}
